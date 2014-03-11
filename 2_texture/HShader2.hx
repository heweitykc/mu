package ;
import hxsl.Shader;
/**
 * ...
 * @author callee
 */
 class HShader2 extends Shader
{
	static var SRC = {
		var input : {
			pos : Float3,
			uv : Float3
		};
		var tuv : Float2;
		function vertex(mproj:M44) {
			out = input.pos.xyzw * mproj;
			tuv.xy = input.uv.xy;
		}
		function fragment( t : Texture ) {
			out = t.get(tuv,wrap);
		}
	};
}
