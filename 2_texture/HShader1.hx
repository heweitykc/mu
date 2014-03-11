package ;
import hxsl.Shader;
/**
 * ...
 * @author callee
 */
 class HShader1 extends Shader
{
	static var SRC = {
        var input : {
            pos : Float3,
			pcolor:  Float3
        };
        var color : Float3;
        function vertex(mproj:M44) {
            out = input.pos.xyzw * mproj;
            color = input.pcolor;
        }
        function fragment() {
			var c:Float4;
			c.x = color.x;
			c.y = color.y;
			c.z = color.z;
			c.w = 1;
            out = c;
        }
    }
}
