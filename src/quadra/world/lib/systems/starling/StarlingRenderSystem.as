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
	import starling.textures.RenderTexture;
	import starling.utils.RectangleUtil;

	public class StarlingRenderSystem extends EntitySystem
	{
		private var _root:DisplayObjectContainer;
		private var _layers:RenderLayerManager;
		private var _renderTargetManager:RenderTargetManager;
		
		public function StarlingRenderSystem(root:DisplayObjectContainer)
		{
			super(EntityFilter.all([StarlingDisplayComponent]));
			_root = root;
			_layers = new RenderLayerManager(_root);
			_renderTargetManager = new RenderTargetManager();
		}
		
		public override function init():void
		{
			var defaultLayer:Sprite = new Sprite();
			_layers.addRenderLayer("default", -1);
		}
		
		public function addRenderTarget(name:String, renderTexture:RenderTexture):void
		{
			_renderTargetManager.addRenderTarget(name, renderTexture);
		}
		
		public function removeRenderTarget(name:String, dispose:Boolean):void
		{
			_renderTargetManager.removeRenderTarget(name, dispose);
		}
		
		public function getRenderTargetTexture(name:String):RenderTexture
		{
			return _renderTargetManager.getRenderTargetTexture(name);
		}
		
		protected override function onEntityAdded(entity:Entity):void 
		{			
			var display:StarlingDisplayComponent = StarlingDisplayComponent(entity.getComponent(StarlingDisplayComponent));
			var spatial:SpatialComponent = entity.getComponent(SpatialComponent) as SpatialComponent;
			
			if (display.renderTargetName != null)
			{
				addEntityToRenderTarget(display);
			}
			else
			{
				addEntityToRoot(display);
			}
			
			if (spatial != null)
			{
				display.displayObject.x = spatial.x;
				display.displayObject.y = spatial.y;
				display.displayObject.rotation = spatial.rotation;
			}
			display.renderTargetChanged.add(onEntityRenderTargetChanged);
		}
		
		private function addEntityToRoot(display:StarlingDisplayComponent):void
		{
			_layers.addToLayer(display, display.layer);
		}
		
		private function addEntityToRenderTarget(display:StarlingDisplayComponent):void
		{
			if (!_renderTargetManager.doesRenderTargetExist(display.renderTargetName))
			{
				_renderTargetManager.addRenderTarget(display.renderTargetName, new RenderTexture(_root.stage.stageWidth, _root.stage.stageHeight));
			}
			
			var layers:RenderLayerManager = _renderTargetManager.getRenderTargetLayers(display.renderTargetName);			
			layers.addToLayer(display, display.layer);
		}
		
		private function removeEntityFromRoot(display:StarlingDisplayComponent):void
		{
			display.displayObject.removeFromParent();
		}
		
		private function removeEntityFromRenderTarget(display:StarlingDisplayComponent, renderTargetName:String):void
		{
			display.displayObject.removeFromParent();
		}
		
		private function onEntityRenderTargetChanged(display:StarlingDisplayComponent, oldRenderTargetName:String):void
		{
			if (oldRenderTargetName == null)
			{
				removeEntityFromRoot(display);
				addEntityToRenderTarget(display);
			}
			else
			{
				removeEntityFromRenderTarget(display, oldRenderTargetName);
				addEntityToRoot(display);				
			}
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
				var spatial:SpatialComponent = entity.getComponent(SpatialComponent) as SpatialComponent;
				
				if (spatial != null)
				{
					display.displayObject.x = spatial.x;
					display.displayObject.y = spatial.y;
					display.displayObject.rotation = spatial.rotation;
				}
				
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
			
			_renderTargetManager.render();
		}
	}
}