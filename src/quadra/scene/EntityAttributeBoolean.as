package quadra.scene
{
	public class EntityAttributeBoolean extends BaseEntityAttribute
	{
		private var _value:Boolean;
		
		public function EntityAttributeBoolean(name:String, value:Boolean, owner:IEntityComponent, isReadOnly:Boolean=false)
		{
			super(name, owner, isReadOnly);
			_value = value;
		}
		
		public function get value():Boolean
		{
			return _value;
		}
		
		public function set value(v:Boolean):void
		{
			_value = v;
			changed.dispatch();
		}
	}
}