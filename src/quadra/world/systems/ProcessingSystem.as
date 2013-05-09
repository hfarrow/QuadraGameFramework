package quadra.world.systems
{
	import quadra.world.Entity;
	import quadra.world.EntityFilter;
	import starling.events.Event;

	public class ProcessingSystem extends EntitySystem
	{
		public function ProcessingSystem()
		{
			super(EntityFilter.empty());
		}
		
		protected override function onEntityRefreshed(event:Event):void
		{			
		}
		
		protected override function processEntities(entities:Vector.<Entity>, elapsedTime:Number):void
		{
			process(elapsedTime);
		}
		
		protected function process(elapsedTime:Number):void
		{
			// Override this
		}		
	}
}