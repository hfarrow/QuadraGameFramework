package quadra.world.events
{
	import starling.events.Event;
	public class EntityEvent extends Event
	{
		public static const CREATED:String = "Entity.CREATED";
		public static const REMOVED:String = "Entity.REMOVED";
		public static const REFRESHED:String = "Entity.REFRESHED";
		public static const COMPONENT_ADDED:String = "Entity.COMPONENT_ADDED";
		public static const COMPONENT_REMOVED:String = "Entity.COMPONENT_REMOVED";
		
		public function EntityEvent(type:String, data:Object=null)
		{
			super(type, false, data);
		}
	}
}