package com.shader 
{
	/**
	 * ...
	 * @author callee
	 */
	public class CommonShader 
	{
		public static const V0:String = "m44 op, va0, vc1\n" + "mov v0,va1";
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
			fc2	 观察者向量		v
			fc3	 光源向量	l
			fc4	 材料的光泽度	m_gls
			fc5	 镜面的反射颜色	S_spec
			fc6	 材料的反射颜色	M_spec
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


		//lighting
		"mul ft0.xyz,v1.xyz,fc3.xyz\n" + 		// n*l
		"mul ft1.xyz,v1.xyz,ft0.xyz\n" + 		//(n*l)*n
		"mul ft1.xyz,fc27.xxx,ft1.xyz\n" + 		//(n*l)*n*2
		"sub ft4.xyz,ft1.xyz,fc3.xyz\n" + 		//(n*l)*n*2 - l
		"nrm ft0.xyz, ft4.xyz\n"		+
		// ft0  反射向量r
		
		"mul ft1.xyz, fc2.xyz, ft0.xyz\n" +			//v*r
		"pow ft0.xyz, ft1.xyz, fc4.xxx\n" +			//pow(v*r, m_gls)
		"mul ft1.xyz, ft0.xyz, fc5.xyz\n" +			//pow(v*r, m_gls) * S_spec
		"mul ft0.xyz, ft1.xyz, fc6.xyz\n" +			//pow(v*r, m_gls) * S_spec * M_spec
		"mul ft1.xyz, ft0.xyz, ft2.xyz\n" +			//系数 * ft2
		"mov ft1.w, fc0.w\n" +						//w=1

		"mov oc,ft1";
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
r 		反射向量  = 2(n*l)n - l
m_gls	材料的光泽度
S_spec  镜面反射颜色
M_spec	材料的反射颜色

D_spec = pow(v*r, m_gls) * S_spec * M_spec

D_diff = 
D_amb = 

*/