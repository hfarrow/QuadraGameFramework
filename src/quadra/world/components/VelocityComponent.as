package quadra.world.components
{
	import nape.geom.Vec2;
	import quadra.world.Entity;
	import quadra.world.events.EntityEvent;
	import quadra.world.IEntityComponent;
	import starling.events.Event;
	

	public class VelocityComponent implements IEntityComponent
	{
		public var velocity:Vec2;
		private var _entity:Entity;
		
		public function VelocityComponent()
		{
			velocity = new Vec2();
		}
		
		public function init(entity:Entity):void
		{
			_entity = entity;
			_entity.addEventListener(EntityEvent.CHANGE_VELOCITY, changeVelocity);
		}
		
		public function shutdown():void
		{
			_entity.removeEventListener(EntityEvent.CHANGE_VELOCITY, changeVelocity);
			_entity = null;
		}
		
		private function changeVelocity(e:Event):void
		{
			velocity = Vec2(e.data);
		}
	}
}