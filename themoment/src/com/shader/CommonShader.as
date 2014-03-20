package com.shader 
{
	/**
	 * ...
	 * @author callee
	 */
	public class CommonShader 
	{
		public static const V:String = "m44 vt0.xyzw,va0.xyzw,vc[va1.z]\n" + "m44 op,vt0,vc121\n" + "mov v0,va1";
		public static const F:String = "tex oc, v0, fs0<2d>\n";
		
		public static const V1:String = 
		"m44 vt0.xyzw,va0.xyzw,vc[va1.z]\n" +
		"m44 op,vt0,vc121\n" + 
		"mov v0,va1\n" +	//uv bone
		"mov v1,va2";		//normal


		/*
			fc0  金色
			fc1  求灰度的常量
			
			fc2	 观察者向量
			fc3	 光源的法向量
			fc4	 材料的光泽度
			fc5	 镜面的反射颜色
			fc6	 材料的反射颜色
			fc7
		*/
		public static const F1:String = 
		"tex ft1, v0, fs0<2d>\n" + 
		"mul ft2.xyz, fc1.xyz, ft1.xyz \n" + 	//ft2.xyz=fc1.xyz*ft1.xyz
		"add ft2.w, ft2.x, ft2.y \n" + 			//ft2.w = ft2.x + ft2.y
		"add ft2.x, ft2.w, ft2.z \n" + 			//ft2.x = ft2.w + ft2.z
		"div ft2.w, ft2.x, fc1.w \n" + 			//ft2.w = ft2.x/fc1.w
		"add ft2.xyz, fc0.xyz, ft2.www \n" + 	//ft2.xyz=fc0.xyz * ft2.www
		"mov ft2.w,fc0.w\n" + 
		
		"mov oc,ft2";
	}
}
/*

 标准光照方程：
D = D_spec + D_diff + D_amb

 物体外观决定于：
1. 物体表面的性质
2. 表面的方位和朝向
3. 各光源性质
4. 观察者位置

v 		观察者向量
n		表面法向量
l		光源的法向量
r 		反射向量  = 2(n*l)n - 1
m_gls	材料的光泽度
S_spec  镜面反射颜色
M_spec	材料的反射颜色

D_spec = pow(v*r, m_gls) * S_spec * M_spec

D_diff = 
D_amb = 

*/