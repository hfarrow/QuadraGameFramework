package quadra.world.managers
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import quadra.core.EventManager;
	import quadra.util.GUID;
	import quadra.world.ComponentType;
	import quadra.world.Entity;
	import quadra.world.EntityWorld;
	import quadra.world.events.EntityEvent;
	import quadra.world.IComponent;

	public class EntityManager
	{		
		private var _world:EntityWorld;
		private var _activeEntities:Dictionary;
		private var _nextEntityId:int;
		private var _entityComponents:Dictionary // entity : Vector.<IComponent>
		
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
			
			EventManager.dispatchEvent(new EntityEvent(EntityEvent.CREATED, entity));
			
			return entity;
		}
		
		public function addEntityComponent(entity:Entity, component:IComponent):void
		{
			var components:Vector.<IComponent> = _entityComponents[entity] as Vector.<IComponent>
			if (components == null)
			{
				components = new Vector.<IComponent>();
				_entityComponents[entity] = components;
			}
			
			var componentClass:Class = Class(getDefinitionByName(getQualifiedClassName(component)));
			var type:ComponentType = ComponentTypeManager.getTypeFor(componentClass);			
			components.push(component);
			
			entity.addTypeBit(type.bit);
			
			EventManager.dispatchEvent(new EntityEvent(EntityEvent.COMPONENT_ADDED, { entity:entity, component:component } ));
		}
		
		public function removeEntityComponent(entity:Entity, type:ComponentType):void
		{
			var components:Vector.<IComponent> = _entityComponents[entity] as Vector.<IComponent>
			if (components == null)
			{
				return;
			}
			
			var removed:IComponent;
			for (var i:int = 0; i < components.length; ++i)
			{
				var componentClass:Class = Class(getDefinitionByName(getQualifiedClassName(components[i])));
				if (components[i] is componentClass)
				{
					removed = components.splice(i, 1)[0];
					break;
				}
			}
			
			if (removed == null)
			{
				return;
			}
			
			entity.removeTypeBit(type.bit);			
			EventManager.dispatchEvent(new EntityEvent(EntityEvent.COMPONENT_REMOVED, { entity:entity, component:removed } ));
		}
		
		public function refresh(entity:Entity):void
		{
			// TODO: notify systems of changed entity
		}
	}
}