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
		public var slider1:RangeSlider;
		public function MainUI(content:Sprite) 
		{
			_content = content;
			slider1 = new RangeSlider(RangeSlider.VERTICAL,_content,50,150);
		}
	}

}