package quadra.scene
{
	public class EntityAttributeNumber extends BaseEntityAttribute
	{
		private var _value:Number;
		
		public function EntityAttributeNumber(name:String, value:Number, owner:IEntityComponent, isReadOnly:Boolean=false)
		{
			super(name, owner, isReadOnly);
			_value = value;
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(v:Number):void
		{
			_value = v;
			changed.dispatch();
		}
	}
}