package
{
    import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.textures.Texture;
    
    import flash.display.Bitmap;
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
    
    public class Main extends Sprite
    {
		[Embed(source="7.png")]
		public static var BallImage1:Class;
		
        public const viewWidth:Number = 1024;
        public const viewHeight:Number = 512;
        
        private var bitmap:Bitmap;
        private var stage3D:Stage3D;
        private var renderContext:Context3D;
        private var indexList:IndexBuffer3D;
        private var vertexes:VertexBuffer3D;
		private var texture0:Texture;
        private var renderedBitmapData:BitmapData;
		
        private const VERTEX_SHADER:String =
			"mul vt0.xyzw, va0.xyzw, vc0.xyzx \n" + 
            "mov op, vt0  \n" +    					//copy position to output 
			//"sge v1.xyzw, va0.x, vc0.x   \n" +    //如果x>mousex，则v1=1
			//"sub v1.xyzw, vc0.xxxx, va0.xxxx \n" + 
            //"mul v0.xyzw, va1.xywx, vc0.xyzx \n" ;  //copy uv to varying variable v0
			"mov v0, va1"
			
        private const FRAGMENT_SHADER:String = 			
			"tex ft0, v0.xy, fs0 <2d>   \n" +
          //  "add ft0.xyzw, ft0.xyzw, v1.xyzw  \n" +
			"mov oc, ft0";

        private var vertexAssembly:AGALMiniAssembler = new AGALMiniAssembler();
        private var fragmentAssembly:AGALMiniAssembler = new AGALMiniAssembler();
        private var programPair:Program3D;
        
        public function Main()
        {
            stage3D = this.stage.stage3Ds[0];

            //Add event listener before requesting the context
            stage3D.addEventListener( Event.CONTEXT3D_CREATE, contextCreated );            
            stage3D.requestContext3D( Context3DRenderMode.AUTO );
            
            //Compile shaders
            vertexAssembly.assemble( Context3DProgramType.VERTEX, VERTEX_SHADER, 1,false );
            fragmentAssembly.assemble( Context3DProgramType.FRAGMENT, FRAGMENT_SHADER,1, false );            
        }
        
        //Note, context3DCreate event can happen at any time, such as when the hardware resources are taken by another process
        private function contextCreated( event:Event ):void
        {
            renderContext = Stage3D( event.target ).context3D;
            trace( "3D driver: " + renderContext.driverInfo );

            renderContext.enableErrorChecking = true; //Can slow rendering - only turn on when developing/testing
            renderContext.configureBackBuffer( viewWidth, viewHeight, 0, false );
            
            //Create vertex index list for the triangles
            var triangles:Vector.<uint> = Vector.<uint>( [ 0, 1, 2, 0, 2, 3] );
            indexList = renderContext.createIndexBuffer( triangles.length );
            indexList.uploadFromVector( triangles, 0, triangles.length );
            
            //Create vertexes
            const dataPerVertex:int = 6;
            var vertexData:Vector.<Number> = Vector.<Number>(
                [
                  // x, y, z    u, v
                     1, 1, 0,   1,0,0,
                    -1, 1, 0,   0,0,1,
                    -1, -1, 0,  0,1,1,
                    1,-1, 0,    1,1,0
                ]
            );
            vertexes = renderContext.createVertexBuffer( vertexData.length/dataPerVertex, dataPerVertex );
            vertexes.uploadFromVector( vertexData, 0, vertexData.length/dataPerVertex );
            
            //Identify vertex data inputs for vertex program
            renderContext.setVertexBufferAt( 0, vertexes, 0, Context3DVertexBufferFormat.FLOAT_3 ); //va0 is position
            renderContext.setVertexBufferAt( 1, vertexes, 3, Context3DVertexBufferFormat.FLOAT_3 ); //va1 is uv
            
			texture0 = renderContext.createTexture(1024, 512, Context3DTextureFormat.BGRA,false);
			texture0.uploadFromBitmapData((new BallImage1).bitmapData);
			
            //Upload programs to render context
            programPair = renderContext.createProgram();
            programPair.upload( vertexAssembly.agalcode, fragmentAssembly.agalcode );
            renderContext.setProgram( programPair );
			
			renderContext.setTextureAt(0, texture0);
            
            renderedBitmapData = new BitmapData( viewWidth, viewHeight, true );
            
            //Add to stage
            bitmap = new Bitmap( renderedBitmapData );
            //this.addChild( bitmap );
            bitmap.x = 0;
            bitmap.y = 0;
            bitmap.filters = [new DropShadowFilter( 8, 235, .4 )];
			
			this.addEventListener(Event.ENTER_FRAME, onLoop);
        }
		
		 private function onLoop(event:Event ):void
		 {
			//Clear required before first drawTriangles() call
			renderContext.clear( .0, .0, .0 );
			var f:Number = stage.mouseX / viewWidth;
			renderContext.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, Vector.<Number>([f,1,1,1])); //fc0
			//Draw the 2 triangles
			renderContext.drawTriangles( indexList);
			//renderContext.drawToBitmapData( renderedBitmapData );
			
			renderContext.present();
		 }
    }
}