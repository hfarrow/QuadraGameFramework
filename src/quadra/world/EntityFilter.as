package quadra.world
{
	import quadra.utils.BitField;
	import quadra.world.ComponentType;
	import quadra.world.Entity;
	import quadra.world.managers.ComponentTypeManager;

	public class EntityFilter
	{
		private var _oneTypesMap:BitField;
		private var _containsTypeMap:BitField;
		private var _excludesTypeMap:BitField;
		
		public function EntityFilter()
		{
			_oneTypesMap = new BitField();
			_containsTypeMap = new BitField();
			_excludesTypeMap = new BitField();
		}
		
		public static function empty():EntityFilter
		{
			return new EntityFilter();
		}
		
		public static function all(types:Array):EntityFilter
		{
			return new EntityFilter().addAll(types);
		}
		
		public static function exclude(types:Array):EntityFilter
		{
			return new EntityFilter().addExclude(types);
		}
		
		public static function one(types:Array):EntityFilter
		{
			return new EntityFilter().addOne(types);
		}
		
		public function addAll(types:Array):EntityFilter
		{
			for (var i:int = 0; i < types.length; ++i)
			{
				_containsTypeMap.setBit(ComponentTypeManager.getTypeFor(types[i] as Class).id);
			}
			
			return this;
		}
		
		public function addExclude(types:Array):EntityFilter
		{
			for (var i:int = 0; i < types.length; ++i)
			{
				_excludesTypeMap.setBit(ComponentTypeManager.getTypeFor(types[i] as Class).id);
			}
			
			return this;
		}
		
		public function addOne(types:Array):EntityFilter
		{
			for (var i:int = 0; i < types.length; ++i)
			{
				_oneTypesMap.setBit(ComponentTypeManager.getTypeFor(types[i] as Class).id);
			}
			
			return this;
		}
		
		public function isFiltered(entity:Entity):Boolean
		{
			if (_containsTypeMap.isEmpty() && _excludesTypeMap.isEmpty() && _oneTypesMap.isEmpty())
            {
                return true;
            }
			
			return (_oneTypesMap.intersects(entity.typeBits) || _oneTypesMap.isEmpty()) &&
				   (_containsTypeMap.contains(entity.typeBits) || _containsTypeMap.isEmpty()) &&
				   (!_excludesTypeMap.contains(entity.typeBits) || _excludesTypeMap.isEmpty());
		}
	}
}