package com.core
{
	import com.adobe.utils.*;
	import com.mu.*;
	import flash.display3D.*;
	import flash.geom.*;
	import com.shader.*;

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
		protected var _model:MuModelGPU;
		
		private var _usedBones:Array;
		
		public function SubMeshGPU(context3d:Context3D, model:MuModelGPU=null)
		{
			this.context3D = context3d;
			_model = model;
			z = 1;
			x = 0;
			rotationX = 90;
			rotationY = -180;
			_usedBones = [];
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
		
		public function addBone(boneIndex:int):void
		{
			if (_usedBones.indexOf(boneIndex) < 0) {
				trace("插入：" + boneIndex);
				_usedBones.push(boneIndex);
			}
		}
		
		public function getBoneIIndex(boneIndex:int):int
		{
			return _usedBones.indexOf(boneIndex);
		}
		
		public function get BoneCount():int
		{
			return _usedBones.length;
		}
		
		private function generate():void
		{	
			vertexbuffer = context3D.createVertexBuffer(_rawVertex.length / 6, 6);
			indexbuffer = context3D.createIndexBuffer(_rawIndices.length);						
			indexbuffer.uploadFromVector(_rawIndices, 0, _rawIndices.length);
			vertexbuffer.uploadFromVector(_rawVertex, 0, _rawVertex.length / 6);
			
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler(false);
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX, CommonShader.V1);
			
			var fragmentShaderAssembler:AGALMiniAssembler= new AGALMiniAssembler(false);
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT, CommonShader.F1);
			
			program = context3D.createProgram();
			program.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
		}
		
		private var r:Number = 0;
		private var _boneStart:int = 0;	//vc中的骨骼寄存器的开始索引
		public function render(frame:int):void
		{
			if (!_texture.ok) return;
			if (!_model.animation.OK) return;
			
			var m:Matrix3D = Main.ccamera.m.clone();
			m.prependTranslation(x + _model.x, y + _model.y, z + _model.z);
			m.prependScale(scale, scale, scale);
			m.prependRotation(rotationX, Vector3D.X_AXIS)
			m.prependRotation(rotationY, Vector3D.Y_AXIS);
			m.prependRotation(rotationZ, Vector3D.Z_AXIS)
			
			//context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 120, Vector.<Number>([0.5, 1, 2, 0]));
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 121, m, true);
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0.98046, 0.84375, 0.375, 1]));	//金色
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([0.299, 0.587, 0.114, 14]));		//求灰度需要的常量 0.299*R+0.587*G+0.114*B   ,    256
			
			//设置该帧的骨骼参数
			var animateData:Array = _model.animation.getBoneAnimation(frame);
			for (var i:int = 0; i < _usedBones.length; i++) {
				context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, _boneStart + i * 4, animateData[_usedBones[i]], true);
				//trace("animate=" + _usedBones[i]);
			};
			
			context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setTextureAt(0, _texture.texture);
			context3D.setProgram(program);
			context3D.drawTriangles(indexbuffer);
			
			context3D.setVertexBufferAt(0,null);
			context3D.setVertexBufferAt(1, null);
			context3D.setTextureAt(0, null);
		}
	}
}
