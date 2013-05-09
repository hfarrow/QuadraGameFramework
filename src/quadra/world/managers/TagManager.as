package quadra.world.managers
{
	import flash.utils.Dictionary;
	import quadra.world.Entity;

	public class TagManager
	{
		private var _tagMap:Dictionary;
		
		public function TagManager()
		{
			_tagMap = new Dictionary(); 
		}
		
		public function registerTag(tag:String, entity:Entity):void
		{
			_tagMap[tag] = entity;
		}
		
		public function unregisterTag(tag:String):void
		{
			_tagMap[tag] = null;
		}
		
		public function isTagRegistered(tag:String):Boolean
		{
			return _tagMap[tag] != null;
		}
		
		public function getTag(tag:String):Entity
		{
			return _tagMap[tag];
		}
		
		public function getTagOfEntity(entity:Entity):String
		{
			for each (var key:String in _tagMap)
			{
				var taggedEntity:Entity = _tagMap[key];
				if (taggedEntity != entity)
				{
					return key;
				}
			}
			
			return null;
		}
	}
}