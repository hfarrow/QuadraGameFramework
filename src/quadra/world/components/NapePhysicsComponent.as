package quadra.world.components
{
	import nape.phys.Body;
	import nape.space.Space;
	import quadra.world.Entity;
	import quadra.world.events.EntityEvent;
	import quadra.world.IEntityComponent;
	import starling.events.Event;

	public class NapePhysicsComponent implements IEntityComponent
	{
		public var body:Body;
		private var _entity:Entity;
		
		public function NapePhysicsComponent(body:Body)
		{
			this.body = body;
		}
		
		public function init(entity:Entity):void
		{
			_entity = entity;
			_entity.addEventListener(EntityEvent.CHANGE_PHYSICS_SPACE, changePhysicsSpace);
		}
		
		public function shutdown():void
		{
			_entity.removeEventListener(EntityEvent.CHANGE_PHYSICS_SPACE, changePhysicsSpace);
			_entity = null;
			body.space = null;
		}
		
		private function changePhysicsSpace(e:Event):void 
		{
			body.space = e.data as Space;
		}
	}
}