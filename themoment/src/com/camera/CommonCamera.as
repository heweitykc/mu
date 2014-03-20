package com.camera
{
	import com.adobe.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.*;
	

	public class CommonCamera
	{
		protected var projectionTransform:PerspectiveMatrix3D;
		
		protected const MAX_FORWARD_VELOCITY:Number = 0.05;
		protected const MAX_ROTATION_VELOCITY:Number = 0.5;
		protected const LINEAR_ACCELERATION:Number = 0.0005;
		protected const ROTATION_ACCELERATION:Number = 0.01;
		protected const DAMPING:Number = 1.09;
		
		protected var _controller:CameraController;
		
		private var _stage:Stage;
		private var _p0:Point = new Point();
		private var _keyDown:Object;
		
		public function CommonCamera(stage:Stage)
		{
			_stage = stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownEventHandler );   
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpEventHandler );
			stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			_keyDown = {};
		}
		
		protected function mouseDownHandler(e:MouseEvent):void
		{			
			if (e.target != _stage) return;
			
			_stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_stage.addEventListener(Event.MOUSE_LEAVE,mouseUpHandler);
			_p0.x = _stage.mouseX;
			_p0.y = _stage.mouseY;
		}
		
		protected function mouseMoveHandler(e:MouseEvent):void
		{
			if (!e.buttonDown) return;
			var dx:Number = _stage.mouseX - _p0.x;
			var dy:Number = _stage.mouseY - _p0.y;
			_controller.yaw(dx/40);
			_controller.pitch(dy/40);
			
			_p0.x = _stage.mouseX;
			_p0.y = _stage.mouseY;
		}
		
		protected function mouseUpHandler(e:*):void
		{
			_stage.removeEventListener(Event.MOUSE_LEAVE,mouseUpHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}
		
		protected function keyDownEventHandler(e:KeyboardEvent):void
		{
			_keyDown[e.keyCode] = true;
		}
		
		private function operate():void
		{
			var angle:Number = 30/180*Math.PI;
			var units:Number = 0.3;
			
			if(_keyDown[Keyboard.W])
				_controller.walk(units);
			else if(_keyDown[Keyboard.S])
				_controller.walk(-units);
			
			if(_keyDown[Keyboard.A])
				_controller.strafe(-units);
			else if(_keyDown[Keyboard.D])
				_controller.strafe(units);
			
			if(_keyDown[Keyboard.R])
				_controller.fly(units);
			else if(_keyDown[Keyboard.F])
				_controller.fly(-units);
			
			if(_keyDown[Keyboard.M])
				_controller.roll(-angle);
			else if(_keyDown[Keyboard.N])
				_controller.roll(angle);
		}
		
		protected function keyUpEventHandler(e:KeyboardEvent):void
		{
			_keyDown[e.keyCode] = false;			
		}
		
		public function init():void
		{
			_controller = new CameraController(CameraController.AIRCRAFT);
			
			projectionTransform = new PerspectiveMatrix3D();
			var aspect:Number = 4/3;
			var zNear:Number = 0.1;
			var zFar:Number = 1000;
			var fov:Number = 45*Math.PI/180;
			projectionTransform.perspectiveFieldOfViewLH(fov, aspect, zNear, zFar);
		}
		
		public var m:Matrix3D = new Matrix3D();
		
		public function loop():void
		{
			operate();
			m.identity();
			m.appendTranslation(0, 0, 12);
			m.append(_controller.viewMatrix);
			m.append(projectionTransform);
		}
	}
}