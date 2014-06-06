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
		public var width:Number;
		public var height:Number;
		
		private var _children:Array;
		
		public function SpriteBase() 
		{
			_children = [];
			x = 0;
			y = 0;
		}
		
		public function addChild(child:SpriteBase):void
		{
			_children.push(child);
		}
		
		public function resize():void
		{
			for each(var child:SpriteBase in _children) {
				child.resize();
			}
		}
		
		protected function _render():void
		{
			
		}
		
		public function render():void
		{
			_render();
			for each(var child:SpriteBase in _children) {
				child.render();
			}
		}
		
	}

}