package quadra.world.managers
{
	import flash.utils.Dictionary;
	import quadra.world.ComponentType;

	public class ComponentTypeManager
	{
		private static var _sTypeMap:Dictionary = new Dictionary();
		
		public function ComponentTypeManager()
		{
			
		}
		
		public static function getTypeFor(componentClass:Class):ComponentType
		{
			var type:ComponentType = _sTypeMap[componentClass] as ComponentType;
			if (type == null)
			{
				type = new ComponentType();
				setTypeFor(componentClass, type);
			}
			
			return type;
		}
		
		public static function setTypeFor(componentClass:Class, type:ComponentType):void 
		{			
			_sTypeMap[componentClass] = type;
		}
		
		public static function getClassforType(type:ComponentType):Class
		{
			for each (var componentClass:ComponentType in _sTypeMap)
			{
				if (componentClass == type)
				{
					return _sTypeMap[type];
				}
			}
			
			return null;
		}
	}
}