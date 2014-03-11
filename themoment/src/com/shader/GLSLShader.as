package com.shader
{
	import com.adobe.glsl2agal.CModule;
	import com.adobe.glsl2agal.compileShader;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author callee
	 */
	public class GLSLShader
	{
		[Embed(source="glsl/simple.fs",mimeType = "application/octet-stream")] 
		private static const SIMPLEFS:Class;
		
		[Embed(source="glsl/simple.vs",mimeType = "application/octet-stream")] 
		private static const SIMPLEVS:Class;
		
		public static function get shader1():Array
		{
			var bts0:ByteArray = new SIMPLEVS;
			var bts1:ByteArray = new SIMPLEFS;
			var str0:String = getVertexShader(bts0.readMultiByte(bts0.length, "cn-gb"));
			var str1:String = getFragmentShader(bts1.readMultiByte(bts1.length, "cn-gb"));
			return [str0,str1];
		}
		
		public static function getVertexShader(src:String):String
		{
			return compileShader(src, 0, false);
		}
		
		public static function getFragmentShader(src:String):String
		{
			return compileShader(src, 1, false);
		}
		
	}

}