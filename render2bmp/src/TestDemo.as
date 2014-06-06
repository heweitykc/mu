package  
{
	import com.td.*;	
	import flash.display.*;
	import flash.display3D.*;
	import flash.display3D.textures.*;
	import flash.events.*;
	
	/**
	 * ...
	 * @author callee
	 */
	public class TestDemo extends Sprite 
	{
		[Embed(source="7.png")]
		public static var BallImage1:Class;
		
		private var _ch:TwoDSprite;			
		private var _stage3D:Stage3D;
		
		private var _texture0:Texture;
		private var _bg:Bitmap;
		private var _shader0:Shaders;
		private var _context:Context3D;
		
		public function TestDemo() 
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.LOW;
			stage.addEventListener(Event.RESIZE, onResize);
			
            _stage3D = this.stage.stage3Ds[0];
			_stage3D.addEventListener(Event.CONTEXT3D_CREATE, contextCreated );            
            _stage3D.requestContext3D(Context3DRenderMode.AUTO );
		}
		
		private function contextCreated(evt:Event):void
        {
			_context = Stage3D(evt.target).context3D;
			trace("3D driver: " + _context.driverInfo);
            _context.enableErrorChecking = true;
            _context.configureBackBuffer( stage.stageWidth, stage.stageHeight, 0, false );
			
			init();
			
			onResize(null);
		}
		
		private function init():void
		{
			_bg = new BallImage1;
						
			_texture0 = _stage3D.context3D.createTexture(_bg.width, _bg.height, Context3DTextureFormat.BGRA, false);
			_texture0.uploadFromBitmapData(_bg.bitmapData);
			
			_shader0 = new Shaders(ShaderCode.VERTEX_SHADER, ShaderCode.FRAGMENT_SHADER, _context);
			
			_ch = new TwoDSprite(_shader0, _texture0);
			_ch.width = _bg.width;
			_ch.height = _bg.height;
			
			this.addEventListener(Event.ENTER_FRAME, onLoop);
		}
		
		private function onLoop(evt:Event):void
		{
			Application.render();
			_ch.render();
			_ch.x+=5;
		}
		
		private function onResize( event:Event ):void
		{
			Application.xRatio = 1 / stage.stageWidth;
			Application.yRatio = 1 / stage.stageHeight;
			trace("xRatio="+Application.xRatio+", Application.yRatio=" + Application.yRatio);
			_ch.resize();
		}
	}

}