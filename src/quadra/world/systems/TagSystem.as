package quadra.world.systems
{
	import quadra.world.Entity;
	import quadra.world.EntityFilter;
	import starling.events.Event;

	public class TagSystem extends EntitySystem
	{
		private var _tag:String;
		
		public function TagSystem(tag:String)
		{
			super(EntityFilter.empty());
			
			_tag = tag;
		}
		
		public function get tag():String
		{
			return _tag;
		}
		
		protected function set tag(value:String):void
		{
			_tag = value;
		}
		
		protected override function onEntityRefreshed(event:Event):void
		{			
		}
		
		protected override function processEntities(entities:Vector.<Entity>, elapsedTime:Number):void
		{
			var entity:Entity = _world.tagManager.getTag(_tag);
			process(entity, elapsedTime);
		}
		
		protected function process(entity:Entity, elapsedTime:Number):void
		{
			// Override this
		}
	}
}