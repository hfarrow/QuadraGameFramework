package quadra.world.lib.components
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import quadra.world.Entity;
	import quadra.world.IEntityComponent;
	import starling.display.DisplayObject;

	public class StarlingDisplayComponent implements IEntityComponent
	{
		private var _layer:int;
		private var _displayObject:DisplayObject
		private var _renderTargetName:String;
		public var lockedRotation:Boolean;
		public var autoCenter:Boolean;
		
		private var _renderTargetChanged:Signal;
		public function get renderTargetChanged():ISignal { return _renderTargetChanged; }
		
		public function StarlingDisplayComponent(displayObject:DisplayObject, layer:int=-1, renderTargetName:String = null, autoCenter:Boolean=false, lockedRotation:Boolean=false)
		{
			_displayObject = displayObject;
			_layer = layer;
			_renderTargetName = renderTargetName;
			this.lockedRotation = lockedRotation;
			this.autoCenter = autoCenter;
			
			_renderTargetChanged = new Signal(StarlingDisplayComponent, String);
		}
		
		public function get displayObject():DisplayObject
		{
			return _displayObject;
		}
		
		public function get layer():int
		{
			return _layer;
		}
		
		public function get renderTargetName():String
		{
			return _renderTargetName;
		}
		
		public function set renderTarget(value:String):void
		{
			if (_renderTargetName != value)
			{
				var old:String = _renderTargetName;
				_renderTargetName = value;
				_renderTargetChanged.dispatch(this, old);
			}
		}
	}
}