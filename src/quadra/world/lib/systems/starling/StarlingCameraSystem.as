package quadra.world.lib.systems.starling 
{
	import quadra.world.Entity;
	import quadra.world.EntityFilter;
	import quadra.world.lib.components.SpatialComponent;
	import quadra.world.lib.components.StarlingCameraComponent;
	import quadra.world.systems.EntitySystem;
	import starling.display.DisplayObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class StarlingCameraSystem extends EntitySystem 
	{
		private var _renderSystem:StarlingRenderSystem;
		private var _offsetX:Number;
		private var _offsetY:Number;
		
		public function StarlingCameraSystem(offsetX:Number = 0, offsetY:Number = 0) 
		{
			super(EntityFilter.all([StarlingCameraComponent, SpatialComponent]));
			
			_offsetX = offsetX;
			_offsetY = offsetY;
		}
		
		public override function init():void
		{
			_renderSystem = StarlingRenderSystem(world.systemManager.getSystem(StarlingRenderSystem));
			_renderSystem.camera.offsetX = _offsetX;
			_renderSystem.camera.offsetY = _offsetY;
		}
		
		protected override function processEntities(entities:Vector.<Entity>, elaspedTime:Number):void
		{
			if (entities.length > 1)
			{
				throw new Error("Quada only supports one camera entity being added to the world.");
			}
			
			if (entities.length == 0)
			{
				return;
			}
			
			//var camera:StarlingCameraComponent = StarlingCameraComponent(entities[0].getComponent(StarlingCameraComponent));
			var spatial:SpatialComponent = SpatialComponent(entities[0].getComponent(SpatialComponent));
			_renderSystem.camera.setxy(spatial.x, spatial.y);
			_renderSystem.camera.rotation = spatial.rotation;
		}
	}

}