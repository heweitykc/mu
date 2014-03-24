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
			v1	 ���淨����		n
			
			fc0  ��ɫ
			fc1  ��Ҷȵĳ���
			fc2	 v,l���м�����	h  fc2.w=|h|
			fc4	 ���ϵĹ����	m_gls
			fc5	 ����ķ�����ɫ	S_spec
			fc27 ����[2,0,0,0]
		*/
		public static const F1:String = 
		"tex ft1, v0, fs0<2d>\n" + 
		"mul ft2.xyz, fc1.xyz, ft1.xyz \n" + 	//ft2.xyz=fc1.xyz*ft1.xyz
		"add ft2.w, ft2.x, ft2.y \n" + 			//ft2.w = ft2.x + ft2.y
		"add ft2.x, ft2.w, ft2.z \n" + 			//ft2.x = ft2.w + ft2.z
		"div ft2.w, ft2.x, fc1.w \n" + 			//ft2.w = ft2.x/fc1.w
		"add ft2.xyz, fc0.xyz, ft2.www \n" + 	//ft2.xyz=fc0.xyz * ft2.www
		"mov ft2.w,fc0.w\n" + 
		//ft2 ���ϵ���ɫ

		"dp3 ft1, v1.xyz, fc2.xyz\n" +				// n.h
		"pow ft0.x, ft1.x, fc4.x\n" +				//pow(n.h, m_gls)
		"mul ft1.xyz, ft0.xxx, fc5.xyz\n" +			//pow(n.h, m_gls) * S_spec
		"mul ft0.xyzw, ft1.xyzw, ft2.xyzw\n" +		//pow(n.h, m_gls) * S_spec * M_spec
		"mov ft0.w,fc0.w\n" + 
		"mov oc,ft0";
	}
}
/*

 ��׼���շ��̣�
D = D_spec + D_diff + D_amb

 ������۾����ڣ�
1. ������������
2. ����ķ�λ�ͳ���
3. ����Դ����
4. �۲���λ��

v 		�۲�������
n		���淨����
l		��Դ�ķ�����
h 		v,l���м����� v+l/|v+l|
m_gls	���ϵĹ����
S_spec  ���淴����ɫ
M_spec	���ϵķ�����ɫ

D_spec = pow((n*h),m_gls) * S_spec * M_spec

D_diff = 
D_amb = 

*/