package quadra.scene 
{
	import flash.utils.Dictionary;
	import quadra.scene.IDisplayComponent;
	import starling.display.Sprite;
	public class Entity extends Sprite
	{
		public var manager:SceneManager;
		private var _components:Vector.<IEntityComponent>;
		private var _attributes:Dictionary;
		
		public function Entity(manager:SceneManager)
		{
			this.manager = manager;
			_components = new Vector.<IEntityComponent>();
			_attributes = new Dictionary();
		}
		
		public function init():void
		{
			for each (var component:IEntityComponent in _components)
			{
				component.init();
			}
			
			addDisplayComponents();
		}
		
		// Should only be called from the SceneManager who owns this instance.
		internal function destroy():void 
		{
			removeDisplayComponents();
			removeAllComponents();
		}
		
		private function addDisplayComponents():void
		{			
			for each(var component:IEntityComponent in _components)
			{
				if (component is IDisplayComponent)
				{
					addChild(IDisplayComponent(component).displayObject);
				}
			}
		}
		
		private function removeDisplayComponents():void
		{			
			for each(var component:IEntityComponent in _components)
			{
				if (component is IDisplayComponent)
				{
					IDisplayComponent(component).displayObject.removeFromParent();
				}
			}
		}
		
		// returns the first component of the type specified.
		// use getComponentsOfType to get an array of all components of the type specified.
		public function getComponent(type:Class):IEntityComponent
		{
			for each(var component:IEntityComponent in _components)
			{
				if (component is type)
				{
					return component;
				}
			}
			
			return null;
		}
		
		public function getComponentsOfType(type:Class):Vector.<IEntityComponent>
		{
			var componentsToReturn:Vector.<IEntityComponent> = new Vector.<IEntityComponent>();
			for each (var component:IEntityComponent in _components)
			{
				if (component is type)
				{
					componentsToReturn.push(component);
				}
			}
			
			return componentsToReturn;
		}
		
		public function addComponent(component:IEntityComponent, doInit:Boolean=true):void
		{			
			component.entity = this;
			_components.push(component);
			
			if (doInit)
			{
				component.init();
			}
		}
		
		public function removeComponent(type:Class, componentToRemove:IEntityComponent):void
		{
			var componentIndex:int = _components.indexOf(componentToRemove);
			if (componentIndex != -1)
			{
				if (componentToRemove is IDisplayComponent)
				{
					IDisplayComponent(componentToRemove).displayObject.removeFromParent();
				}
				
				componentToRemove.destroy();
				componentToRemove.entity = null;
				_components.splice(componentIndex, 1);
			}
			else
			{
				throw new Error("A component of the provided type or instance does not exist in this entity.");			
			}
		}
		
		public function removeAllComponents():void
		{
			for each (var component:IEntityComponent in _components)
			{
				if (component is IDisplayComponent)
				{
					IDisplayComponent(component).displayObject.removeFromParent();
				}
				
				component.destroy();
				component.entity = null;
			}
			
			_components.splice(0, _components.length);
		}
		
		public function update(elapsedTime:Number):void
		{
			for each(var component:IEntityComponent in _components)
			{
				component.update(elapsedTime);
			}
		}
		
		// TODO: need to be able to "createNumberAttribute", "createStringAttribute", etc. so that there is less casting	
		public function createAttributeObject(name:String, value:Object, owner:IEntityComponent, isReadOnly:Boolean=false):EntityAttributeObject
		{
			if (_attributes[name] != null)
			{
				throw new Error(owner + "is trying to add an attribute named '" + name + "' that already exists.");
			}
			else
			{
				var attribute:EntityAttributeObject = new EntityAttributeObject(name, value, owner, isReadOnly);
				_attributes[name] = attribute;
				return attribute;
			}
			return null;
		}
		
		public function createAttributeNumber(name:String, value:Number, owner:IEntityComponent, isReadOnly:Boolean=false):EntityAttributeNumber
		{
			if (_attributes[name] != null)
			{
				throw new Error(owner + "is trying to add an attribute named '" + name + "' that already exists.");
			}
			else
			{
				var attribute:EntityAttributeNumber = new EntityAttributeNumber(name, value, owner, isReadOnly);
				_attributes[name] = attribute;
				return attribute;
			}
			return null;
		}
		
		public function createAttributeInt(name:String, value:int, owner:IEntityComponent, isReadOnly:Boolean=false):EntityAttributeInt
		{
			if (_attributes[name] != null)
			{
				throw new Error(owner + "is trying to add an attribute named '" + name + "' that already exists.");
			}
			else
			{
				var attribute:EntityAttributeInt = new EntityAttributeInt(name, value, owner, isReadOnly);
				_attributes[name] = attribute;
				return attribute;
			}
			return null;
		}
		
		public function createAttributeBoolean(name:String, value:Boolean, owner:IEntityComponent, isReadOnly:Boolean=false):EntityAttributeBoolean
		{
			if (_attributes[name] != null)
			{
				throw new Error(owner + "is trying to add an attribute named '" + name + "' that already exists.");
			}
			else
			{
				var attribute:EntityAttributeBoolean = new EntityAttributeBoolean(name, value, owner, isReadOnly);
				_attributes[name] = attribute;
				return attribute;
			}
			return null;
		}
		
		public function addAttribute(attribute:BaseEntityAttribute):void
		{
			if (_attributes[attribute.name] != null)
			{
				throw new Error(attribute.owner + "is trying to add an attribute named '" + name + "' that already exists.");
			}
			else
			{
				_attributes[attribute.name] = attribute;
			}
		}
		
		public function setAttribute(name:String, value:Object):void
		{
			var attribute:* = _attributes[name];
			if (attribute == null)
			{
				throw new Error("Trying to set the value of an attribute named '" + name + "' that does not exist.");
			}
			else
			{
				if (attribute.isReadOnly)
				{
					throw new Error("Trying to set a read-only attribute named '" + name + "'. The owner of this attribute should be able to \
set the value through the EntityAttribute reference returned to the component when createAttribute was called.");
				}
				else
				{
					attribute.value = value;
				}
			}
		}
		
		public function getAttributeObject(name:String):Object
		{
			var attribute:EntityAttributeObject = _attributes[name];
			if (attribute == null)
			{
				throw new Error("Trying to get the value of an attribute named '" + name + "' that does not exists.");
			}
			else
			{
				return attribute.value;
			}
		}
		
		public function getAttributeNumber(name:String):Number
		{
			var attribute:EntityAttributeNumber = _attributes[name];
			if (attribute == null)
			{
				throw new Error("Trying to get the value of an attribute named '" + name + "' that does not exists.");
			}
			else
			{
				return attribute.value;
			}
		}
		
		public function getAttributeInt(name:String):int
		{
			var attribute:EntityAttributeInt = _attributes[name];
			if (attribute == null)
			{
				throw new Error("Trying to get the value of an attribute named '" + name + "' that does not exists.");
			}
			else
			{
				return attribute.value;
			}
		}
		
		public function getAttributeBoolean(name:String):Boolean
		{
			var attribute:EntityAttributeBoolean = _attributes[name];
			if (attribute == null)
			{
				throw new Error("Trying to get the value of an attribute named '" + name + "' that does not exists.");
			}
			else
			{
				return attribute.value;
			}
		}
		
		public function tryGetAttributeObject(name:String, defaultValue:Object = null):Object
		{
			var attribute:EntityAttributeObject = _attributes[name];
			if (attribute == null)
			{
				return defaultValue;
			}
			else
			{
				return attribute.value;
			}
		}
		
		public function tryGetAttributeNumber(name:String, defaultValue:Number = 0):Number
		{
			var attribute:EntityAttributeNumber = _attributes[name];
			if (attribute == null)
			{
				return defaultValue;
			}
			else
			{
				return attribute.value;
			}
		}
		
		public function tryGetAttributeInt(name:String, defaultValue:int = 0):int
		{
			var attribute:EntityAttributeInt = _attributes[name];
			if (attribute == null)
			{
				return defaultValue;
			}
			else
			{
				return attribute.value;
			}
		}
		
		public function tryGetAttributeBoolean(name:String, defaultValue:Boolean = false):Boolean
		{
			var attribute:EntityAttributeBoolean = _attributes[name];
			if (attribute == null)
			{
				return defaultValue;
			}
			else
			{
				return attribute.value;
			}
		}
		
		public function hasAttribute(name:String):Boolean
		{
			return _attributes[name] != null;
		}
		
		public function isAttributeReadOnly(name:String):Boolean
		{
			var attribute:BaseEntityAttribute = _attributes[name];
			if (attribute == null)
			{
				throw new Error("Trying to check the read-only flag of an attribute named '" + name + "' that does not exists.");
			}
			else
			{
				return attribute.isReadOnly;
			}
		}
		
		// The reason you cannot remove an attribute by name is because any object could
		// remove the attribute. Only the owner of an attribute can obtain a reference
		// to the attribute and therefore only the owner could possibly pass the attribute
		// reference into this function.
		public function removeAttribute(attribute:BaseEntityAttribute):Boolean
		{
			if (_attributes[attribute.name] != null)
			{
				_attributes[attribute.name] = null;
				return true;
			}
			
			return false;
		}
	}
}