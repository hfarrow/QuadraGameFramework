package quadra.world.systems
{
	import quadra.utils.BitField;
	import quadra.world.Entity;
	import quadra.world.EntityFilter;
	import starling.events.Event;

	public class GroupSystem extends EntitySystem
	{
		private var _groupId:uint;
		
		public function GroupSystem(groupId:uint, filter:EntityFilter = null)
		{
			super(filter);
			
			_groupId = groupId;
		}
		
		public function get groupBit():uint
		{
			return _groupId;
		}
		
		protected override function isEntityFiltered(entity:Entity):Boolean
		{
			var isFiltered:Boolean;
			if (filter != null)
			{
				isFiltered = entity.isInGroup(_groupId) && _filter.isFiltered(entity);
			}
			else
			{
				isFiltered = entity.isInGroup(_groupId);
			}
			
			return isFiltered;
		}
	}
}