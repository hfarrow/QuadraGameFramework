package quadra.core
{	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	public class EventManager
	{
		public static var global:EventManager = new EventManager();
		
		private var _dispatcher:EventDispatcher = new EventDispatcher();
		
		public function EventManager():void
		{
			
		}
		
		public function addEventListener(type:String, listener:Function):void
		{
			_dispatcher.addEventListener(type, listener);
		}
		
		public function removeEventListener(type:String, listener:Function):void
		{
			_dispatcher.removeEventListener(type, listener);
		}
		
		public function dispatchEvent(event:Event):void
		{
			_dispatcher.dispatchEvent(event);
		}
		
		public function dispatchEventWith(type:String, data:Object = null, bubbles:Boolean = false):void
		{
			_dispatcher.dispatchEventWith(type, bubbles, data);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
	}
}