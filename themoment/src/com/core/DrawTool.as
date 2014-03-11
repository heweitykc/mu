package com.core 
{
	import adobe.utils.CustomActions;
	import flash.display.BitmapData;
	import flash.display.Shape;
	/**
	 * ...
	 * @author callee
	 */
	public class DrawTool 
	{
		
		public function DrawTool() 
		{
			
		}
		
		public static function draw(screen:Shape, indices:Vector.<uint>, vectices:Vector.<Number>, bmpdata:BitmapData):void
		{
			var indexes:Vector.<int> = Vector.<int>(indices);
			var vectexes:Vector.<Number> = new Vector.<Number>();
			var uves:Vector.<Number> = new Vector.<Number>();
			for (var i:int = 0; i < vectices.length; i+=6 ) {
				vectexes.push(vectices[i], vectices[i + 1], vectices[i + 2]);
				uves.push(vectices[i+3],vectices[i+4]);
			}
			
			screen.graphics.clear();
			screen.graphics.beginBitmapFill(bmpdata);			
			screen.graphics.drawTriangles(vectexes, indexes, uves);
		}
		
	}

}