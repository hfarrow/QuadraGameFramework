package quadra.scene 
{	
	import starling.display.DisplayObjectContainer;
	import starling.display.DisplayObject;
	
	public class SceneManager 
	{
		private var _root:DisplayObjectContainer;
		private var _entities:Vector.<Entity>;
		
		public function SceneManager(root:DisplayObjectContainer) 
		{
			_root = root;
			_entities = new Vector.<Entity>();
		}
		
		public function createEntity(components:Array):Entity
		{
			var entity:Entity = new Entity(this);
			_entities.push(entity);
			
			for (var i:int = 0; i < components.length; ++i)
			{
				entity.addComponent(components[i], false);
			}
			
			_root.addChild(entity);
			entity.init();
			_root.dispatchEventWith(SceneEvent.ENTITY_CREATED, false, entity);
			return entity;
		}
		
		public function destroyEntity(entity:Entity):void
		{
			_root.dispatchEventWith(SceneEvent.DESTROYING_ENTITY, false, entity);
			_root.removeChild(entity);
			entity.destroy();
			entity.manager = null;
			_root.dispatchEventWith(SceneEvent.ENTITY_DESTROYED, false, entity);
		}
		
		public function update(elapsedTime:Number):void
		{
			for each(var entity:Entity in _entities)
			{
				entity.update(elapsedTime);
			}
		}
	}

}