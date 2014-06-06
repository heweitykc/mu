package com.td 
{
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.display3D.*;
	
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
		
		private var _indexList:IndexBuffer3D;
        private var _vertexes:VertexBuffer3D;
		
		private var _shader:Shaders;
		private var _texture:TextureBase;
		
		public function TwoDSprite(shader:Shaders, texture:Texture) 
		{
			super();
			_shader = shader;
			_texture = texture;
		}
		
		override public function resize():void
		{
			super.resize();
			
			//vc0 : [xRatio, yRatio, 0, 0]
			_shader.context.setProgramConstantsFromVector(
				Context3DProgramType.VERTEX, 0, 
				Vector.<Number>([Application.xRatio*width, Application.yRatio*height, 0, 0])
			);
		}
		
		override protected function _render():void
		{
			if (!_indexList) {
				_indexList = _shader.context.createIndexBuffer( indexData.length );
				_indexList.uploadFromVector(indexData, 0, indexData.length );
				_vertexes = _shader.context.createVertexBuffer(4, 6);
				_vertexes.uploadFromVector(vertexData, 0, 4);
			}
			_shader.useProg();
			
			_shader.context.setProgramConstantsFromVector(
				Context3DProgramType.VERTEX, 1, 
				Vector.<Number>([x*Application.xRatio, y*Application.yRatio, 0, 0])
			);
			trace("x=" + x*Application.xRatio + ", y=" + y*Application.yRatio);
			
			_shader.context.setVertexBufferAt(0, _vertexes, 0, Context3DVertexBufferFormat.FLOAT_3 ); //va0 is position
            _shader.context.setVertexBufferAt(1, _vertexes, 3, Context3DVertexBufferFormat.FLOAT_3 ); //va1 is uv
			_shader.context.clear(0, 0, 0, 1);
			_shader.context.setTextureAt(0, _texture);
			_shader.context.drawTriangles(_indexList, 0, 2);
			_shader.context.present();
		}
	}
}