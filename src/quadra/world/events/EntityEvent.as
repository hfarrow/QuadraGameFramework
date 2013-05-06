package quadra.world.events
{
	import starling.events.Event;
	public class EntityEvent extends Event
	{
		// Global
		public static const CREATED:String = "Entity.CREATED";
		public static const REMOVED:String = "Entity.REMOVED";
		public static const REFRESHED:String = "Entity.REFRESHED";
		public static const COMPONENT_ADDED:String = "Entity.COMPONENT_ADDED";
		public static const COMPONENT_REMOVED:String = "Entity.COMPONENT_REMOVED";
		
		// local to entity
		public static const CHANGE_POSITION:String = "Entity.CHANGE_POSITION";
		public static const CHANGE_VELOCITY:String = "Entity.CHANGE_VELOCITY";
		public static const CHANGE_ROTATION:String = "Entity.CHANGE_ROTATION";
		public static const CHANGE_PHYSICS_SPACE:String = "Entity.CHANGE_PHYSICS_SPACE";
		
		public function EntityEvent(type:String, data:Object=null)
		{
			super(type, false, data);
		}
	}
}