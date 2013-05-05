package quadra.world.managers
{
	import flash.utils.Dictionary;
	import quadra.world.SystemType;

	public class SystemTypeManager
	{
		private static var _sTypeMap:Dictionary = new Dictionary();
		
		public function SystemTypeManager()
		{
			
		}
		
		public static function getTypeFor(systemClass:Class):SystemType
		{
			var type:SystemType = _sTypeMap[systemClass] as SystemType;
			if (type == null)
			{
				type = new SystemType();
				setTypeFor(systemClass, type);
			}
			
			return type;
		}
		
		public static function setTypeFor(systemClass:Class, type:SystemType):void 
		{			
			_sTypeMap[systemClass] = type;
		}
		
		public static function getClassforType(type:SystemType):Class
		{
			for each (var systemClass:SystemType in _sTypeMap)
			{
				if (systemClass == type)
				{
					return _sTypeMap[type];
				}
			}
			
			return null;
		}
	}
}