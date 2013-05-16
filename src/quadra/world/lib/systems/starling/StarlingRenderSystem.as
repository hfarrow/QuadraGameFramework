package quadra.world.lib.systems.starling
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import quadra.world.lib.components.SpatialComponent;
	import quadra.world.Entity;
	import quadra.world.EntityFilter;
	import quadra.world.lib.components.StarlingDisplayComponent;
	import quadra.world.systems.EntitySystem;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.utils.RectangleUtil;

	public class StarlingRenderSystem extends EntitySystem
	{
		private var _container:DisplayObjectContainer;
		private var _layers:Dictionary;
		
		public function StarlingRenderSystem(container:DisplayObjectContainer)
		{
			super(EntityFilter.all([SpatialComponent, StarlingDisplayComponent]));
			_container = container;
			_layers = new Dictionary();
		}
		
		public override function init():void
		{
			var defaultLayer:Sprite = new Sprite();
			addRenderLayer("default", -1);
		}
		
		public function addRenderLayer(name:String, layer:int):void
		{
			if (_layers[layer] != null)
			{
				throw new Error("A layer named '" + _layers[layer].name + "' at index " + layer + " already exists.");
			}
			
			var layerSprite:Sprite = new Sprite();
			_layers[layer] = new RenderLayer(name, layer, layerSprite);			
			
			for (var i:int = 0; i <= _container.numChildren; ++i)
			{
				if (i == _container.numChildren)
				{
					layerSprite.name = i.toString();
					_container.addChild(layerSprite);
					break;
				}
				
				var child:DisplayObject = _container.getChildAt(i);
				var childLayer:int = int(child.name);
				if (childLayer > int(layer))
				{
					layerSprite.name = i.toString();
					_container.addChildAt(layerSprite, i);
					break;
				}
			}
		}
		
		protected override function onEntityAdded(entity:Entity):void 
		{			
			var display:StarlingDisplayComponent = StarlingDisplayComponent(entity.getComponent(StarlingDisplayComponent));
			var spatial:SpatialComponent = SpatialComponent(entity.getComponent(SpatialComponent));
			
			if (_layers[display.layer] == null)
			{
				addRenderLayer("auto_" + display.layer, display.layer);
			}
			
			_layers[display.layer].container.addChild(display.displayObject);
			display.displayObject.x = spatial.x;
			display.displayObject.y = spatial.y;
			display.displayObject.rotation = spatial.rotation;
		}
		
		protected override function onEntityRemoved(entity:Entity):void
		{
			var display:StarlingDisplayComponent = StarlingDisplayComponent(entity.getComponent(StarlingDisplayComponent));
			display.displayObject.removeFromParent();
		}
		
		protected override function processEntities(entities:Vector.<Entity>, elaspedTime:Number):void
		{
			// helper for recentering entities.
			var rect:Rectangle = new Rectangle();
			
			for (var i:int = 0; i < entities.length; ++i)
			{
				var entity:Entity = entities[i];
				var display:StarlingDisplayComponent = StarlingDisplayComponent(entity.getComponent(StarlingDisplayComponent));
				var spatial:SpatialComponent = SpatialComponent(entity.getComponent(SpatialComponent));
				display.displayObject.x = spatial.x;
				display.displayObject.y = spatial.y;
				display.displayObject.rotation = spatial.rotation;
				
				if (display.autoCenter)
				{
					//display.displayObject.pivotX = display.displayObject.width / 2;
					//display.displayObject.pivotY = display.displayObject.height / 2;
					
					var displayObject:DisplayObject = display.displayObject;
					
					displayObject.getBounds(displayObject, rect);
					displayObject.pivotX = rect.width / 2;
					displayObject.pivotY = rect.height / 2;
				}
			}
		}
		
		public override function update(elapsedTime:Number):void
		{			
			super.update(elapsedTime);
		}
	}
}