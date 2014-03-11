package com.shader 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author callee
	 */
	public class ShaderUtil 
	{
		[Embed(source="shader1",mimeType = "application/octet-stream")] 
		private static const SHADERBTS : Class;

		[Embed(source="shader2",mimeType = "application/octet-stream")] 
		private static const SHADERBTS2 : Class;
		
		[Embed(source="shader3",mimeType = "application/octet-stream")] 
		private static const SHADERBTS3 : Class;
		
		public static function parse(bts:ByteArray):Array
		{
			var arr:Array = [new ByteArray, new ByteArray];
			arr[0].endian = flash.utils.Endian.LITTLE_ENDIAN;
			arr[1].endian = flash.utils.Endian.LITTLE_ENDIAN;
			bts.endian = flash.utils.Endian.LITTLE_ENDIAN;
			
			var len:uint = bts.readUnsignedInt();
			bts.readBytes(arr[0],0,len);
			len = bts.readUnsignedInt();
			bts.readBytes(arr[1],0,len);
			return arr;
		}
		
		public static function get shader1():Array
		{
			return parse(new SHADERBTS);
		}
		
		public static function get shader2():Array
		{
			return parse(new SHADERBTS2);
		}
		
		public static function get shader3():Array
		{
			return parse(new SHADERBTS3);
		}
	}
}