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
			
			var m00:Number = 1.0 - 2.0 * quat[1] * quat[1] - 2.0 * quat[2] * quat[2];
			var m01:Number = 2.0 * quat[0] * quat[1] - 2.0 * quat[3] * quat[2];
			var m02:Number = 2.0 * quat[0] * quat[2] + 2.0 * quat[3] * quat[1];
			var m03:Number = 0;
			
			var m10:Number = 2.0 * quat[0] * quat[1] + 2.0 * quat[3] * quat[2];
			var m11:Number = 1.0 - 2.0 * quat[0] * quat[0] - 2.0 * quat[2] * quat[2];
			var m12:Number = 2.0 * quat[1] * quat[2] - 2.0 * quat[3] * quat[0];
			var m13:Number = 0;
			
			var m20:Number = 2.0 * quat[0] * quat[2] - 2.0 * quat[3] * quat[1];
			var m21:Number = 2.0 * quat[1] * quat[2] + 2.0 * quat[3] * quat[0];
			var m22:Number = 1.0 - 2.0 * quat[0] * quat[0] - 2.0 * quat[1] * quat[1];
			var m23:Number = 0;
			
			var result:Vector3D = new Vector3D();
			result.x = source.x * m00 + source.y * m01 + source.z * m02 + m03;
			result.y = source.x * m10 + source.y * m11 + source.z * m12 + m13;
			result.z = source.x * m20 + source.y * m21 + source.z * m22 + m23;
			
			var pos:Vector3D = new Vector3D(vec[0], vec[1], vec[2]);
			pos.x += result.x;
			pos.y += result.y;
			pos.z += result.z;
			return pos;
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