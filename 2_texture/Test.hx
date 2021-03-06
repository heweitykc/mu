import flash.events.MouseEvent;
import flash.net.FileReference;
typedef K = flash.ui.Keyboard;

@:bitmap("hxlogo.png")
class HaxeLogo extends flash.display.BitmapData {
}

class Shader extends hxsl.Shader {

	static var SRC = {
		var input : {
			pos : Float3,
			norm : Float3,
			uv : Float2,
		};
		var tuv : Float2;
		var lpow : Float;
		function vertex( mpos : M44, mproj : M44, light : Float3 ) {
			out = input.pos.xyzw * mpos * mproj;
			var tnorm = (input.norm * mpos).normalize();
			lpow = light.dot(tnorm).max(0);
			tuv = input.uv;
		}
		function fragment( tex : Texture ) {
			out = tex.get(tuv) * (lpow * 0.8 + 0.2);
		}
	};

}

class Test {
	var shader1:HShader3 = new HShader3();
	var stage : flash.display.Stage;
	var s : flash.display.Stage3D;
	var c : flash.display3D.Context3D;
	var shader : Shader;
	var pol : Polygon;
	var t : Float;
	var keys : Array<Bool>;
	var texture : flash.display3D.textures.Texture;

	var camera : Camera;

	function new() {
		stage = flash.Lib.current.stage;
		stage.doubleClickEnabled = true;
		stage.addEventListener( MouseEvent.DOUBLE_CLICK, onDbClick);
		return;
		t = 0;
		keys = [];		
		s = stage.stage3Ds[0];
		s.addEventListener( flash.events.Event.CONTEXT3D_CREATE, onReady );
		stage.addEventListener( flash.events.KeyboardEvent.KEY_DOWN, onKey.bind(true) );
		stage.addEventListener( flash.events.KeyboardEvent.KEY_UP, onKey.bind(false) );		
		flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, update);
		s.requestContext3D();
	}

	function onDbClick(e : flash.events.MouseEvent ) {
		
		var file:FileReference = new FileReference();
		file.save(shader1.exportShader());
	}
	
	function onKey( down, e : flash.events.KeyboardEvent ) {
		keys[e.keyCode] = down;
	}

	function onReady( _ ) {
		c = s.context3D;
		c.enableErrorChecking = true;
		c.configureBackBuffer( stage.stageWidth, stage.stageHeight, 0, true );

		shader = new Shader();
		camera = new Camera();

		pol = new Cube();
		pol.unindex();
		pol.addNormals();
		pol.addTCoords();
		pol.alloc(c);

		var logo = new HaxeLogo(0,0);
		texture = c.createTexture(logo.width, logo.height, flash.display3D.Context3DTextureFormat.BGRA, false);
		texture.uploadFromBitmapData(logo);
	}

	function update(_) {
		return;
		if( c == null || texture == null ) return;

		t += 0.01;

		c.clear(0, 0, 0, 1);
		c.setDepthTest( true, flash.display3D.Context3DCompareMode.LESS_EQUAL );
		c.setCulling(flash.display3D.Context3DTriangleFace.BACK);

		if( keys[K.UP] )
			camera.moveAxis(0,-0.1);
		if( keys[K.DOWN] )
			camera.moveAxis(0,0.1);
		if( keys[K.LEFT] )
			camera.moveAxis(-0.1,0);
		if( keys[K.RIGHT] )
			camera.moveAxis(0.1, 0);
		if( keys[109] )
			camera.zoom /= 1.05;
		if( keys[107] )
			camera.zoom *= 1.05;
		camera.update();

		var project = camera.m.toMatrix();

		var mpos = new flash.geom.Matrix3D();
		mpos.appendRotation(t * 10, flash.geom.Vector3D.Z_AXIS);

		var light = new flash.geom.Vector3D(Math.cos(t * 10) * 1, Math.sin(t * 5) * 2, Math.sin(t) * Math.cos(t) * 2);
		light.normalize();

		shader.mpos = mpos;
		shader.mproj = project;
		shader.light = light;
		shader.tex = texture;
		shader.bind(c, pol.vbuf);
		
		c.drawTriangles(pol.ibuf);
		c.present();
	}

	static function main() {
		haxe.Log.setColor(0xFF0000);
		var inst = new Test();
	}

}
