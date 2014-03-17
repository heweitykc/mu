package com.mu 
{
	/**
	 * ...
	 * @author callee
	 */
	public class Assets 
	{
		private static const monsters:Array = [
			"Monster01", "Monster02", "Monster03", "Monster04", "Monster05", "Monster06", "Monster07", "Monster08",
			"Monster09", "Monster10", "Monster11", "Monster12", "Monster32", "Monster100", "Monster101", "Monster102",
			"Monster104", "Monster105", "Monster106", "Monster108", "Monster109", "Monster110", "Monster111", "Monster112",
			"Monster113", "Monster114", "Monster115", "Monster116", "Monster118", "Monster120", "Monster122", "Monster123",
			"Monster124","Monster126","Monster127","Monster210"
		];
		public static function get randomMonster():String
		{
			return monsters[int(Math.random()*(monsters.length-1))];
		}
	}

}