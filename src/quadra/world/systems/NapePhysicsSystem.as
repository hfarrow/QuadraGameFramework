package quadra.world.systems
{
	import flash.utils.getTimer;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.space.Space;
	import nape.util.Debug;
	import nape.util.ShapeDebug;
	import quadra.core.QuadraGame;
	import quadra.world.components.NapePhysicsComponent;
	import quadra.world.components.SpatialComponent;
	import quadra.world.components.VelocityComponent;
	import quadra.world.Entity;
	import quadra.world.events.EntityEvent;
	import starling.core.Starling;

	public class NapePhysicsSystem extends EntitySystem
	{
		private var _isDebuggingPhysics:Boolean = true;
		private var _space:Space;
		private var _physicsDebug:Debug;
		
		private var _bodies:Vector.<Body>;
		
		private var _prevTimeMS:int;
        private var _simulationTime:Number;
		
		public function NapePhysicsSystem(debug:Boolean=false)
		{
			super(EntityFilter.all([SpatialComponent, VelocityComponent, NapePhysicsComponent]));	
			
			_isDebuggingPhysics = debug;
			_bodies = new Vector.<Body>();
			
			init();
		}
		
		private function init():void
		{
			_space = new Space(Vec2.weak(0, 0));
			_physicsDebug = new ShapeDebug(QuadraGame.current.stage.stageWidth, QuadraGame.current.stage.stageHeight, QuadraGame.current.stage.color);
			Starling.current.nativeOverlay.addChild(_physicsDebug.display);
			
			// Set up fixed time step logic.
            _prevTimeMS = getTimer();
            _simulationTime = 0.0;
		}
		
		protected override function onEntityAdded(entity:Entity):void 
		{			
			entity.dispatchEventWith(EntityEvent.CHANGE_PHYSICS_SPACE, _space);
		}
		
		protected override function onEntityRemoved(entity:Entity):void
		{
			entity.dispatchEventWith(EntityEvent.CHANGE_PHYSICS_SPACE, null);
		}
		
		protected override function processEntities(entities:Vector.<Entity>, elaspedTime:Number):void
		{
			for (var i:int = 0; i < entities.length; ++i)
			{
				var entity:Entity = entities[i];
				var physics:NapePhysicsComponent = NapePhysicsComponent(entity.getComponent(NapePhysicsComponent));
				entity.dispatchEventWith(EntityEvent.CHANGE_POSITION, physics.body.position);
				entity.dispatchEventWith(EntityEvent.CHANGE_VELOCITY, physics.body.velocity);
				entity.dispatchEventWith(EntityEvent.CHANGE_ROTATION, physics.body.rotation);
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
			if (_isDebuggingPhysics)
			{
				_physicsDebug.clear();
				_physicsDebug.draw(_space);
				_physicsDebug.flush();
			}
		}
	}
}