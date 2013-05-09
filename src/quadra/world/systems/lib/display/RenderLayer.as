package quadra.world.systems.lib.display
{
	import starling.display.DisplayObjectContainer;
	internal class RenderLayer
	{
		private var _name:String;
		private var _layer:int;
		private var _container:DisplayObjectContainer;
		
		public function RenderLayer(name:String, layer:int, container:DisplayObjectContainer)
		{
			_name = name;
			_layer = layer;
			_container = container;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get layer():int
		{
			return _layer;
		}
		
		public function get container():DisplayObjectContainer
		{
			return _container;
		}
	}
}