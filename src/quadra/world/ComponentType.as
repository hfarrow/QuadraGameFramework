package quadra.world
{
	// TODO: component bit fields need to be converted to byte array because int will
	// be limited to a max of 32 unique component classes.

	public class ComponentType
	{
		private static var _sNextBit:int = 1;
		private static var _sNextId:int;
		
		private static function getNextBit():int
		{
			var bit:int = _sNextBit;
			_sNextBit <<= 1;
			return bit;
		}
		
		private static function getNextId():int
		{
			return _sNextId++;
		}
		
		private var _bit:int;
		private var _id:int;
		
		public function ComponentType()
		{
			_bit = getNextBit();
			_id = getNextId();
		}
		
		public function get bit():int
		{
			return _bit;
		}
		
		public function get id():int
		{
			return _id;
		}
	}
}