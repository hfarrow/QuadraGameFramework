package quadra.core 
{
	import flash.utils.getTimer;
	import nape.geom.Vec2;
	import nape.space.Space;
	import nape.util.Debug;
	import nape.util.ShapeDebug;
	import quadra.input.InputManager;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	public class QuadraSample extends Sprite
	{
		public static var current:QuadraSample;
		public static var inputManager:InputManager;
		public static var isDebuggingPhysics:Boolean = false;
		public static var space:Space;
		public static var physicsDebug:Debug;
		
		private var _prevTimeMS:int;
        private var _simulationTime:Number;
		
		public function QuadraSample()
		{
			QuadraSample.current = this;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			inputManager = new InputManager();
			initPhysics();
		}
		
		protected function initPhysics():void
		{
			space = new Space(Vec2.weak(0, 300));
			physicsDebug = new ShapeDebug(stage.stageWidth, stage.stageHeight, stage.color);
			Starling.current.nativeOverlay.addChild(physicsDebug.display);
			
			// Set up fixed time step logic.
            _prevTimeMS = getTimer();
            _simulationTime = 0.0;
		}	
		
		private function onEnterFrame(e:EnterFrameEvent):void
		{
			updatePhysics(e.passedTime);
			updateDebugPhysics(e.passedTime);
			update(e.passedTime);
			
			// input manager must be updated after gameplay so that current and last keyboard states 
			// are swapped at the end of the frame in preperation of the next frame.
			inputManager.update(e.passedTime);
		}
		
		private function updatePhysics(elapsedTime:Number):void
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
            while (space.elapsedTime < _simulationTime) 
			{
                space.step(1 / Starling.current.nativeStage.frameRate);
            }
		}
		
		private function updateDebugPhysics(elapsedTime:Number):void
		{
			if (isDebuggingPhysics)
			{
				physicsDebug.clear();
				physicsDebug.draw(space);
				physicsDebug.flush();
			}
		}
		
		protected function init():void
		{
			// override this function
		}
		
		protected function update(elapsedTime:Number):void
		{
			// override this function
		}
	}
}