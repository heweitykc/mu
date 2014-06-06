package com.td 
{
	import flash.display3D.*;
	
	import com.adobe.utils.AGALMiniAssembler;
	/**
	 * ...
	 * @author callee
	 */
	public class Shaders 
	{	
		private var _vertexAssembly:AGALMiniAssembler = new AGALMiniAssembler();
        private var _fragmentAssembly:AGALMiniAssembler = new AGALMiniAssembler();
		private var _programPair:Program3D;
		private var _context3d:Context3D;
		
		public function Shaders(vcode:String, fcode:String, context:Context3D) 
		{
			_context3d = context;
            _vertexAssembly.assemble( Context3DProgramType.VERTEX, vcode, 1,false );
            _fragmentAssembly.assemble( Context3DProgramType.FRAGMENT, fcode, 1, false);	
		}
		
		public function useProg():void
		{
			if (!_programPair) {
				_programPair = _context3d.createProgram();
				_programPair.upload( _vertexAssembly.agalcode, _fragmentAssembly.agalcode);	
			}
			_context3d.setProgram(_programPair);
		}
		
		public function get context():Context3D
		{
			return _context3d;
		}
	}

}