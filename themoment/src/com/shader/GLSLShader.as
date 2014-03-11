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

		[Embed(source="glsl/texture.vs",mimeType = "application/octet-stream")] 
		private static const TEXTUREVS:Class;
		
		[Embed(source="glsl/texture.fs",mimeType = "application/octet-stream")] 
		private static const TEXTUREFS:Class;
		
		[Embed(source="glsl/boneanimate.fs",mimeType = "application/octet-stream")] 
		private static const BONEFS:Class;
		
		[Embed(source="glsl/boneanimate.vs",mimeType = "application/octet-stream")] 
		private static const BONEVS:Class;
		
		public static function get shader1():Array
		{
			return getShader(SIMPLEVS,SIMPLEFS);
		}
		public static function get shader2():Array
		{
			return getShader(TEXTUREVS,TEXTUREFS);
		}
		
		public static function get shader3():Array
		{
			return getShader(BONEVS,BONEFS);
		}
		
		private static function getShader(VSCLS:Class,FSCLS:Class):Array
		{
			var bts0:ByteArray = new VSCLS;
			var bts1:ByteArray = new FSCLS;
			var btsstr0:String = bts0.readMultiByte(bts0.length, "utf-8");
			var btsstr1:String = bts1.readMultiByte(bts1.length, "utf-8");
			var str0:Object = JSON.parse(getVertexShader(btsstr0));
			var str1:Object = JSON.parse(getFragmentShader(btsstr1));
			trace("vshader:\n"+JSON.stringify(str0,null,1));
			trace("fshader:\n" +JSON.stringify(str1,null,1));
			return [str0.agalasm,str1.agalasm];
		}
		
		public static function getVertexShader(src:String):String
		{
			return compileShader(src, 0, false,true);
		}
		
		public static function getFragmentShader(src:String):String
		{
			return compileShader(src, 1, true,true);
		}
		
	}

}