package quadra.world
{
	public class ComponentType
	{
		private static var _sNextId:uint;
		
		private static function getNextId():uint
		{
			return _sNextId++;
		}
		
		private var _id:uint;
		
		public function ComponentType()
		{
			_id = getNextId();
		}
		
		public function get id():uint
		{
			return _id;
		}
	}
}