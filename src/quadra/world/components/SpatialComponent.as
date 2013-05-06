package quadra.world.components
{
	import nape.geom.Vec2;
	import quadra.world.Entity;
	import quadra.world.events.EntityEvent;
	import quadra.world.IEntityComponent;
	import starling.events.Event;
	

	public class SpatialComponent implements IEntityComponent
	{
		public var x:Number;
		public var y:Number;
		public var rotation:Number;
		
		private var _entity:Entity;
		
		public function SpatialComponent()
		{
			x = 0;
			y = 0;
			rotation = 0;
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
			_entity = null;
		}
		
		private function changePosition(e:Event):void
		{
			var vec:Vec2 = Vec2(e.data);
			x = vec.x;
			y = vec.y;
		}
		
		private function changeRotation(e:Event):void
		{
			rotation = Number(e.data);
		}
	}
}