package  
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Vector3D;
	import flash.text.*;
	
	/**
	 * ...
	 * @author callee
	 */
	public class PSysDemo extends Sprite 
	{
		private var _ps:ParticleSystem;
		private var _dt:Number = 0.02;
		private var _txt:TextField;
		
		public function PSysDemo() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.stage.addEventListener(MouseEvent.CLICK, onMClick);
		}
		
		private function onMClick(evt:MouseEvent):void
		{
			_ps = new ParticleSystem();
			_txt = new TextField();
			addChild(_txt);
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.x = 100;
			_txt.y = 50;
			this.addEventListener(Event.ENTER_FRAME, step);
		}
		
		private function step(evt:Event):void
		{
			var direct:Vector3D = sampleDirection().clone();
			direct.scaleBy(100);
			_ps.emit(new Paricle(new Vector3D(stage.mouseX, stage.mouseY, 0), direct, 1, 0xFF0000, 5));
			_ps.simulate(_dt);
			
			this.graphics.clear();
			_ps.render(graphics);
			
			_txt.text = "粒子数量：" + _ps.num() + "";
		}
		
		private function sampleDirection():Vector3D
		{
			var theta:Number = Math.random() * 2 * Math.PI;
			return new Vector3D(Math.cos(theta), Math.sin(theta));
		}
	}

}