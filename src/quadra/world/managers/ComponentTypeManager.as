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
		
		internal static function getTypeFor(componentType:Class):ComponentType
		{
			var type:ComponentType = _sTypeMap[componentType] as ComponentType;
			if (type == null)
			{
				type = new ComponentType();
				setTypeFor(componentType, type);
			}
			
			return type;
		}
		
		internal static function setTypeFor(componentType:Class, type:ComponentType):void 
		{			
			_sTypeMap[componentType] = type;
		}
	}
}