package  
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author callee
	 */
	public class ParticleSystem 
	{
		private var _list:Vector.<Paricle>;
		private var _gravity:Vector3D;
		private var _effectors:Array;
		
		public function ParticleSystem() 
		{
			_list = new Vector.<Paricle>();
			_effectors = [];
			_gravity = new Vector3D(0, 100, 0);
		}
		
		public function emit(particle:Paricle):void
		{
			_list.push(particle);
		}
		
		public function simulate(dt:Number):void
		{
			aging(dt);
			applyGravity();
			applyEffectors();
			kinematics(dt);
		}
		
		private function aging(dt:Number):void
		{
			for (var i:int = 0; i < _list.length; i++) {
				var p:Paricle = _list[i];
				p.age += dt;
				if (p.age >= p.life)
					kill(i);
				else
					i++;
			}
		}
		
		private function applyGravity():void
		{
			for each(var part:Paricle in _list)
			{
				part.acceleration = this._gravity;
			}
		}
		
		private function applyEffectors():void
		{
			
		}
		
		private function kinematics(dt:Number):void
		{			
			for each(var part:Paricle in _list)
			{
				var v:Vector3D = part.velocity.clone();
				v.scaleBy(dt);
				
				var a:Vector3D = part.acceleration.clone();
				a.scaleBy(dt);
				
				part.position = part.position.add(v);
				part.velocity = part.velocity.add(a);
			}
		}
		
		private function kill(index:int):void
		{
			if (_list.length > 1)
				_list[index] = _list[_list.length - 1];
			_list.pop();
		}
		
		public function render(g:Graphics):void
		{
			for each(var part:Paricle in _list)
			{
				var alpha:Number = 1 - part.age / part.life;
				g.beginFill(part.color,alpha);
				g.drawCircle(part.position.x, part.position.y, part.size);
				g.endFill();
			}
		}
		
		public function num():int
		{
			return _list.length;
		}
	}
}
