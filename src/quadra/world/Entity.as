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
		private var _groupBits:BitField;
		private var _removed:Boolean;
		
		// name is intended to help with debugging.
		public var debugName:String;
		
		public function Entity(world:EntityWorld, guid:String, debugName:String = "no-name")
		{
			_world = world;
			_guid = guid;
			_entityManager = _world.entityManager;
			this.debugName = debugName;
			
			_typeBits = new BitField();
			_systemBits = new BitField();
			_groupBits = new BitField();
			
			_removed = false;
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
			_groupBits.clearAllBits();
			_id = -1;
			_removed = false;
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
		
		public function addToGroup(groupId:uint):void
		{
			_groupBits.setBit(groupId);
		}
		
		public function removeFromGroup(groupId:uint):void
		{
			_groupBits.clearBit(groupId);
		}
		
		public function isInGroup(groupId:uint):Boolean
		{
			return _groupBits.isBitSet(groupId);
		}
		
		public function clearGroups():void
		{
			_groupBits.clearAllBits();
		}
		
		public function get tag():String
		{
			return _world.tagManager.getTagOfEntity(this);
		}
		
		public function set tag(value:String):void
		{
			if (value != null)
			{
				_world.tagManager.registerTag(value, this);
			}
			else if (tag != null)
			{
				_world.tagManager.unregisterTag(value);
			}
		}
		
		public function get removed():Boolean
		{
			return _removed;
		}
		
		public function set removed(value:Boolean):void
		{
			_removed = value;
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
		
		public function toString():String
		{
			return "Entity{" + debugName + ": type=" + _typeBits.toString() + " group=" + _groupBits.toString() + "}";
		}
	}
}