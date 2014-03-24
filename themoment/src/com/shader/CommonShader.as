package com.shader 
{
	/**
	 * ...
	 * @author callee
	 */
	public class CommonShader 
	{
		public static const V0:String = "m44 op, va0, vc1\n" + "mov v0,va1\n"+ "mov v0.w,vc0.w\n";
		public static const F0:String = "mov oc, v0";
		
		public static const V:String = "m44 vt0.xyzw,va0.xyzw,vc[va1.z]\n" + "m44 op,vt0,vc121\n" + "mov v0,va1";
		public static const F:String = "tex oc, v0, fs0<2d>\n";
		
		public static const V1:String = 
		"m44 vt0.xyzw,va0.xyzw,vc[va1.z]\n" +
		"m44 op,vt0,vc121\n" + 
		"mov v0,va1\n" +	//uv bone
		"mov v1,va2";		//normal


		/*
			v1	 表面法向量		n
			
			fc0  金色
			fc1  求灰度的常量
			fc2	 v,l的中间向量	h  fc2.w=|h|
			fc4	 材料的光泽度	m_gls
			fc5	 镜面的反射颜色	S_spec
			fc27 常量[2,0,0,0]
		*/
		public static const F1:String = 
		"tex ft1, v0, fs0<2d>\n" + 
		"mul ft2.xyz, fc1.xyz, ft1.xyz \n" + 	//ft2.xyz=fc1.xyz*ft1.xyz
		"add ft2.w, ft2.x, ft2.y \n" + 			//ft2.w = ft2.x + ft2.y
		"add ft2.x, ft2.w, ft2.z \n" + 			//ft2.x = ft2.w + ft2.z
		"div ft2.w, ft2.x, fc1.w \n" + 			//ft2.w = ft2.x/fc1.w
		"add ft2.xyz, fc0.xyz, ft2.www \n" + 	//ft2.xyz=fc0.xyz * ft2.www
		"mov ft2.w,fc0.w\n" + 
		//ft2 材料的颜色

		"dp3 ft1, v1.xyz, fc2.xyz\n" +				// n.h
		"pow ft0.x, ft1.x, fc4.x\n" +				//pow(n.h, m_gls)
		"mul ft1.xyz, ft0.xxx, fc5.xyz\n" +			//pow(n.h, m_gls) * S_spec
		"mul ft0.xyzw, ft1.xyzw, ft2.xyzw\n" +		//pow(n.h, m_gls) * S_spec * M_spec
		"mov ft0.w,fc0.w\n" + 
		"mov oc,ft0";
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
h 		v,l的中间向量 v+l/|v+l|
m_gls	材料的光泽度
S_spec  镜面反射颜色
M_spec	材料的反射颜色

D_spec = pow((n*h),m_gls) * S_spec * M_spec

D_diff = 
D_amb = 

*/