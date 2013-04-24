package quadra.scene
{
	public class EntityAttributeInt extends BaseEntityAttribute
	{
		private var _value:int;
		
		public function EntityAttributeInt(name:String, value:int, owner:IEntityComponent, isReadOnly:Boolean=false)
		{
			super(name, owner, isReadOnly);
			_value = value;
		}
		
		public function get value():int
		{
			return _value;
		}
		
		public function set value(v:int):void
		{
			_value = v;
			changed.dispatch();
		}
	}
}