package com.core
{
	import com.adobe.utils.*;
	import com.mu.*;
	import flash.display3D.*;
	import flash.geom.*;
	import com.shader.*;

	public class SubMeshGPU extends Object3D
	{
		public static const VERTEX_LEN:int = 9;
		
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
			z = 0;
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
			vertexbuffer = context3D.createVertexBuffer(_rawVertex.length / VERTEX_LEN, VERTEX_LEN);
			vertexbuffer.uploadFromVector(_rawVertex, 0, _rawVertex.length / VERTEX_LEN);
			indexbuffer = context3D.createIndexBuffer(_rawIndices.length);						
			indexbuffer.uploadFromVector(_rawIndices, 0, _rawIndices.length);
			
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
			
			//rotationZ += 1;
			
			var m:Matrix3D = Main.ccamera.m.clone();
			m.prependTranslation(x + _model.x, y + _model.y, z + _model.z);
			m.prependScale(scale, scale, scale);
			m.prependRotation(rotationX, Vector3D.X_AXIS)
			m.prependRotation(rotationY, Vector3D.Y_AXIS);
			m.prependRotation(rotationZ, Vector3D.Z_AXIS)
			
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 121, m, true);
			
			var ui:MainUI = MainUI.instance;
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, 
				Vector.<Number>([0.9414, 0.6835, 0.004, 1]));	//金色
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, 
				Vector.<Number>([0.299, 0.587, 0.114, ui.slider1.value]));	//求灰度需要的常量 0.299*R+0.587*G+0.114*B   ,    灰度系数
			
			var eye:Vector3D = Main.ccamera.eyePos;
			var lvec:Vector3D = new Vector3D(ui.sliderx.value, ui.slidery.value, ui.sliderz.value);
			var tn:Matrix3D = new Matrix3D();
			tn.prependTranslation(x + _model.x, y + _model.y, z + _model.z);
			tn.prependScale(scale, scale, scale);
			tn.prependRotation(rotationX, Vector3D.X_AXIS);
			tn.prependRotation(rotationY, Vector3D.Y_AXIS);
			tn.prependRotation(rotationZ, Vector3D.Z_AXIS);
			
			var h:Vector3D = GeomTool.computeLH(tn.transformVector(eye), tn.transformVector(lvec));
			h.normalize();
			trace("h="+h.x+","+h.y+","+h.z);
			
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, 
				Vector.<Number>([h.x, h.y, h.z, 0]));												// h
				
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, 
				Vector.<Number>([MainUI.instance.slider2.value, 0, 0, 0])); //材料的光泽度
				
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, 
				Vector.<Number>([1, 1, 1, 1])); //镜面的反射颜色
				
			//设置该帧的骨骼参数
			var animateData:Array = _model.animation.getBoneAnimation(frame);
			for (var i:int = 0; i < _usedBones.length; i++) {
				context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, _boneStart + i * 4, animateData[_usedBones[i]], true);
				//trace("animate=" + _usedBones[i]);
			};

			context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(2, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setTextureAt(0, _texture.texture);
			context3D.setProgram(program);
			context3D.drawTriangles(indexbuffer);
			
			context3D.setVertexBufferAt(0,null);
			context3D.setVertexBufferAt(1, null);
			context3D.setVertexBufferAt(2, null);
			context3D.setTextureAt(0, null);
		}
	}
}
