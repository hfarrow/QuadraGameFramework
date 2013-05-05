package quadra.world.managers
{
	import quadra.world.EntityWorld;
	import quadra.world.systems.EntitySystem;

	public class SystemManager
	{
		private var _world:EntityWorld;
		private var _systems:Vector.<EntitySystem>
		
		public function SystemManager(world:EntityWorld)
		{
			_world = world;
			_systems = new Vector.<EntitySystem>();
		}
		
		public function addSystem(system:EntitySystem):void
		{
			_systems.push(system);
		}
		
		public function removeSystem(system:EntitySystem):void
		{
			for (var i:int = 0; i < _systems.length; ++i)
			{
				if (_systems[i] == system)
				{
					_systems.splice(i, 1);
					system.enabled = false;
				}
			}
		}
		
		public function removeAllSystems():void
		{
			for (var i:int = 0; i < _systems.length; ++i)
			{
				_systems[i].enabled = false;
				_systems[i].clear();
			}
			_systems.length = 0;
		}
		
		public function update(elapsedTime:Number):void
		{
			for (var i:int = 0; i < _systems.length; ++i)
			{
				_systems[i].update(elapsedTime);
			}
		}
	}
}