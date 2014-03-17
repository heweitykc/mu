package com.shader 
{
	/**
	 * ...
	 * @author callee
	 */
	public class CommonShader 
	{
		public static const V:String = "m44 vt0.xyzw,va0.xyzw,vc[va1.z]\n"+"m44 op,vt0,vc121\n"+"mov v0,va1";
		public static const F:String = "tex oc, v0, fs0<2d>\n";
		
	}

}