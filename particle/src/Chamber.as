package  
{
	/**
	 * ...
	 * @author callee
	 */
	public class Chamber 
	{
		private var x1:Number, y1:Number, x2:Number, y2:Number;
		public function Chamber(x1:Number, y1:Number, x2:Number, y2:Number) 
		{
			this.x1 = x1;
			this.y1 = y1;
			this.x2 = x2;
			this.y2 = y2;
		}
		
		public function apply(part:Particle):void
		{
			if (part.position.x - part.size < x1 || part.position.x + part.size > x2)
				part.velocity.x = -part.velocity.x;

			if (part.position.y - part.size < y1 || part.position.y + part.size > y2)
				part.velocity.y = -part.velocity.y;
		}
	}

}