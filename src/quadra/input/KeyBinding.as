package quadra.input 
{
	import quadra.core.QuadraGame;
	public class KeyBinding 
	{
		private var _keyCode:int;
		
		public function KeyBinding(keyCode:int)
		{
			_keyCode = keyCode;
		}
		
		public function set buttonId(keyCode:int):void
		{
			_keyCode = keyCode;
		}
		
		public function get buttonId():int
		{
			return _keyCode;
		}
		
		public function isButtonPressed():Boolean
		{
			return QuadraGame.inputManager.isKeyDown(_keyCode);
		}
		
		public function isButtonJustPressed():Boolean
		{
			return QuadraGame.inputManager.isKeyJustPressed(_keyCode);
		}
		
		public function isButtonJustReleased():Boolean
		{
			return QuadraGame.inputManager.isKeyJustReleased(_keyCode);
		}
	}
}