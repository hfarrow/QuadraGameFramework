package quadra.world
{
	import quadra.world.managers.EntityManager;
	import quadra.world.managers.SystemManager;

	public class EntityWorld
	{
		private var _entityManager:EntityManager;
		private var _systemManager:SystemManager;
		
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
		
		public function createEntity(uniqueId:String):Entity
		{
			return _entityManager.createEntity(uniqueId);
		}
		
		public function update(elapsedTime:Number):void
		{
			
		}
	}
}