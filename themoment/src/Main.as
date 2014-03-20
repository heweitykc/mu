package
{
	import com.adobe.utils.*;
	import com.camera.*;
	import com.core.*;
	import com.mu.*;
	import flash.display.*;
	import flash.display3D.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.ui.*;
	
	/**
	 * 场景渲染 
	 * @author rajhe
	 * 
	 */
	
	[SWF(width=1024, height=768, frameRate=30, backgroundColor=0xFF0000)]
	public class Main extends Sprite
	{
		public static var ccamera:CommonCamera;
		
		private var _stats:Stats;
		private var _camera:CommonCamera;
		private var _model2:MuModelGPU;
		private var _meshTest:SubMeshTest;
		private var _tf1:TextField = new TextField();
		protected var context3D:Context3D;
		private var _models:Array;
		
		private var _ui:MainUI;
		
		public function Main()
		{
			super();
	
			addEventListener(Event.ADDED_TO_STAGE, onadd);
		}
		
		public function onadd(evt:Event):void
		{			
			initUI();
			
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, initStage3D);
			stage.stage3Ds[0].requestContext3D();
			
			addEventListener(Event.ENTER_FRAME, onRender);
			_camera = new CommonCamera(stage);
			ccamera = _camera;
		}
		
		private function initUI():void
		{
			_ui = new MainUI(this);
			MainUI.instance = _ui;
		}
		
		protected function initStage3D(e:Event):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_stats = new Stats();
			addChild(_stats);
			
			_tf1.textColor = 0xFFFF00;
			addChild(_tf1);
			_tf1.x = 200;
			
			stage.stage3Ds[0].removeEventListener( Event.CONTEXT3D_CREATE, initStage3D);
			
			context3D = stage.stage3Ds[0].context3D;			
			context3D.configureBackBuffer(1024, 768, 0);
			
			_model2 = new MuModelGPU(context3D);
			_model2.load();
			
			//_meshTest = new SubMeshTest(context3D);
			
			initModels();
			
			_camera.init();
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownEventHandler ); 
		}
		
		private function initModels():void
		{
			_models = [];
			for (var i:int = 0; i < 3; i++) {
				var mumodel:MuModelGPU = new MuModelGPU(context3D);
				mumodel.x = int(i%15)*5;
				mumodel.y = int(i / 15) * 5;
				_models.push(mumodel);
				mumodel.load("Monster32");
			}
		}
		
		protected function keyDownEventHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.X)
				_frame++;
		}
		
		private var _increment:Number = 0.2;
		private var _frame:int=0
		protected function onRender(e:Event):void
		{
			_frame++;
			_camera.loop();
			
			context3D.clear(0, 0, 1, 1);
			
			//_meshTest.render(_frame);
			_model2.render(_frame);
			for each(var mumodel:MuModelGPU in _models) {
				mumodel.render(_frame);
			}
			_stats.update(2, 0);
			
			context3D.present();			
		}
	}
}