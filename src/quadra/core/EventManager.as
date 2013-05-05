package quadra.core
{	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	public class EventManager
	{
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		
		public function EventManager():void
		{
			throw new Error("EventManager is a Singleton");
		}
		
		public static function addEventListener(type:String, listener:Function):void
		{
			dispatcher.addEventListener(type, listener);
		}
		
		public static function removeEventListener(type:String, listener:Function):void
		{
			dispatcher.removeEventListener(type, listener);
		}
		
		public static function dispatchEvent(event:Event):void
		{
			dispatcher.dispatchEvent(event);
		}
		
		public static function dispatchEventWith(type:String, data:Object = null, bubbles:Boolean = false):void
		{
			dispatcher.dispatchEventWith(type, bubbles, data);
		}
		
		public static function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
	}
}