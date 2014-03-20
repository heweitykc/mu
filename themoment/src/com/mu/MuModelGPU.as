package com.mu 
{
	import adobe.utils.CustomActions;
	import com.core.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display3D.Context3D;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.net.*;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author callee
	 */
	public class MuModelGPU extends Object3D
	{
		public var host:String = "http://stage3d.qiniudn.com/assets/";
		public var screenBMP:Shape = new Shape();
		
		public var BindPose:Array ;			//初始pose
		public var UsedBones:Array;			//用到的骨头
		
		private var _context3d:Context3D;
		private var _loader:URLLoader;
		private var _content:Array;
		private var _ok:Boolean = false;
		private var _meshs:Object;
		private var _name:String;
		protected var _animation:Animation;
		
		public function MuModelGPU(context3d:Context3D)
		{
			_context3d = context3d;
			_animation = new Animation(this);
		}
		
		public function load(name:String="Monster32"):void
		{
			_name = name;
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onOK);
			_loader.load(new URLRequest(host+name + "/" + name + ".smd"));
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
		}
		public function get animation():Animation
		{
			return _animation;
		}
		
		private function parsePose():void
		{
			var startp:int, endp:int, nodes:Array, animates:Array;
			startp = _content.indexOf("nodes") + 1;
			endp = _content.indexOf("end", startp);
			nodes = _content.slice(startp, endp);
			
			startp = _content.indexOf("skeleton") + 1;
			endp = _content.indexOf("end", startp);
			animates = _content.slice(startp, endp);
			
			var jointTree:Array = [];
			UsedBones = [0];	//有用的骨骼
			for (var i:int = 0; i < nodes.length; i++) {
				var arr:Array = nodes[i].split(" ");
				var boneid:int = int(arr[0]);
				var parentid:int = int(arr[arr.length-1]);
				jointTree[boneid] = parentid;
				if (boneid > 0 && parentid >= 0) { //除了0, 其他没有父节点的骨骼都是没用到的骨骼
					UsedBones.push(boneid);
				}
			}
			trace("有用的骨头:" + UsedBones.length);
			
			animation.JointTree = jointTree;
			
			BindPose = [];
			
			for (var j:int = 1; j < nodes.length + 1; j++) {
				var frame:Array = [];
				var framearr:Array = animates[j].split(" ");
				boneid = int(framearr[0]);
				var m:Matrix3D = new Matrix3D();				
				m.appendRotation(Number(framearr[4]) * 180 / Math.PI, Vector3D.X_AXIS);
				m.appendRotation(Number(framearr[5]) * 180 / Math.PI, Vector3D.Y_AXIS);
				m.appendRotation(Number(framearr[6]) * 180 / Math.PI, Vector3D.Z_AXIS);				
				m.appendTranslation(Number(framearr[1]), Number(framearr[2]), Number(framearr[3]));
				BindPose[boneid] = m;
			}
			
			//累积node的变换
			for (boneid = 0; boneid < nodes.length; boneid++) {
				var parentId:int = jointTree[boneid];	//由于节点是从小到大顺序的，父节点肯定是已经累加过的
				if (parentId > -1) {
					BindPose[boneid].append(BindPose[parentId]);
				}
			}
			
			for (boneid = 0; boneid < nodes.length; boneid++) {
				BindPose[boneid].invert();
			}
		}
		
		private function onOK(evt:Event):void
		{	
			_loader.removeEventListener(Event.COMPLETE, onOK);
			var spliter:String = String.fromCharCode(13, 10);
			_content = (_loader.data as String).split(spliter);
			
			parsePose();
			
			var startp:int = _content.indexOf("triangles") + 1;
			var endp:int = _content.indexOf("end", startp);
			computeSubMesh(startp, endp);
			
			for (var i:int = startp; i < endp; i += 4) {
				var key:String = _content[i];
				var mesh:SubMeshGPU = _meshs[key].submesh;
				var p0:Array = _content[i+1].split(" ");
				var p1:Array = _content[i + 2].split(" ");
				var p2:Array = _content[i + 3].split(" ");

				var bone0Index:uint = UsedBones.indexOf(uint(p0[0]));
				var bone1Index:uint = UsedBones.indexOf(uint(p1[0]));
				var bone2Index:uint = UsedBones.indexOf(uint(p2[0]));
				
				mesh.addBone(bone0Index);
				mesh.addBone(bone1Index);
				mesh.addBone(bone2Index);
				
				var gp0:Vector3D = getGlobalPos(Number(p0[1]), Number(p0[2]), Number(p0[3]), uint(p0[0]));
				var gp1:Vector3D = getGlobalPos(Number(p1[1]), Number(p1[2]), Number(p1[3]), uint(p1[0]));
				var gp2:Vector3D = getGlobalPos(Number(p2[1]), Number(p2[2]), Number(p2[3]), uint(p2[0]));
				
				_meshs[key].vertex.push(gp0.x, gp0.y, gp0.z,  Number(p0[7]), 1 - Number(p0[8]),mesh.getBoneIIndex(bone0Index)*4, Number(p0[4]), Number(p0[5]), Number(p0[6]));
				_meshs[key].vertex.push(gp1.x, gp1.y, gp1.z,  Number(p1[7]), 1 - Number(p1[8]),mesh.getBoneIIndex(bone1Index)*4, Number(p1[4]), Number(p1[5]), Number(p1[6]));
				_meshs[key].vertex.push(gp2.x, gp2.y, gp2.z,  Number(p2[7]), 1 - Number(p2[8]),mesh.getBoneIIndex(bone2Index)*4, Number(p2[4]), Number(p2[5]), Number(p2[6]));
				
				var idx:int = _meshs[key].index.length;
				_meshs[key].index.push(idx, idx + 1, idx + 2);
			}
			
			for each(var subObj:Object in _meshs) {
				var sub:SubMeshGPU = subObj.submesh;
				sub.upload(subObj.vertex, subObj.index);
				//trace(sub.img + ",顶点=" + subObj.vertex.length/6 + ", 骨头=" + sub.BoneCount);
			}
			
			_ok = true;
			
			_animation.load(host + _name + "/" + _name + "_001.smd");
		}
		
		private function getGlobalPos(x:Number, y:Number, z:Number, boneid:uint):Vector3D
		{
			var inputv:Vector3D = new Vector3D(x, y, z);
			var m1:Matrix3D = BindPose[boneid];
			return m1.transformVector(inputv);
		}
		
		private function computeSubMesh(startp:int, endp:int):void
		{
			_meshs = { };
			for (var i:int = startp; i < endp; i += 4) {
				var key:String = _content[i];
				if (!_meshs[key]) {
					_meshs[key] = { };
					_meshs[key].vertex =  new Vector.<Number>();
					_meshs[key].index =  new Vector.<uint>();
					_meshs[key].submesh = new SubMeshGPU(_context3d,this);
					_meshs[key].submesh.scale = 0.01;
					_meshs[key].img = host + _name + "/" + key;
					_meshs[key].submesh.img = _meshs[key].img;
				}
			}
		}
		
		public function render(frame:int):void
		{
			if (!_ok) return;
			for each(var mesh:Object in _meshs) {
				mesh.submesh.render(frame);
			}
		}
		
		public function test():void
		{
			
		}
	}

}