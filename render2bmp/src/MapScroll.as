package
{
    import com.adobe.utils.AGALMiniAssembler;
	import com.adobe.utils.PerspectiveMatrix3D;
	import flash.display3D.textures.Texture;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
    
    import flash.display.*;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.display.Stage3D;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DRenderMode;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.Program3D;
    import flash.display3D.*;
    import flash.events.Event;
    import flash.filters.DropShadowFilter;
    
    public class MapScroll extends Sprite
    {
		[Embed(source="7.png")]
		public static var BallImage1:Class;
        
		private var _people:MovieClip;
        private var stage3D:Stage3D;
        private var renderContext:Context3D;
        private var indexList:IndexBuffer3D;
        private var vertexes:VertexBuffer3D;
		private var texture0:Texture;
        private var renderedBitmapData:BitmapData;
		private var orthoMatrix:PerspectiveMatrix3D;
		
        private const VERTEX_SHADER:String =
			"mov vt0, va0 \n" + 
			"add vt0.x, vt0.x, vc0.x \n" + 
            "mov op, vt0 \n" +    					//copy position to output 
			"mov v0, va1"
			
        private const FRAGMENT_SHADER:String = 			
			"tex ft0, v0.xy, fs0 <2d>   \n" +
			"mov oc, ft0";

        private var vertexAssembly:AGALMiniAssembler = new AGALMiniAssembler();
        private var fragmentAssembly:AGALMiniAssembler = new AGALMiniAssembler();
        private var programPair:Program3D;
		private var _bg:Bitmap;
		private var _xRatio:Number;
		private var _yRatio:Number;
        
		private var _vertexData:Vector.<Number>;
            
        //Create vertexes
		private const dataPerVertex:int = 6;
			
        public function MapScroll()
        {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.LOW;
			
            stage3D = this.stage.stage3Ds[0];

			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(MouseEvent.CLICK, onClick);
            //Add event listener before requesting the context
            stage3D.addEventListener( Event.CONTEXT3D_CREATE, contextCreated );            
            stage3D.requestContext3D( Context3DRenderMode.AUTO );
            
            //Compile shaders
            vertexAssembly.assemble( Context3DProgramType.VERTEX, VERTEX_SHADER, 1,false );
            fragmentAssembly.assemble( Context3DProgramType.FRAGMENT, FRAGMENT_SHADER, 1, false);			
        }
		
		private var _targetX:int = 0;
		private var _targetY:int = 0;
		private function onClick( evt:MouseEvent ):void
		{
			_targetX = this.mouseX;
		}
        
		private function onResize( event:Event ):void
		{
			_xRatio = 1 / stage.stageWidth;
			_yRatio = 1 / stage.stageHeight;
			var rectx:Number = _xRatio * _bg.width;
			var recty:Number = _yRatio * _bg.height;
            _vertexData = Vector.<Number>(
                [
                  // x, y, z    u, v
                     1*rectx,  1*recty, 0,   1,0,0,
                    -1*rectx,  1*recty, 0,   0,0,1,
                    -1*rectx, -1*recty, 0,   0,1,1,
                     1*rectx, -1*recty, 0,   1,1,0
                ]
            );
			renderContext.configureBackBuffer( stage.stageWidth, stage.stageHeight, 0, false );
			
			vertexes.uploadFromVector( _vertexData, 0, 4);
            
            //Identify vertex data inputs for vertex program
            renderContext.setVertexBufferAt( 0, vertexes, 0, Context3DVertexBufferFormat.FLOAT_3 ); //va0 is position
            renderContext.setVertexBufferAt( 1, vertexes, 3, Context3DVertexBufferFormat.FLOAT_3 ); //va1 is uv
		}
		
        //Note, context3DCreate event can happen at any time, such as when the hardware resources are taken by another process
        private function contextCreated( event:Event ):void
        {
			_people = new people;
			addChild(_people);
			_people.x = stage.stageWidth / 2;
			_people.y = 500;
			trace("contextCreated," +  stage.stageWidth + "*" +   stage.stageHeight);
			_bg = new BallImage1;
			_maprect.x = -_bg.width/2;
			
            renderContext = Stage3D( event.target ).context3D;
            trace( "3D driver: " + renderContext.driverInfo );

            renderContext.enableErrorChecking = true; //Can slow rendering - only turn on when developing/testing
            renderContext.configureBackBuffer( stage.stageWidth, stage.stageHeight, 0, false );
            
            //Create vertex index list for the triangles
            var triangles:Vector.<uint> = Vector.<uint>( [0, 1, 2, 0, 2, 3] );
            indexList = renderContext.createIndexBuffer( triangles.length );
            indexList.uploadFromVector( triangles, 0, triangles.length );
			
            vertexes = renderContext.createVertexBuffer(4, 6);
            onResize(null);
			
			texture0 = renderContext.createTexture(2048, 512, Context3DTextureFormat.BGRA, false);
			texture0.uploadFromBitmapData(_bg.bitmapData);
			
            //Upload programs to render context
            programPair = renderContext.createProgram();
            programPair.upload( vertexAssembly.agalcode, fragmentAssembly.agalcode );
            renderContext.setProgram( programPair );
            
			this.addEventListener(Event.ENTER_FRAME, onLoop);
        }
		
		private var _maprect:Rectangle = new Rectangle(0,0);
		private var _dx:int = 4;
		private function onLoop(event:Event):void
		{
			/*
			var diff:int = _targetX - _maprect.x + stage.stageWidth/2;
			if (diff > _dx) {
				if (_people.currentFrame < 41) _people.gotoAndPlay(41);
				//_people.x += _dx;
				_maprect.x += _dx;
				_people.scaleX = 1;
			} else if (diff < -_dx) {
				if (_people.currentFrame < 41) _people.gotoAndPlay(41);
				//_people.x -= _dx;
				_maprect.x -= _dx;
				_people.scaleX = -1;
			} else {
				if (_people.currentFrame > 40) _people.gotoAndPlay(1);
			}
			*/
			//Clear required before first drawTriangles() call
			renderContext.clear( .0, .0, .0 , 1, 1);
			renderContext.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, Vector.<Number>([_maprect.x*_xRatio,0,0,0]));
			//renderContext.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, orthoMatrix);
			//renderContext.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO ); //No blending
			renderContext.setTextureAt(0, texture0);
			renderContext.drawTriangles( indexList, 0, 2);
			renderContext.present();
		}
    }
}