package quadra.world.lib.systems
{
	import flash.utils.getTimer;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.space.Space;
	import nape.util.Debug;
	import nape.util.ShapeDebug;
	import quadra.core.QuadraGame;
	import quadra.world.lib.components.NapePhysicsComponent;
	import quadra.world.lib.components.SpatialComponent;
	import quadra.world.lib.components.VelocityComponent;
	import quadra.world.Entity;
	import quadra.world.EntityFilter;
	import quadra.world.events.EntityEvent;
	import quadra.world.lib.systems.starling.Camera;
	import quadra.world.lib.systems.starling.StarlingRenderSystem;
	import quadra.world.systems.EntitySystem;
	import starling.core.Starling;

	public class NapePhysicsSystem extends EntitySystem
	{
		private var _isDebuggingPhysics:Boolean = true;
		private var _space:Space;
		private var _gravity:Vec2;
		private var _physicsDebug:Debug;
		
		private var _bodies:Vector.<Body>;
		
		private var _prevTimeMS:int;
        private var _simulationTime:Number;
		
		public function NapePhysicsSystem(debug:Boolean = false, gravity:Vec2 = null)
		{
			super(EntityFilter.all([SpatialComponent, VelocityComponent, NapePhysicsComponent]));	
			
			_isDebuggingPhysics = debug;
			if (gravity == null)
			{
				gravity = new Vec2(0, 0);
			}
			_gravity = gravity;
			_bodies = new Vector.<Body>();
		}
		
		public override function init():void
		{
			_space = new Space(_gravity);
			_physicsDebug = new ShapeDebug(QuadraGame.current.stage.stageWidth, QuadraGame.current.stage.stageHeight, QuadraGame.current.stage.color);
			Starling.current.nativeOverlay.addChild(_physicsDebug.display);
			
			// Set up fixed time step logic.
            _prevTimeMS = getTimer();
            _simulationTime = 0.0;
		}
		
		public function get space():Space
		{
			return _space;
		}
		
		protected override function onEntityAdded(entity:Entity):void 
		{			
			var physics:NapePhysicsComponent = NapePhysicsComponent(entity.getComponent(NapePhysicsComponent));
			var spatial:SpatialComponent = SpatialComponent(entity.getComponent(SpatialComponent));
			var velocity:VelocityComponent = VelocityComponent(entity.getComponent(VelocityComponent));
			physics.body.space = _space;	
			physics.body.userData.entity = entity;
			
			spatial.x = physics.body.position.x;
			spatial.y = physics.body.position.y;
			spatial.rotation = physics.body.rotation;
			velocity.velocity = physics.body.velocity;
		}
		
		protected override function onEntityRemoved(entity:Entity):void
		{
			var physics:NapePhysicsComponent = NapePhysicsComponent(entity.getComponent(NapePhysicsComponent));
			physics.body.space = null;
			physics.body.userData.entity = null;
		}
		
		protected override function processEntities(entities:Vector.<Entity>, elaspedTime:Number):void
		{
			for (var i:int = 0; i < entities.length; ++i)
			{
				var entity:Entity = entities[i];
				var physics:NapePhysicsComponent = NapePhysicsComponent(entity.getComponent(NapePhysicsComponent));
				var velocity:VelocityComponent = VelocityComponent(entity.getComponent(VelocityComponent));
				var spatial:SpatialComponent = SpatialComponent(entity.getComponent(SpatialComponent));
				var body:Body = physics.body;
				
				spatial.x = body.position.x;
				spatial.y = body.position.y;
				spatial.rotation = body.rotation;
				velocity.velocity = body.velocity;
			}
		}
		
		public override function update(elapsedTime:Number):void
		{
			updateSpace(elapsedTime);
			updateDebugPhysics(elapsedTime);
			
			super.update(elapsedTime);
		}
		
		private function updateSpace(elapsedTime:Number):void
		{
			var curTimeMS:uint = getTimer();
            if (curTimeMS == _prevTimeMS) 
			{
                // No time has passed!
                return;
            }

            _prevTimeMS = curTimeMS;
            _simulationTime += elapsedTime;

            // Keep on stepping forward by fixed time step until amount of time
            // needed has been simulated.
            while (_space.elapsedTime < _simulationTime) 
			{
                _space.step(1 / Starling.current.nativeStage.frameRate);
            }
		}
		
		private function updateDebugPhysics(elapsedTime:Number):void
		{
			var camera:Camera = StarlingRenderSystem(world.systemManager.getSystem(StarlingRenderSystem)).camera;
			_physicsDebug.display.x = -camera.x + camera.offsetX;
			_physicsDebug.display.y = -camera.y + camera.offsetY;
			_physicsDebug.display.rotation = -camera.rotation;
			if (_isDebuggingPhysics)
			{
				_physicsDebug.clear();
				_physicsDebug.draw(_space);
				_physicsDebug.flush();
			}
		}
	}
}