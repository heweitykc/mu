package  
{
	/**
	 * ...
	 * @author callee
	 */
	public class Vector2 
	{
		public static const zero:Vector2 = new Vector2(0, 0);
		
		public var x:Number;
		public var y:Number;
		public function Vector2(x:Number, y:Number)
		{
			this.x = x;
			this.y = y;
		}
		
		public function copy():Vector2
		{
			return new Vector2(x,y);
		}
		
		public function length():Number
		{
			return Math.sqrt(x*x+y*y);
		}
		
		public function sqrLength():Number
		{
			return x*x + y*y;
		}
		
		public function normalize():Vector2
		{
			var inv:Number = 1 / length();
			return new Vector2(x*inv, y*inv);
		}
		
		public function negate():Vector2
		{
			return new Vector2(-x, -y);
		}
		
		public function add(v:Vector2):Vector2
		{
			return new Vector2(x+v.x, y+v.y);
		}
		
		public function subtract(v:Vector2):Vector2
		{
			return new Vector2(x-v.x, y-v.y);
		}
		
		public function multiply(f:Number):Vector2
		{
			return new Vector2(x*f, y*f);
		}
		
		public function divide(f:Number):Vector2
		{
			var inv:Number = 1 / f;
			return new Vector2(x*inv, y*inv);
		}
		
		public function dot(v:Vector2):Number
		{
			return x * v.x + y * v.y;
		}
	}

}
