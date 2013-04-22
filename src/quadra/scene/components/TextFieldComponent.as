package quadra.scene.components 
{
	import quadra.scene.Entity;
	import quadra.scene.IDisplayComponent;
	import quadra.scene.IEntityComponent;
	import starling.display.DisplayObject;
	import starling.text.TextField;
	
	public class TextFieldComponent implements IEntityComponent, IDisplayComponent 
	{
		private var _entity:Entity;
		public var textField:TextField;
		
		public function TextFieldComponent(width:Number, height:Number, text:String = "", font:String = "Verdana",
											fontSize:Number = 10, color:uint=0x0, bold:Boolean=false) 
		{
			textField = new TextField(width, height, text, font, fontSize, color, bold);
		}
		
		/* INTERFACE quadra.scene.IDisplayComponent */
			
		public function get displayObject():DisplayObject 
		{
			return textField;
		}
		
		/* INTERFACE quadra.scene.IEntityComponent */
		
		public function init():void 
		{
			
		}
		
		public function destroy():void 
		{
			
		}
		
		public function get type():Class 
		{
			return IDisplayComponent;
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
			
		}
		
	}

}