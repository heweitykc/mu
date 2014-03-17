package com.core 
{
	import com.mu.MuModel;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
		
	/**
	 * ...
	 * @author callee
	 */
	public class Animation 
	{		
		public var JointTree:Array;			//关节树
		
		public var OK:Boolean = false;
		
		private var _animates:Array;
		private var _nodes:Array;
		
		private var _GPUframes:Array;
		private var _loader:URLLoader;
		protected var _model:*;
		
		public function Animation(model:*) 
		{
			_model = model;
		}
		
		public function load(path:String):void
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onOK);
			_loader.load(new URLRequest(path));
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
		}
		
		private function onOK(evt:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE, onOK);
			var spliter:String = String.fromCharCode(13, 10);
			var content:Array = (_loader.data as String).split(spliter);
			var startp:int, endp:int;
			startp = content.indexOf("nodes") + 1;
			endp = content.indexOf("end", startp);
			_nodes = content.slice(startp, endp);
			
			startp = content.indexOf("skeleton") + 1;
			endp = content.indexOf("end", startp);
			_animates = content.slice(startp, endp);
			
			trace("_nodes长度" + _nodes.length);
			trace("_animates长度" + _animates.length/(_nodes.length+1));
			
			parse();
		}
		
		private function parse():void
		{
			//build animations
			_GPUframes = [];
			var nodeLen:int = _nodes.length + 1;
			var animatelen:int = _animates.length / (_nodes.length + 1);
			
			for (var i:int = 0; i < animatelen; i++) {
				var frame:Array = [];
				var GPUframe:Array = [];
				for (var j:int = 1; j < nodeLen; j++) {
					var framearr:Array = _animates[i * nodeLen + j].split(" ");
					var boneid:int = int(framearr[0]);
					var m:Matrix3D = new Matrix3D();					
					m.appendRotation(Number(framearr[4]) * 180 / Math.PI, Vector3D.X_AXIS);
					m.appendRotation(Number(framearr[5]) * 180 / Math.PI, Vector3D.Y_AXIS);
					m.appendRotation(Number(framearr[6]) * 180 / Math.PI, Vector3D.Z_AXIS);					
					m.appendTranslation(Number(framearr[1]), Number(framearr[2]), Number(framearr[3]));
					frame[boneid] = m;					
				}
				
				//累积node的变换
				for (boneid = 0; boneid < _nodes.length; boneid++) {
					var parentId:int = JointTree[boneid];	//由于节点是从小到大顺序的，父节点肯定是已经累加过的
					if (parentId > -1)
						frame[boneid].append(frame[parentId]);
					if (_model.UsedBones.indexOf(boneid) < 0) continue;	//跳过没用的骨骼
					//GPUframe.push(formatTransform(frame[boneid].decompose(Orientation3D.EULER_ANGLES)));
					GPUframe.push(frame[boneid]);
				}
				_GPUframes.push(GPUframe);
			}
			OK = true;
		}
		
		private function formatTransform(tdata:Vector.<Vector3D>):Vector.<Number>
		{
			var ts:Vector.<Number> = new Vector.<Number>();
			ts.push(tdata[0].x, tdata[0].y, tdata[0].z);
			ts.push(tdata[1].x, tdata[1].y, tdata[1].z);
			return ts;
		}
			
		public function computeVertex(x:Number,y:Number,z:Number,frame:int,boneIndex:int):Vector3D
		{
			frame = frame % _GPUframes.length;
			var vdata:Vector.<Number> = _GPUframes[frame][boneIndex];
			return GeomTool.translateVector(vdata, new Vector3D(x, y, z));
		}
		
		public function getBoneAnimation(frame:int):Array
		{
			frame = frame % _GPUframes.length;
			return _GPUframes[frame];
		}
		
		private var _cache:Array = [];
		
		public function get len():int
		{
			return _GPUframes.length;
		}
	}

}