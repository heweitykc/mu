package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.*;
	
	import com.bit101.components.*;
	/**
	 * ...
	 * @author callee
	 */
	public class MainUI 
	{
		public static var instance:MainUI;
		
		private var _content:Sprite;
		public var slider1:VSlider;
		public var slider2:VSlider;	//光泽度
		public var label1:TextField;
		
		public var sliderx:VSlider;
		public var slidery:VSlider;
		public var sliderz:VSlider;
		
		public function MainUI(content:Sprite) 
		{
			_content = content;
			slider1 = new VSlider(_content, 15, 150);
			slider1.height = 300;
			slider1.maximum = 1;
			slider1.minimum = -1;
			slider1.value = 1;
			
			label1 = new TextField();
			label1.x = 100;
			label1.y = 0;
			label1.autoSize = TextFieldAutoSize.LEFT;
			_content.addChild(label1);
			label1.textColor = 0x000000;
			label1.background = true;
			
			slider2 = new VSlider(_content, 30, 150);
			slider2.height = 300;
			slider2.maximum = 1;
			slider2.minimum = 0;
			
			sliderx = new VSlider(_content, 45, 150);
			sliderx.height = 300;
			sliderx.maximum = 10;
			sliderx.minimum = -10;
			
			slidery = new VSlider(_content, 60, 150);
			slidery.height = 300;
			slidery.maximum = 10;
			slidery.minimum = -10;
			slidery.value = 5;
			
			sliderz = new VSlider(_content, 75, 150);
			sliderz.height = 300;
			sliderz.maximum = 5;
			sliderz.minimum = -5;
			sliderz.value = -5;
		}
	}

}
