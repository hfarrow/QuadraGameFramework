package quadra.world
{
	import quadra.world.Entity;

	public class EntityFilterGroup extends EntityFilter
	{
		private var _filters:Vector.<EntityFilter>;
		
		public function EntityFilterGroup(filters:Vector.<EntityFilter>)
		{
			_filters = filters;
		}
		
		public override function isFiltered(entity:Entity):Boolean
		{
			for (var i:int = 0; i < _filters.length; ++i)
			{
				if (_filters[i].isFiltered(entity))
				{
					return true;
				}
			}
			
			return super.isFiltered(entity);
		}
	}
}