package quadra.world.lib.systems.starling 
{
	import flash.utils.Dictionary;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.RenderTexture;
	/**
	 * ...
	 * @author ...
	 */
	public class RenderTarget 
	{
		public var name:String;
		public var renderTexture:RenderTexture;
		public var root:Sprite;
		public var layers:RenderLayerManager;
		public var outputImage:Image;
		public var applyCameraToInput:Boolean;
		public var applyCameraToOutput:Boolean;
		
		public function RenderTarget(name:String, renderTexture:RenderTexture, applyCameraToInput:Boolean = false, applyCameraToOutput:Boolean = false)
		{
			this.name = name;
			this.renderTexture = renderTexture;
			this.applyCameraToInput = applyCameraToInput;
			this.applyCameraToOutput = applyCameraToOutput;
			root = new Sprite();
			layers = new RenderLayerManager(root);
			outputImage = new Image(renderTexture);
		}
		
		public function dispose():void
		{
			root.dispose();
			renderTexture.dispose();
			outputImage.removeFromParent();
			outputImage.dispose();
		}
	}

}