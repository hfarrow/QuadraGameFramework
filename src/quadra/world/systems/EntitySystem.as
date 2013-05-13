package quadra.world.systems
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import quadra.core.EventManager;
	import quadra.world.Entity;
	import quadra.world.EntityFilter;
	import quadra.world.EntityWorld;
	import quadra.world.events.EntityEvent;
	import quadra.world.managers.SystemTypeManager;
	import starling.events.Event;

	public class EntitySystem
	{
		protected var _type:uint;
		protected var _world:EntityWorld;
		protected var _filter:EntityFilter;
		private var _entities:Vector.<Entity>;
		private var _entityIndexMap:Dictionary;
		public var enabled:Boolean;
		
		public function EntitySystem(filter:EntityFilter = null)
		{
			_filter = filter;
			_entities = new Vector.<Entity>();
			_entityIndexMap = new Dictionary();
			enabled = true;
			
			var typeClass:Class = Class(getDefinitionByName(getQualifiedClassName(this)));
			_type = SystemTypeManager.getTypeFor(typeClass).id;
			
			EventManager.global.addEventListener(EntityEvent.REFRESHED, onEntityRefreshed);
		}
		
		public function init():void
		{
			
		}
		
		public function clear():void
		{
			_entities.length = 0;
			_entityIndexMap = new Dictionary();
		}
		
		public function get world():EntityWorld
		{
			return _world;
		}
		
		public function set world(value:EntityWorld):void
		{
			_world = value;
		}
		
		//public function set type(value:uint):void
		//{
			//_type = value;
		//}
		
		public function get type():uint
		{
			return _type;
		}
		
		public function get filter():EntityFilter
		{
			return _filter;
		}
		
		public function update(elapsedTime:Number):void
		{
			if (enabled)
			{
				beginProcessing(elapsedTime);
				processEntities(_entities, elapsedTime);
				endProcessing(elapsedTime);
			}
		}
		
		protected function beginProcessing(elaspedTime:Number):void
		{
			// override this
		}
		
		protected function processEntities(entities:Vector.<Entity>, elaspedTime:Number):void
		{
			// override this
		}
		
		protected function endProcessing(elaspedTime:Number):void
		{
			// override this
		}
		
		protected function onEntityRefreshed(event:Event):void
		{
			if (!enabled)
			{
				return;
			}
			
			var entity:Entity = Entity(event.data);
			
			var contains:Boolean = entity.systemBits.isBitSet(_type);
			var isFiltered:Boolean = true;
			if (_filter != null)
			{
				isFiltered = _filter.isFiltered(entity);
			}
			else
			{
				isFiltered = false;
			}
			
			if (isFiltered && !contains)
			{
				addEntity(entity);
			}
			else if (!isFiltered && contains)
			{
				removeEntity(entity);
			}
		}
		
		protected function addEntity(entity:Entity):void
		{
			if (_entityIndexMap[entity.id] == null)
			{
				_entityIndexMap[entity.id] = _entities.length;
				_entities.push(entity);
				entity.systemBits.setBit(_type);
				onEntityAdded(entity);
			}
		}
		
		protected function removeEntity(entity:Entity):void
		{
			if (_entityIndexMap[entity.id] != null)
			{
				var index:int = _entityIndexMap[entity.id];
				_entities.splice(index, 1);
				_entityIndexMap[entity.id] = null;
				entity.systemBits.clearBit(_type);
				
				// Todo remove splice and swap entities instead?
				
				// Recalculate index map because enties have shifted.
				for (var i:int = index; i < _entities.length; ++i)
				{
					_entityIndexMap[_entities[i].id] = i;
				}
				
				onEntityRemoved(entity);
			}
		}
		
		protected function onEntityAdded(entity:Entity):void
		{
			// override this
		}
		
		protected function onEntityRemoved(entity:Entity):void
		{
			// override this
		}
	}
}