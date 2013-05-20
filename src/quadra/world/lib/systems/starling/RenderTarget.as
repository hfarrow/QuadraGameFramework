package quadra.world.lib.systems.starling 
{
	import flash.utils.Dictionary;
	import starling.display.DisplayObject;
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
		
		public function RenderTarget(name:String, renderTexture:RenderTexture)
		{
			this.name = name;
			this.renderTexture = renderTexture;
			root = new Sprite();
			layers = new RenderLayerManager(root);
		}
		
		public function dispose():void
		{
			root.dispose();
			renderTexture.dispose();
		}
	}

}