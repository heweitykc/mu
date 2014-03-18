package com.core
{
	import com.adobe.utils.*;
	import com.mu.*;
	import flash.display3D.*;
	import flash.geom.*;
	import com.shader.*;

	public class SubMeshTest extends Object3D
	{
		protected var context3D:Context3D;
		protected var program:Program3D;
		protected var vertexbuffer:VertexBuffer3D;
		protected var indexbuffer:IndexBuffer3D;
		
		protected var _rawVertex:Vector.<Number>;
		protected var _rawIndices:Vector.<uint>;
		
		private var _vectexes:Vector.<Number> = 
		Vector.<Number>(
		[
			5,   5, 5,  1, 0, 1,
			5,  5, -5,  0, 1, 1,
			-5, 5, -5,  1, 1, 1,

			-5, 5, 5,  1, 0, 1,
			5,  -5, 5,  0, 1, 1,
			-5, -5, 5,  1, 1, 1,

			-5, -5, -5,  1, 0, 1,
			5,  -5, -5,  0, 1, 1
		]
		
		);
		private var _indexes:Vector.<uint> = Vector.<uint>([
			0,1,2,	0,2,3,
			0,7,1,	0,4,7,
			1,7,6,	1,6,2,
			2,6,5,	2,3,5,
			0,5,4,	0,3,5,
			5,6,7,	4,5,7
		]);
		
		public function SubMeshTest(context3d:Context3D)
		{
			this.context3D = context3d;
			
			upload(_vectexes, _indexes);
			scale = 0.1;
		}
		
		public function upload(rawVertex:Vector.<Number>, rawIndices:Vector.<uint>):void
		{
			_rawVertex = rawVertex;
			_rawIndices = rawIndices;
			generate();
		}
		
		private function generate():void
		{	
			vertexbuffer = context3D.createVertexBuffer(_rawVertex.length / 6, 6);
			indexbuffer = context3D.createIndexBuffer(_rawIndices.length);						
			indexbuffer.uploadFromVector(_rawIndices, 0, _rawIndices.length);
			vertexbuffer.uploadFromVector(_rawVertex, 0, _rawVertex.length / 6);
			
			var arr:Array = [];
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
			rotationY += 15;
			rotationZ += 15;
			var m:Matrix3D = Main.ccamera.m.clone();
			m.prependRotation(rotationX, Vector3D.X_AXIS)
			m.prependRotation(rotationY, Vector3D.Y_AXIS);
			m.prependRotation(rotationZ, Vector3D.Z_AXIS)
			m.prependTranslation(x, y, z);
			m.prependScale(scale, scale, scale);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, Vector.<Number>([1,2,0,0]));
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 1, m, true);
			
			context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setProgram(program);
			context3D.drawTriangles(indexbuffer);
			
			//clear
			//context3D.setVertexBufferAt(0,null);
			//context3D.setVertexBufferAt(1, null);
		}
		
		private function computeNew(frame:int):Vector.<Number> {
			var newVertex:Vector.<Number> = new Vector.<Number>();
			
			var m:Matrix3D = Main.ccamera.m.clone();

			//m.transpose();
			for (var i:int = 0; i < _rawVertex.length; i += 6) {
				var v1:Vector3D = new Vector3D(_rawVertex[i + 0],_rawVertex[i + 1],_rawVertex[i + 2]);
				//var v1:Vector3D = GeomTool.m44(v, m);
				//trace(v1.x + "_" + v1.y+ "_" + v1.z);
				newVertex.push(v1.x, v1.y, v1.z, _rawVertex[i + 3], _rawVertex[i + 4], _rawVertex[i + 5]);
			}
			return newVertex;
		}
	}
}
