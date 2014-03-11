package com.core
{
	import com.adobe.utils.*;
	import com.mu.*;
	import flash.display3D.*;
	import flash.geom.*;
	import com.shader.*;

	public class SubMeshBase extends Object3D
	{
		public var soft:Boolean = false;
		public var img:String;
		
		protected var context3D:Context3D;
		protected var program:Program3D;
		protected var vertexbuffer:VertexBuffer3D;
		protected var indexbuffer:IndexBuffer3D;
		
		protected var _rawVertex:Vector.<Number>;
		protected var _rawIndices:Vector.<uint>;
		protected var _texture:TextureBase;
		protected var _model:MuModel;
		
		public function SubMeshBase(context3d:Context3D, model:MuModel=null)
		{
			this.context3D = context3d;
			_model = model;
			z = 1;
			x = 4;
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
			
			var arr:Array = GLSLShader.shader2;
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler(true);
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX, arr[0]);
			
			var fragmentShaderAssembler:AGALMiniAssembler= new AGALMiniAssembler(true);
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT, arr[1]);
			
			program = context3D.createProgram();
			program.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
		}
		
		private var r:Number=0;
		public function render(frame:int):void
		{
			if (!_texture.ok) return;
			
			rotationZ += 5;
			
			var m:Matrix3D = Main.ccamera.m.clone();
			m.prependTranslation(x, y, z);
			m.prependScale(scale, scale, scale);
			m.prependRotation(rotationX, Vector3D.X_AXIS)
			m.prependRotation(rotationY, Vector3D.Y_AXIS);
			m.prependRotation(rotationZ, Vector3D.Z_AXIS)
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 1, m, true);	
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, Vector.<Number>([1, 0, 0, 0]));
			
			if (_model.animation.isOK) {
				var newv:Vector.<Number> = computeNew(frame);
				vertexbuffer.uploadFromVector(newv, 0, newv.length / 6);
			}
			
			context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setTextureAt(0, _texture.texture);
			context3D.setProgram(program);
			context3D.drawTriangles(indexbuffer);
			
			//clear
			context3D.setVertexBufferAt(0,null);
			context3D.setVertexBufferAt(1, null);
			context3D.setTextureAt(0, null);
		}
		
		private function computeNew(frame:int):Vector.<Number> {
			var newVertex:Vector.<Number> = new Vector.<Number>();
			
			for (var i:int = 0; i < _rawVertex.length; i += 6) {				
				var v1:Vector3D = _model.animation.computeVertex(_rawVertex[i], _rawVertex[i + 1], _rawVertex[i + 2], frame, _rawVertex[i + 5] / 2);
				//var v1:Vector3D = GeomTool.m44(v, m);	//在CPU中提前与转换矩阵计算，shader里改成 mov op, va1
				//trace(v1.x + "_" + v1.y+ "_" + v1.z);
				newVertex.push(v1.x, v1.y, v1.z, _rawVertex[i + 3], _rawVertex[i + 4], _rawVertex[i + 5]);
			}
			return newVertex;
		}
	}
}
