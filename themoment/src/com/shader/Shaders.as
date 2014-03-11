package com.shader 
{
	/**
	 * ...
	 * @author callee
	 */
	public class Shaders 
	{
		public static const GLShader:Array = [
				"mov vt0.x, va0.zxxx\n" + 
				"mov vt1, vc[vt0.x]\n" + 
				"cos vt0.y, vt1.xxxx\n" + 
				"sin vt2.y, vt1.yyxx\n" + 
				"sin vt2.z, vt1.xxxx\n" + 
				"cos vt0.x, vt1.yxxx\n" + 
				"mul vt3.y, vt0.y, vt2.y\n" + 
				"cos vt2.w, vt1.zzzz\n" + 
				"mul vt3.w, vt2.zzzz, vt0.xxxx\n" + 
				"sin vt2.x, vt1.zxxx\n" + 
				"mul vt3.x, vt3.y, vt2.w\n" + 
				"mul vt3.z, vt3.w, vt2.x\n" + 
				"mul vt1.y, vt0.yyxx, vt0.xxxx\n" + 
				"mul vt1.w, vt2.zzzz, vt2.yyyy\n" + 
				"add vt0.w, vt3.xxxx, vt3.zzzz\n" + 
				"mul vt1.x, vt1.yxxx, vt2.xxxx\n" + 
				"mul vt1.z, vt1.wwwx, vt2.wwwx\n" + 
				"mul vt3.z, vc108.xxxx, vt0.wwwx\n" + 
				"sub vt4.x, vt1.xxxx, vt1.zxxx\n" + 
				"mul vt3.y, vt3.zzxx, vt0.wwxx\n" + 
				"mul vt1.x, vc108.xxxx, vt4.xxxx\n" + 
				"sub vt3.x, vc108.yxxx, vt3.yxxx\n" + 
				"mul vt3.w, vt1.xxxx, vt4.xxxx\n" + 
				
				"sub vt5.x, vt3.xxxx, vt3.wxxx\n" + 
				"mul vt3.y, vt2.zzxx, vt0.xxxx\n" + 
				"mul vt3.w, vt0.yyyy, vt2.yyyy\n" + 
				"mul vt6.y, vt0.yyxx, vt0.xxxx\n" + 
				"mul vt6.w, vt2.zzzz, vt2.yyyy\n" + 
				"mul vt3.x, vt3.yxxx, vt2.wxxx\n" + 
				"mul vt3.z, vt3.w, vt2.x\n" + 
				"mul vt6.x, vt6.y, vt2.w\n" + 
				"mul vt6.z, vt6.wwwx, vt2.xxxx\n" + 
				"sub vt0.z, vt3.xxxx, vt3.zzzx\n" + 
				"add vt4.y, vt6.xxxx, vt6.zzxx\n" + 
				"mul vt1.z, vc108.xxxx, vt0.zzzx\n" + 
				"mul vt2.x, vc108.xxxx, vt4.yxxx\n" + 
				"mul vt1.y, vt1.zzxx, vt0.wwxx\n" + 
				"mul vt1.w, vt2.xxxx, vt4.xxxx\n" + 
				"add vt5.y, vt1.yyxx, vt1.wwxx\n" + 
				"mul vt2.z, vc108.xxxx, vt0.zzzx\n" + 
				"mul vt1.x, vc108.xxxx, vt4.yxxx\n" + 
				"mul vt2.y, vt2.zzxx, vt4.xxxx\n" + 
				"mul vt2.w, vt1.xxxx, vt0.wwww\n" + 
				"sub vt5.z, vt2.yyyx, vt2.wwwx\n" + 
				"mov vt5.w, vc108.zzzz\n" + 
				"mul vt1.z, vc108.xxxx, vt0.zzzx\n" + 
				"mul vt2.x, vc108.xxxx, vt4.yxxx\n" + 
				"mul vt1.y, vt1.zzxx, vt0.wwxx\n" + 
				"mul vt1.w, vt2.xxxx, vt4.xxxx\n" + 
				
				"sub vt3.x, vt1.yxxx, vt1.wxxx\n" + 
				"mul vt2.w, vc108.xxxx, vt0.zzzz\n" + 
				"mul vt2.z, vt2.wwwx, vt0.zzzx\n" + 
				"mul vt1.y, vc108.xxxx, vt4.xxxx\n" + 
				"sub vt2.y, vc108.yyxx, vt2.zzxx\n" + 
				"mul vt1.x, vt1.yxxx, vt4.xxxx\n" + 
				"sub vt3.y, vt2.yyxx, vt1.xxxx\n" + 
				"mul vt1.w, vc108.xxxx, vt0.wwww\n" + 
				"mul vt2.y, vc108.xxxx, vt4.yyxx\n" + 
				"mul vt1.z, vt1.wwwx, vt4.xxxx\n" + 
				"mul vt2.x, vt2.yxxx, vt0.zxxx\n" + 
				"add vt3.z, vt1.zzzx, vt2.xxxx\n" + 
				"mov vt3.w, vc108.zzzz\n" + 
				"mul vt2.w, vc108.xxxx, vt0.zzzz\n" + 
				"mul vt1.y, vc108.xxxx, vt4.yyxx\n" + 
				"mul vt2.z, vt2.wwwx, vt4.xxxx\n" + 
				"mul vt1.x, vt1.yxxx, vt0.wxxx\n" + 
				
				"add vt6.x, vt2.zxxx, vt1.xxxx\n" + 
				"mul vt1.w, vc108.xxxx, vt0.wwww\n" + 
				"mul vt2.y, vc108.xxxx, vt4.yyxx\n" + 
				"mul vt1.z, vt1.wwwx, vt4.xxxx\n" + 
				"mul vt2.x, vt2.yxxx, vt0.zxxx\n" + 
				"sub vt6.y, vt1.zzxx, vt2.xxxx\n" + 
				"mul vt4.x, vc108.xxxx, vt0.zxxx\n" + 
				"mul vt2.w, vt4.xxxx, vt0.zzzz\n" + 
				"mul vt4.z, vc108.xxxx, vt0.wwwx\n" + 
				"sub vt2.z, vc108.yyyx, vt2.wwwx\n" + 
				"mul vt4.y, vt4.zzxx, vt0.wwxx\n" + 
				"sub vt6.z, vt2.zzzx, vt4.yyyx\n" + 
				"mov vt6.w, vc108.zzzz\n" + 
				
				"add vt4.w, va0.zzzz, vc108.yyyy\n" + 
				"mov vt0.x, vt4.wxxx\n" + 
				"mov vt4, vc[vt0.x]\n" + 
				"mov vt4.w, vc108.y\n" + 
				
				
				"mov vt0, vt5\n" + 	//vt5 line0
				"mov vt1, vt3\n" + 	//vt3 line1
				"mov vt2, vt6\n" + 	//vt6 line2
				"mov vt3, vt4\n" + 				//vt4 line3
				
				
				//转置该矩阵
				/*"mov vt0.x, vc108.y\n" + 	//vt5 line0
				"mov vt0.y, vc108.z\n" + 	//vt5 line0
				"mov vt0.z, vc108.z\n" + 	//vt5 line0
				"mov vt0.w, vc108.z\n" + 	//vt5 line0
				
				"mov vt1.x, vc108.z\n" + 	//vt3 line1
				"mov vt1.y, vc108.y\n" + 	//vt3 line1
				"mov vt1.z, vc108.z\n" + 	//vt3 line1
				"mov vt1.w, vc108.z\n" + 	//vt3 line1
				
				"mov vt2.x, vc108.z\n" + 	//vt6 line2
				"mov vt2.y, vc108.z\n" + 	//vt6 line2
				"mov vt2.z, vc108.y\n" + 	//vt6 line2
				"mov vt2.w, vc108.z\n" + 	//vt6 line2
				
				"mov vt3.x, vc108.z\n" + 	//vt4 line3
				"mov vt3.y, vc108.z\n" + 	//vt4 line3
				"mov vt3.z, vc108.z\n" + 	//vt4 line3
				"mov vt3.w, vc108.y\n" + 	//vt4 line3*/
				
				
				"m44 vt4.xyzw, va1.xyzw, vt0\n" + 	//  vt4 = va1 * vt0
				"m44 op.xyzw, vt4.xyzw, vc109\n" + 
				
				"mov v0, vc0\n" + 
				"mov v0.xy, va0.xyxx\n",
				
				"tex oc, v0.xyxx, fs0 <linear mipdisable repeat 2d>\n"
		];
		
		public static const BONE0:Array = [
				//"mov op, va0\n" + 
				"m44 op, va0, vc109\n" + 
				"mov v0, va1" 			// copy UV
				,
				
				"mov oc, v0\n"
		];
		
		public static const SOFTBONE:Array = [				
				"mov vt0, va1\n" +
				"mov vt0.w, vc108.y\n" +
				"m44 op, vt0, vc109\n" +  	// pos to clipspace
				//"mov op, vt0\n" +
				"mov v0, va0.xy" 			// copy UV
				,
				"tex oc, v0, fs0 <2d>\n"
		];
		//有从1开始的N个VC，每一个半寄存器保存一根骨头数据
		//首先得讲不规则存放的6个浮点数取出
		public static const HARDBONE:Array = [
				"m44 op, va0, vc0\n" + 		// pos to clipspace
				
				//将骨骼索引i拷贝到vt0, i是奇数,vc位置为i*3, i是偶数,vc位置为 i*3+1.5
				//
				"mul vt0.x, va1.z, vc1.y\n" +  //骨骼平移数据的位置 = 顶点[6] * 常量[1].y(2)
				"add vt1.x, vt0.x, vc1.x\n" +  //骨骼旋转数据的位置 = 骨骼平移数据的位置 + 常量[1].x(1)
				//"mov vt2 vc[vt0.x]\n"		+	//取出平移数组
				"mov vt2 vc[vt1.x]\n"		+	//取出旋转数据
				
				
				"mov vt0, vc[va1.z]\n" +	//将骨骼索引拷贝到vt0
				"mov v0, va1" 				// copy UV
				,


				
				"tex ft1, v0, fs0 <2d>\n" +
				"mov oc, ft1"
		];
	}
}