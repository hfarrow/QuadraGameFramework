package quadra.world.components
{
	import nape.geom.Vec2;
	import quadra.world.Entity;
	import quadra.world.events.EntityEvent;
	import quadra.world.IEntityComponent;
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class StarlingDisplayComponent implements IEntityComponent
	{
		private var _entity:Entity;
		private var _layer:int;
		public var displayObject:DisplayObject
		public var lockedRotation:Boolean;
		
		public function StarlingDisplayComponent(displayObject:DisplayObject, layer:int=-1, centered:Boolean=true, lockedRotation:Boolean=false)
		{
			this.displayObject = displayObject;
			_layer = layer;
			
			if (centered)
			{
				displayObject.pivotX = displayObject.width / 2;
				displayObject.pivotY = displayObject.height / 2;
			}
		}
		
		public function init(entity:Entity):void
		{
			_entity = entity;
			_entity.addEventListener(EntityEvent.CHANGE_POSITION, changePosition);
			_entity.addEventListener(EntityEvent.CHANGE_ROTATION, changeRotation);
		}
		
		public function shutdown():void
		{
			_entity.removeEventListener(EntityEvent.CHANGE_POSITION, changePosition);
			_entity.removeEventListener(EntityEvent.CHANGE_ROTATION, changeRotation);
			displayObject.removeFromParent();
			_entity = null;
		}
		
		public function get layer():int
		{
			return _layer;
		}
		
		private function changePosition(e:Event):void
		{
			var vec:Vec2 = Vec2(e.data);
			displayObject.x = vec.x;
			displayObject.y = vec.y;
		}
		
		private function changeRotation(e:Event):void
		{
			if (!lockedRotation)
			{
				displayObject.rotation = Number(e.data);
			}
		}
	}
}