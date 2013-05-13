package quadra.world.managers
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import quadra.core.EventManager;
	import quadra.utils.GUID;
	import quadra.world.ComponentType;
	import quadra.world.Entity;
	import quadra.world.EntityWorld;
	import quadra.world.events.EntityEvent;
	import quadra.world.IEntityComponent;

	public class EntityManager
	{		
		private var _world:EntityWorld;
		private var _activeEntities:Dictionary;
		private var _nextEntityId:int;
		private var _entityComponents:Dictionary // entity : Vector.<IEntityComponent>
		
		public function EntityManager(world:EntityWorld)
		{
			_world = world;
			_activeEntities = new Dictionary();
			_entityComponents = new Dictionary();
		}
		
		public function createEntity(uniqueId:String = null):Entity
		{
			//if uniqueId is 0, generate a new unique ID.
			if (uniqueId == null)
			{
				uniqueId = GUID.create();
			}
			
			var entity:Entity = new Entity(_world, uniqueId);
			entity.id = _nextEntityId++;
			_activeEntities[entity.id] = entity;
			
			EventManager.global.dispatchEventWith(EntityEvent.CREATED, entity);
			
			return entity;
		}
		
		public function removeEntity(entity:Entity):void
		{
			if (_activeEntities[entity.id] != null)
			{
				_activeEntities[entity.id] = null;
				entity.removed = true;
				EventManager.global.dispatchEventWith(EntityEvent.REMOVED, entity)
				entity.typeBits.clearAllBits();
				entity.clearGroups();
				entity.refresh(); // Removes from systems.
				entity.clear();				
			}
		}
		
		public function addEntityComponent(entity:Entity, component:IEntityComponent):void
		{
			var components:Vector.<IEntityComponent> = _entityComponents[entity] as Vector.<IEntityComponent>
			if (components == null)
			{
				components = new Vector.<IEntityComponent>();
				_entityComponents[entity] = components;
			}
			
			var componentClass:Class = Class(getDefinitionByName(getQualifiedClassName(component)));
			var type:ComponentType = ComponentTypeManager.getTypeFor(componentClass);			
			components.push(component);
			
			entity.typeBits.setBit(type.id);
			
			EventManager.global.dispatchEventWith(EntityEvent.COMPONENT_ADDED, { entity:entity, component:component });
		}
		
		internal function removeEntityComponentByType(entity:Entity, type:ComponentType):void
		{
			removeEntityComponent(entity, ComponentTypeManager.getClassforType(type));
		}
		
		public function removeEntityComponent(entity:Entity, componentClass:Class):void
		{
			var components:Vector.<IEntityComponent> = _entityComponents[entity] as Vector.<IEntityComponent>
			if (components == null)
			{
				return;
			}
			
			for (var i:int = 0; i < components.length; ++i)
			{
				if (components[i] is componentClass)
				{
					var type:ComponentType = ComponentTypeManager.getTypeFor(componentClass)
					var removed:IEntityComponent = components.splice(i, 1)[0];
					entity.typeBits.clearBit(type.id);
					EventManager.global.dispatchEventWith(EntityEvent.COMPONENT_REMOVED, { entity:entity, component:removed });
					return;
				}
			}			
		}
		
		public function removeAllEntityComponents(entity:Entity):void
		{
			var components:Vector.<IEntityComponent> = _entityComponents[entity] as Vector.<IEntityComponent>
			if (components == null)
			{
				return;
			}
			
			components.length = 0;
		}
		
		public function getEntityComponent(entity:Entity, componentClass:Class):IEntityComponent
		{
			var components:Vector.<IEntityComponent> = _entityComponents[entity] as Vector.<IEntityComponent>
			if (components == null)
			{
				return null;
			}
			
			for (var i:int = 0; i < components.length; ++i)
			{
				if (components[i] is componentClass)
				{
					return components[i];
				}
			}
			
			return null;
		}
		
		public function refresh(entity:Entity):void
		{
			EventManager.global.dispatchEventWith(EntityEvent.REFRESHED, entity);
		}
	}
}