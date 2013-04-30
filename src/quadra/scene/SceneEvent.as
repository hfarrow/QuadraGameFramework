package quadra.scene
{
	import starling.events.Event;

	public class SceneEvent extends Event
	{
		public static const ENTITY_CREATED:String = "sceneEntityCreated";
		public static const ENTITY_DESTROYED:String = "sceneEntityDestroyed";
		public static const DESTROYING_ENTITY:String = "sceneDestroyingEntity";
		
		public function SceneEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}