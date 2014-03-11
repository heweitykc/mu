package com.core
{
	import com.adobe.utils.*;
	import com.mu.*;
	import flash.display3D.*;
	import flash.geom.*;
	import com.shader.Shaders;

	public class SubMeshGPU extends Object3D
	{
		public var img:String;
		
		protected var context3D:Context3D;
		protected var program:Program3D;
		protected var vertexbuffer:VertexBuffer3D;
		protected var indexbuffer:IndexBuffer3D;
		
		protected var _rawVertex:Vector.<Number>;
		protected var _rawIndices:Vector.<uint>;
		protected var _texture:TextureBase;
		protected var _model:MuModel;
		
		public function SubMeshGPU(context3d:Context3D, model:MuModel=null)
		{
			this.context3D = context3d;
			_model = model;
			z = 0.5;
			rotationX = 90;
			rotationY = -180;
		}
		
		public function upload(rawVertex:Vector.<Number>, rawIndices:Vector.<uint>):void
		{
			_rawVertex = rawVertex;
			_rawIndices = rawIndices;
			generate();
			
			if (!img) return;
			
			_texture = new TextureBase(context3D);
			_texture.load(img);
		}
		
		private function generate():void
		{	
			vertexbuffer = context3D.createVertexBuffer(_rawVertex.length / 6, 6);
			indexbuffer = context3D.createIndexBuffer(_rawIndices.length);						
			indexbuffer.uploadFromVector(_rawIndices, 0, _rawIndices.length);
			vertexbuffer.uploadFromVector(_rawVertex, 0, _rawVertex.length / 6);
			
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler(true);
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX, Shaders.GLShader[0]);
			
			var arr:Array = Shaders.GLShader[0].split("\n");
			trace(GeomTool.formatShader(arr));
			var fragmentShaderAssembler:AGALMiniAssembler= new AGALMiniAssembler(true);
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT, Shaders.GLShader[1]);
			
			program = context3D.createProgram();
			var shaders:Array = ShaderUtil.shader3;
			program.upload(shaders[0], shaders[1]);
		}
		
		private var r:Number=0;
		public function render(frame:int):void
		{
			if (!_texture.ok) return;
			if (!_model.animation.isOK) return;
			
			//设置该帧的骨骼参数
			var animateData:Array = _model.animation.getBoneAnimation(frame);
			for (var i:int = 0; i < animateData.length; i += 2) {
				setVC(animateData, i);
			}
			var m:Matrix3D = Main.ccamera.m.clone();
			m.prependRotation(rotationX, Vector3D.X_AXIS)
			m.prependRotation(rotationY, Vector3D.Y_AXIS);
			m.prependRotation(rotationZ, Vector3D.Z_AXIS)
			m.prependTranslation(x, y, z);
			m.prependScale(scale, scale, scale);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, Vector.<Number>([2, 1, 0, 0]));
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 1, m, true);
			
			context3D.setVertexBufferAt(0, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setTextureAt(0, _texture.texture);
			context3D.setProgram(program);
			context3D.drawTriangles(indexbuffer);
			
			context3D.setVertexBufferAt(0,null);
			context3D.setVertexBufferAt(1, null);
		}
		
		private var _startIndex:int = 0;
		private function setVC(data:Array, i:int):void
		{
			var v0:Vector.<Number> = data[i];		//6个float
			var  v1:Vector.<Number> = data[i + 1];	//6个float
			//if(v1) v0 = v0.concat(v1);			//最后一个可能是空
			v0[3] *= 0.5;	//shader中需要*0.5
			v0[4] *= 0.5;
			v0[5] *= 0.5;
			v1[3] *= 0.5;	//shader中需要*0.5
			v1[4] *= 0.5;
			v1[5] *= 0.5;
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, _startIndex + i*2, v0);		//1根骨头用到了2个寄存器
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, _startIndex + (i+1)*2, v1);	//1根骨头用到了2个寄存器
			
			//trace("寄存器" + (_startIndex + i*2) + ",    " + v0.join("|"));
		}
	}
}
