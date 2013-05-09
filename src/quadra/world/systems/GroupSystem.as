package quadra.world.systems
{
	import quadra.utils.BitField;
	import quadra.world.Entity;
	import quadra.world.EntityFilter;
	import starling.events.Event;

	public class GroupSystem extends EntitySystem
	{
		private var _groupId:uint;
		
		public function GroupSystem(groupId:uint)
		{
			super(EntityFilter.empty());
			
			_groupId = groupId;
		}
		
		public function get groupBit():uint
		{
			return _groupId;
		}
		
		protected override function onEntityRefreshed(event:Event):void
		{
			if (!enabled)
			{
				return;
			}
			
			var entity:Entity = Entity(event.data);
			
			var contains:Boolean = entity.systemBits.isBitSet(_type);
			var isFiltered:Boolean = entity.isInGroup(_groupId);
			
			if (isFiltered && !contains) 
			{
				addEntity(entity);
			}
			else if (!isFiltered && contains)
			{
				removeEntity(entity);
			}
		}
	}
}