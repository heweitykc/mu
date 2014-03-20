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
			fc0  ��ɫ
			fc1  ��Ҷȵĳ���
			
			fc2	 �۲�������
			fc3	 ��Դ�ķ�����
			fc4	 ���ϵĹ����
			fc5	 ����ķ�����ɫ
			fc6	 ���ϵķ�����ɫ
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
r 		��������  = 2(n*l)n - 1
m_gls	���ϵĹ����
S_spec  ���淴����ɫ
M_spec	���ϵķ�����ɫ

D_spec = pow(v*r, m_gls) * S_spec * M_spec

D_diff = 
D_amb = 

*/