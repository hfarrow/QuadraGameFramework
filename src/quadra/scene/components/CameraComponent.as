package quadra.scene.components
{
	import flash.display.NativeMenu;
	import quadra.scene.Entity;
	import quadra.scene.IEntityComponent;
	import starling.display.DisplayObject;
	
	public class CameraComponent implements IEntityComponent
	{
		private var _entity:Entity;
		private var _viewContainer:DisplayObject;
		private var _isRotationLocked:Boolean;
		private var _xOffset:Number = 0;
		private var _yOffset:Number = 0;
		
		public function CameraComponent(viewContainer:DisplayObject, xOffset:Number=0, yOffset:Number=0, isRotationLocked:Boolean=false)
		{
			_viewContainer = viewContainer;
			_xOffset = xOffset;
			_yOffset = yOffset;
			_isRotationLocked = isRotationLocked;
		}
		
		public function init():void 
		{
			
		}
		
		public function destroy():void 
		{
			
		}
		
		public function get type():Class 
		{
			return CameraComponent;
		}
		
		public function get entity():Entity 
		{
			return _entity;
		}
		
		public function set entity(value:Entity):void 
		{
			_entity = value;
		}
		
		public function update(elapsedTime:Number):void 
		{			
			_viewContainer.x = -_entity.x + _xOffset;
			_viewContainer.y = -_entity.y + _yOffset;
			if (!_isRotationLocked)
			{
				_viewContainer.rotation = -_entity.rotation;
			}
		}
	}
}