package quadra.world.lib.components
{
	import quadra.world.Entity;
	import quadra.world.IEntityComponent;
	import starling.display.DisplayObject;

	public class StarlingDisplayComponent implements IEntityComponent
	{
		private var _layer:int;
		private var _displayObject:DisplayObject
		public var lockedRotation:Boolean;
		public var autoCenter:Boolean;
		
		public function StarlingDisplayComponent(displayObject:DisplayObject, layer:int=-1, autoCenter:Boolean=false, lockedRotation:Boolean=false)
		{
			_displayObject = displayObject;
			_layer = layer;
			this.lockedRotation = lockedRotation;
			this.autoCenter = autoCenter;
		}
		
		public function get displayObject():DisplayObject
		{
			return _displayObject;
		}
		
		public function get layer():int
		{
			return _layer;
		}
	}
}