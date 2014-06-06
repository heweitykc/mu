package com.td 
{
	import flash.utils.*;
	
	/**
	 * ...
	 * @author callee
	 */
	public class Application 
	{
		public static var delta:Number;
		private static var _time:int;
		public static function render():void
		{
			var now:int = getTimer();
			delta = (now - _time) / 1000;
			_time = now;
		}
		
		
		public static var xRatio:Number;
		public static var yRatio:Number;
	}

}