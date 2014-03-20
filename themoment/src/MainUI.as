package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	
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
		public function MainUI(content:Sprite) 
		{
			_content = content;
			slider1 = new VSlider(_content, 50, 150);
			slider1.height = 200;
			slider1.maximum = 1;
			slider1.minimum = 0;
		}
	}

}