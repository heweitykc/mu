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
		public var label1:TextField;
		public function MainUI(content:Sprite) 
		{
			_content = content;
			slider1 = new VSlider(_content, 15, 150);
			slider1.height = 300;
			slider1.maximum = 1;
			slider1.minimum = -1;
			
			label1 = new TextField();
			label1.x = 0;
			label1.y = 130;
			label1.autoSize = TextFieldAutoSize.LEFT;
			_content.addChild(label1);
			label1.textColor = 0xffffff;
		}
	}

}
