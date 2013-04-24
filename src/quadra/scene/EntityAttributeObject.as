package quadra.scene
{
	public class EntityAttributeObject extends BaseEntityAttribute
	{
		private var _value:Object;
		
		public function EntityAttributeObject(name:String, value:Object, owner:IEntityComponent, isReadOnly:Boolean=false)
		{
			super(name, owner, isReadOnly);
			_value = value;
		}
		
		public function get value():Object
		{
			return _value;
		}
		
		public function set value(v:Object):void
		{
			_value = v;
			changed.dispatch();
		}
	}
}