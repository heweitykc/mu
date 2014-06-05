package 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author callee
	 */
	public class Main extends Sprite 
	{
		private var _position:Vector3D;		//初始位置
		private var _velocity:Vector3D;		//速度矢量
		private var _acceleration:Vector3D; //加速度
		private var _dt:Number = 0.1;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			_position = new Vector3D(10, 200, 0);
			_velocity = new Vector3D(50, -50, 0);
			_acceleration = new Vector3D(0, 10, 0); //
			
			this.stage.addEventListener(MouseEvent.CLICK, onMClick);
		}
		
		private function onMClick(evt:MouseEvent):void
		{
			this.addEventListener(Event.ENTER_FRAME, step);
		}
		
		private function step(evt:Event):void
		{
			var v:Vector3D = _velocity.clone();
			v.scaleBy(_dt);
			
			var a:Vector3D = _acceleration.clone();
			a.scaleBy(_dt);
			
			_position = _position.add(v);
			_velocity = _velocity.add(a);
			
			this.graphics.beginFill(0x000000);
			this.graphics.drawCircle(_position.x, _position.y, 4);
			this.graphics.endFill();
			
			trace(_velocity.x + "  " + _velocity.y);
		}
		
	}
	
}