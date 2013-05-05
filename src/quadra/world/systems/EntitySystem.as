package quadra.world.systems
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import quadra.core.EventManager;
	import quadra.world.Entity;
	import quadra.world.events.EntityEvent;
	import quadra.world.managers.SystemTypeManager;
	import starling.events.Event;

	public class EntitySystem
	{
		private var _type:uint;
		private var _filter:EntityFilter;
		private var _entities:Vector.<Entity>;
		private var _entityIndexMap:Dictionary;
		public var enabled:Boolean;
		
		public function EntitySystem(filter:EntityFilter)
		{
			_filter = filter;
			_entities = new Vector.<Entity>();
			_entityIndexMap = new Dictionary();
			enabled = true;
			
			var typeClass:Class = Class(getDefinitionByName(getQualifiedClassName(this)));
			_type = SystemTypeManager.getTypeFor(typeClass).id;
			
			EventManager.addEventListener(EntityEvent.REFRESHED, onEntityRefreshed);
		}	
		
		public function clear():void
		{
			_entities.length = 0;
			_entityIndexMap = new Dictionary();
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
		
		public function onEntityRefreshed(event:Event):void
		{
			if (!enabled)
			{
				return;
			}
			
			var entity:Entity = Entity(event.data);
			
			var contains:Boolean = entity.systemBits.isBitSet(_type);
			var isFiltered:Boolean = _filter.isFiltered(entity);
			
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
			}
		}
		
		protected function removeEntity(entity:Entity):void
		{
			if (_entityIndexMap[entity.id] == null)
			{
				_entityIndexMap[entity.id] = null;
				_entities.splice(_entityIndexMap[entity.id], 1); 
				entity.systemBits.clearBit(_type);
			}
		}
	}
}