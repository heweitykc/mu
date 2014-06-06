package com.td 
{
	/**
	 * ...
	 * @author callee
	 */
	public class ShaderCode 
	{
        public static const VERTEX_SHADER:String =
			"mov vt0, va0 \n" + 
			"mul vt0.xy, vt0.xy, vc0.xy \n" + 
			"add vt0.xy, vt0.xy, vc1.xy \n" + 
            "mov op, vt0 \n" +
			"mov v0, va1"
			
        public static const FRAGMENT_SHADER:String = 			
			"tex ft0, v0.xy, fs0 <2d>   \n" +
			"mov oc, ft0";
	}

}