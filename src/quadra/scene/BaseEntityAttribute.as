package quadra.scene
{
	import org.osflash.signals.Signal;
	public class BaseEntityAttribute
	{
		private var _name:String;
		private var _owner:IEntityComponent;
		private var _isReadOnly:Boolean;
		
		public var changed:Signal;
		
		public function BaseEntityAttribute(name:String, owner:IEntityComponent, isReadOnly:Boolean=false)
		{
			_name = name;
			_owner = owner;
			_isReadOnly = isReadOnly;
			
			changed = new Signal();
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get owner():IEntityComponent 
		{
			return _owner;
		}
		
		public function get isReadOnly():Boolean 
		{
			return _isReadOnly;
		}
	}
}