package quadra.world 
{
	import quadra.core.EventManager;
	import quadra.utils.BitField;
	import quadra.world.managers.EntityManager;
	public class Entity extends EventManager
	{
		private var _world:EntityWorld;
		private var _entityManager:EntityManager;
		private var _guid:String;
		private var _id:int;
		private var _typeBits:BitField;
		private var _systemBits:BitField;
		
		public function Entity(world:EntityWorld, guid:String)
		{
			_world = world;
			_guid = guid;
			_entityManager = _world.entityManager;
			
			_typeBits = new BitField();
			_systemBits = new BitField();
		}
		
		public function removeFromWorld():void
		{
			_world.removeEntity(this);
		}
		
		public function clear():void
		{
			_entityManager.removeAllEntityComponents(this);
			_typeBits.clearAllBits();
			_systemBits.clearAllBits();
			_id = -1;
		}
		
		public function get guid():String
		{
			return _guid;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set id(value:int):void
		{
			_id = value;
		}
		
		public function get typeBits():BitField
		{
			return _typeBits;
		}
		
		public function set typeBits(value:BitField):void
		{
			_typeBits = value;
		}
		
		public function get systemBits():BitField
		{
			return _systemBits;
		}
		
		public function set systemBits(value:BitField):void
		{
			_systemBits = value;
		}
		
		public function addComponent(component:IEntityComponent):void
		{
			_entityManager.addEntityComponent(this, component);
		}
		
		public function removeComponent(componentClass:Class):void
		{
			_entityManager.removeEntityComponent(this, componentClass);
		}
		
		public function removeAllComponents():void
		{
			_entityManager.removeAllEntityComponents(this);
		}
		
		public function getComponent(componentClass:Class):IEntityComponent
		{
			return _entityManager.getEntityComponent(this, componentClass);
		}
		
		public function refresh():void
		{
			_entityManager.refresh(this);
		}
	}
}