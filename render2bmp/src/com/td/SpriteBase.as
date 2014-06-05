package com.td 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author callee
	 */
	public class SpriteBase extends EventDispatcher 
	{
		public var x:Number;
		public var y:Number;
		
		private var _children:Array;
		
		public function SpriteBase() 
		{
			_children = [];
		}
		
		public function addChild(child:SpriteBase):void
		{
			_children.push(child);
		}
		
		protected function _render():void
		{
			
		}
		
		private function render():void
		{
			_render();
			for each(var child:SpriteBase in _children) {
				child.render();
			}
		}
	}

}