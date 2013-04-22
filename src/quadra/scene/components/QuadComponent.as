package quadra.scene.components 
{
	import quadra.scene.Entity;
	import quadra.scene.IEntityComponent;
	import quadra.scene.IDisplayComponent;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	
	public class QuadComponent implements IEntityComponent, IDisplayComponent
	{
		private var _entity:Entity;
		public var quad:Quad;
		
		public function QuadComponent(width:Number, height:Number, color:uint)
		{
			quad = new Quad(width, height, color);
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
		
		/* INTERFACE quadra.scene.components.IDisplayComponent */
		
		public function get displayObject():DisplayObject 
		{
			return quad;
		}
		
	}

}