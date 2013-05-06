package quadra.core 
{
	import flash.utils.getTimer;
	import nape.geom.Vec2;
	import nape.space.Space;
	import nape.util.Debug;
	import nape.util.ShapeDebug;
	import quadra.input.InputManager;
	import quadra.world.EntityWorld;
	import starling.core.Starling;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	public class QuadraSample extends QuadraGame
	{
		
		public static var currentSample:QuadraSample;
		public static var world:EntityWorld;
		
		public function QuadraSample()
		{
			QuadraSample.currentSample = this;
		}
		
		protected override function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			inputManager = new InputManager();
			initEntityWorld();
			init();
		}
		
		private function initEntityWorld():void
		{
			world = new EntityWorld();
		}
		
		protected override function onEnterFrame(e:EnterFrameEvent):void
		{
			world.update(e.passedTime);
			update(e.passedTime);
			
			// input manager must be updated after gameplay so that current and last keyboard states 
			// are swapped at the end of the frame in preperation of the next frame.
			inputManager.update(e.passedTime);
		}
		
		protected override function init():void
		{
			// override this function
		}
		
		protected override function update(elapsedTime:Number):void
		{
			// override this function
		}
	}
}