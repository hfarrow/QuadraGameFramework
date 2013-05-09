package quadra.world
{
	import quadra.world.managers.EntityManager;
	import quadra.world.managers.SystemManager;
	import quadra.world.managers.TagManager;

	public class EntityWorld
	{
		private var _entityManager:EntityManager;
		private var _systemManager:SystemManager;
		private var _tagManager:TagManager;
		
		public function EntityWorld()
		{
			_entityManager = new EntityManager(this);
			_systemManager = new SystemManager(this);
		}
		
		public function get entityManager():EntityManager
		{
			return _entityManager;
		}
		
		public function get systemManager():SystemManager
		{
			return _systemManager;
		}
		
		public function get tagManager():TagManager
		{
			return _tagManager;
		}
		
		public function createEntity(uniqueId:String=null):Entity
		{
			return _entityManager.createEntity(uniqueId);
		}
		
		public function removeEntity(entity:Entity):void
		{
			_entityManager.removeEntity(entity);
		}
		
		public function update(elapsedTime:Number):void
		{
			_systemManager.update(elapsedTime);
		}
	}
}