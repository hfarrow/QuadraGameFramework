package quadra.scene.components 
{
	import quadra.scene.Entity;
	import quadra.scene.IEntityComponent;
	import quadra.scene.IDisplayComponent;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class ImageComponent implements IEntityComponent, IDisplayComponent
	{
		private var _entity:Entity;
		public var image:Image;
		
		public function ImageComponent(texture:Texture)
		{
			image = new Image(texture);
		}
		
		public function init():void
		{
			
		}
		
		public function destroy():void 
		{
			
		}
		
		public function get type():Class 
		{
			return ImageComponent;
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
		
		public function get displayObject():DisplayObject 
		{
			return image;
		}		
	}
}