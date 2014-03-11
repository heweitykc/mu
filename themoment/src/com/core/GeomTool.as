package com.core 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author callee
	 */
	public class GeomTool 
	{
		/*
		public static function QuatFromEulers(vec:Array):Array {
			var dSY:Number = Math.sin(vec[2] * 0.5);
			var dSP:Number = Math.sin(vec[1] * 0.5);
			var dSR:Number = Math.sin(vec[0] * 0.5);
			var dCY:Number = Math.cos(vec[2] * 0.5);
			var dCP:Number = Math.cos(vec[1] * 0.5);
			var dCR:Number = Math.cos(vec[0] * 0.5);
			
			var quat:Array = [];
			quat[0] = dSR * dCP * dCY - dCR * dSP * dSY;
			quat[1] = dCR * dSP * dCY + dSR * dCP * dSY;
			quat[2] = dCR * dCP * dSY - dSR * dSP * dCY;
			quat[3] = dCR * dCP * dCY + dSR * dSP * dSY;
			
			return quat;
		}
		
		public static function QuaternionMatrix(quat:Array):Matrix3D {
			var data:Vector.<Number> = Vector.<Number>([
				1.0 - 2.0 * quat[1] * quat[1] - 2.0 * quat[2] * quat[2],
				2.0 * quat[0] * quat[1] + 2.0 * quat[3] * quat[2],
				2.0 * quat[0] * quat[2] - 2.0 * quat[3] * quat[1],
				0,

				2.0 * quat[0] * quat[1] - 2.0 * quat[3] * quat[2],
				1.0 - 2.0 * quat[0] * quat[0] - 2.0 * quat[2] * quat[2],
				2.0 * quat[1] * quat[2] + 2.0 * quat[3] * quat[0],
				0,

				2.0 * quat[0] * quat[2] + 2.0 * quat[3] * quat[1],
				2.0 * quat[1] * quat[2] - 2.0 * quat[3] * quat[0],
				1.0 - 2.0 * quat[0] * quat[0] - 2.0 * quat[1] * quat[1],
				0,
				
				0,
				0,
				0,
				1
			]);
			
			return new Matrix3D(data);
		}
		*/
		
		public static function Euler2Matrix(vec:Vector.<Number>):Matrix3D
		{
			var dSY:Number = Math.sin(vec[5] * 0.5);
			var dSP:Number = Math.sin(vec[4] * 0.5);
			var dSR:Number = Math.sin(vec[3] * 0.5);
			var dCY:Number = Math.cos(vec[5] * 0.5);
			var dCP:Number = Math.cos(vec[4] * 0.5);
			var dCR:Number = Math.cos(vec[3] * 0.5);
			
			var quat:Array = [];
			quat[0] = dSR * dCP * dCY - dCR * dSP * dSY;
			quat[1] = dCR * dSP * dCY + dSR * dCP * dSY;
			quat[2] = dCR * dCP * dSY - dSR * dSP * dCY;
			quat[3] = dCR * dCP * dCY + dSR * dSP * dSY;
			
			var data:Vector.<Number> = Vector.<Number>([
				1.0 - 2.0 * quat[1] * quat[1] - 2.0 * quat[2] * quat[2],
				2.0 * quat[0] * quat[1] + 2.0 * quat[3] * quat[2],
				2.0 * quat[0] * quat[2] - 2.0 * quat[3] * quat[1],
				0,

				2.0 * quat[0] * quat[1] - 2.0 * quat[3] * quat[2],
				1.0 - 2.0 * quat[0] * quat[0] - 2.0 * quat[2] * quat[2],
				2.0 * quat[1] * quat[2] + 2.0 * quat[3] * quat[0],
				0,

				2.0 * quat[0] * quat[2] + 2.0 * quat[3] * quat[1],
				2.0 * quat[1] * quat[2] - 2.0 * quat[3] * quat[0],
				1.0 - 2.0 * quat[0] * quat[0] - 2.0 * quat[1] * quat[1],
				0,
				
				vec[0],
				vec[1],
				vec[2],
				1
			]);
			
			return new Matrix3D(data);
		}
		
		public static function translateVector(vec:Vector.<Number>, source:Vector3D):Vector3D
		{
			var data:Vector.<Number> = Euler2Matrix(vec).rawData;
			var pos:Vector3D = new Vector3D(data[3*4+0],data[3*4+0],data[3*4+0]);
			var result:Vector3D = new Vector3D();
			result.x = Dot(source, [data[0*4+0],data[0*4+1], data[0*4+2]]) + data[0*4+3];
			result.y = Dot(source, [data[1*4+0],data[1*4+1], data[1*4+2]]) + data[1*4+3];
			result.z = Dot(source, [data[2*4+0],data[2*4+1], data[2*4+2]]) + data[2*4+3];
			pos.x += result.x;
			pos.y += result.y;
			pos.z += result.z;
			return pos;
		}
		
		public static function Dot(pos:Vector3D, y:Array):Number
		{
			return pos.x*y[0] + pos.y*y[1] + pos.z*y[2];
		}
		
		// A:MxN  B:NxP 
		// ABij = A(i0)B(0j) + A(i1)B(1j) + ... + A(in)B(nj)
		public static function m44(pos:Vector3D, m:Matrix3D):Vector3D
		{
			var data:Vector.<Number> = m.rawData;
			var result:Vector3D = new Vector3D();
			//AB00 = A(00)B(00) + A(01)B(10) + A(02)B(20) + A(03)B(30)
			result.x = (pos.x * data[0*4+0]) + (pos.y * data[0*4+1]) + (pos.z * data[0*4+2]) + (pos.w * data[0*4+3])
			//AB01 = A(00)B(01) + A(01)B(11) + A(02)B(21) + A(03)B(31)
			result.y = (pos.x * data[1*4+0]) + (pos.y * data[1*4+1]) + (pos.z * data[1*4+2]) + (pos.w * data[1*4+3])
			//AB02 = A(00)B(02) + A(01)B(12) + A(02)B(22) + A(03)B(32)
			result.z = (pos.x * data[2*4+0]) + (pos.y * data[2*4+1]) + (pos.z * data[2*4+2]) + (pos.w * data[2*4+3])
			//AB03 = A(00)B(03) + A(01)B(13) + A(02)B(23) + A(03)B(33)
			result.w = (pos.x * data[3*4+0]) + (pos.y * data[3*4+1]) + (pos.z * data[3*4+2]) + (pos.w * data[3*4+3])
			return result;
		}
		
		public static function formatShader(arr:Array):String
		{
			var str:String = "";
			for (var i:int = 0; i < arr.length; i++) {
				if (!arr[i]) continue;
				str += ("\"" + arr[i] + "\\n\" + " + "\n");
			}
			return str;
		}
	}

}