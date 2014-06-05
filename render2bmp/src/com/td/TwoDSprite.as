package com.td 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author callee
	 */
	public class TwoDSprite extends SpriteBase 
	{
		public static const vertexData:Vector.<Number> = Vector.<Number>(
			[
			  // x, y, z    u, v
				 1,  1, 0,   1,0,0,
				-1,  1, 0,   0,0,1,
				-1, -1, 0,   0,1,1,
				 1, -1, 0,   1,1,0
			]
        );
		public static const indexData:Vector.<uint> = Vector.<uint>( [0, 1, 2, 0, 2, 3] );
		
		private var _shader:Shader;
		public function TwoDSprite(shader:Shader) 
		{
			super();
			_shader = shader;
		}
		
		override protected function _render():void
		{
			_shader.useProg();
			
		}
	}
}