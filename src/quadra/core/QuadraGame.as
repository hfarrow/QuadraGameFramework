package quadra.core 
{
	import flash.ui.Keyboard;
	import quadra.input.DirectionalKeyBinding;
	import quadra.input.InputManager;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.text.TextField;
	import starling.events.Event;
	
	public class QuadraGame extends Sprite
	{
		public static var current:QuadraGame;
		public static var inputManager:InputManager;
		
		public var binding:DirectionalKeyBinding;
		
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
		
		public function onEnterFrame(e:EnterFrameEvent):void
		{
			
			
			// input manager must be updated after gameplay so that current and last keyboard states 
			// are swapped at the end of the frame in preperation of the next frame.
			inputManager.update(e.passedTime);
		}
	}
}