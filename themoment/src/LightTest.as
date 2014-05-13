package  
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	
	import com.bit101.components.*;
		
	/**
	 * ...
	 * @author callee
	 */
	public class LightTest extends Sprite 
	{
		private var _slider1:VSlider;
		private var _loader:Loader;
		private var _bitmapData:BitmapData;
		
		public function LightTest() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onadd);
		}
		
		public function onadd(evt:Event):void
		{	
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			_loader = new Loader();
			addChild(_loader);
			_loader.load(new URLRequest("assets/Monster210/gorizungal.jpg"));
			
			_slider1 = new VSlider(this, 15, 200);
			_slider1.addEventListener(Event.CHANGE, onChange);
			_slider1.maximum = 100;
			_slider1.minimum = 1;
		}
		
		private function onChange(evt:Event):void
		{
			this.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(evt:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onFrame);
			if (!_bitmapData) _bitmapData = _loader.content["bitmapData"];
			trace(_bitmapData);
			for (var i:int = 0; i<_bitmapData.width; i++) {
				for (var j:int = 0; j<_bitmapData.height; j++) {
					var pixelValue:int = _bitmapData.getPixel32(i, j);
					var alphaValue:uint = pixelValue >> 24 & 0xFF;
					var red:uint = pixelValue >> 16 & 0xFF;
					var green:uint = pixelValue >> 8 & 0xFF;
					var blue:uint = pixelValue & 0xFF;
					var newColor:uint = 0x0;
					newColor += (alphaValue*_slider1.value) << 24;
					newColor += (red*_slider1.value) << 16;
					newColor += (green*_slider1.value) << 8;
					newColor += (blue*_slider1.value);
					_bitmapData.setPixel32(i, j, newColor);
				}
			}
		}
	}

}