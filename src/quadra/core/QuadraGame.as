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
	
	public class QuadraGame extends Sprite
	{
		public static var current:QuadraGame;
		public static var inputManager:InputManager;
		
		public function QuadraGame()
		{
			QuadraGame.current = this;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			inputManager = new InputManager();
		}
			
		private function onEnterFrame(e:EnterFrameEvent):void
		{
			update(e.passedTime);
			
			// input manager must be updated after gameplay so that current and last keyboard states 
			// are swapped at the end of the frame in preperation of the next frame.
			inputManager.update(e.passedTime);
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