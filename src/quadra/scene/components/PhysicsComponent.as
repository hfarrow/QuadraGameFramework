package quadra.scene.components
{
	import quadra.scene.Entity;
	import quadra.scene.EntityAttributeObject;
	import quadra.scene.IEntityComponent;
	import nape.phys.Body;
	
	public class PhysicsComponent implements IEntityComponent
	{
		private var _entity:Entity;
		private var _body:Body
		
		public function PhysicsComponent(body:Body)
		{
			_body = body;
		}
		
		public function init():void 
		{
			_entity.createAttributeObject("physicsBody", _body, this);
		}
		
		public function destroy():void 
		{
			_body.space = null;
			_body = null;
			_entity.setAttribute("physicsBody", null);
		}
		
		public function get type():Class 
		{
			return PhysicsComponent;
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
			_entity.x = _body.position.x;
			_entity.y = _body.position.y;
			_entity.rotation = _body.rotation;
		}
	}
}