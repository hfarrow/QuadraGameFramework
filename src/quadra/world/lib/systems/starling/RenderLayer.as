package quadra.world.lib.systems.starling
{
	import starling.display.DisplayObjectContainer;
	internal class RenderLayer
	{
		private var _name:String;
		private var _layer:int;
		private var _root:DisplayObjectContainer;
		
		public function RenderLayer(name:String, layer:int, root:DisplayObjectContainer)
		{
			_name = name;
			_layer = layer;
			_root = root;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get layer():int
		{
			return _layer;
		}
		
		public function get root():DisplayObjectContainer
		{
			return _root;
		}
	}
}