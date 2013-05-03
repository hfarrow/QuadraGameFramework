package quadra.world 
{
	import quadra.world.managers.EntityManager;
	public class Entity
	{
		private var _world:EntityWorld;
		private var _entityManager:EntityManager;
		private var _guid:String;
		private var _id:int;
		private var _typeBits:int;
		
		public function Entity(world:EntityWorld, guid:String)
		{
			_world = world;
			_guid = guid;
			
			_entityManager = _world.entityManager;
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
		
		public function get typeBits():int
		{
			return _typeBits;
		}
		
		public function set typeBits(value:int):void
		{
			_typeBits = value;
		}
		
		public function addTypeBit(typeBit:int):void
		{
			_typeBits |= typeBit;
		}
		
		public function removeTypeBit(typeBit:int):void
		{
			_typeBits &= ~typeBit;
		}
		
		public function addComponent(component:IComponent):void
		{
			_entityManager.addEntityComponent(this, component);
		}
		
		public function removeComponent(type:ComponentType):void
		{
			_entityManager.removeEntityComponent(this, type);
		}
		
		public function refresh():void
		{
			_entityManager.refresh(this);
		}
	}
}