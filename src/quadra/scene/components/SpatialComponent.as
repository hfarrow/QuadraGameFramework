package quadra.scene.components
{
	import quadra.scene.Entity;
	import quadra.scene.EntityAttribute;
	import quadra.scene.IEntityComponent;	

	public class SpatialComponent implements IEntityComponent
	{
		private var _entity:Entity;
		private var _x:EntityAttribute;
		private var _y:EntityAttribute;
		private var _rotation:EntityAttribute;
		
		public var lockedRotation:Boolean = false;
		
		public function SpatialComponent()
		{
			
		}
		
		/* INTERFACE quadra.scene.IEntityComponent */
		
		public function init():void 
		{
			_x = _entity.createAttribute("x", 0, this);
			_y = _entity.createAttribute("y", 0, this);
			_rotation = _entity.createAttribute("rotation", 0, this);
		}
		
		public function destroy():void 
		{
			
		}
		
		public function get type():Class 
		{
			return SpatialComponent;
		}
		
		public function get entity():Entity 
		{
			return _entity;
		}
		
		public function set entity(value:Entity):void 
		{
			_entity = value;
		}
		
		public function update(elapsedTime:Number):void 
		{
			_entity.x = Number(_x.value);
			_entity.y = Number(_y.value);
			
			if (!lockedRotation)
			{
				_entity.rotation = Number(_rotation.value);
			}
		}
	}
}