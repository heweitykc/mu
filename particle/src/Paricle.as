package  
{
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author callee
	 */
	public class Paricle 
	{
		public var position:Vector3D;
		public var velocity:Vector3D;
		public var acceleration:Vector3D;
		public var age:Number;
		public var life:Number;
		public var color:uint;
		public var size:int;
		
		public function Paricle(position:Vector3D, velocity:Vector3D, life:Number, color:uint, size:int) 
		{
			this.position = position;
			this.velocity = velocity;
			this.life = life;
			this.age = 0;
			this.color = color;
			this.size = size;
		}
	}

}