package quadra.world.lib.systems.starling 
{
	import flash.utils.Dictionary;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.textures.RenderTexture;
	/**
	 * ...
	 * @author ...
	 */
	public class RenderTargetManager 
	{
		private var _renderTargets:Dictionary;
		
		public function RenderTargetManager() 
		{
			_renderTargets = new Dictionary();
		}
		
		public function addRenderTarget(name:String, renderTexture:RenderTexture):void
		{
			if (_renderTargets[name] == null && renderTexture != null)
			{
				_renderTargets[name] = new RenderTarget(name, renderTexture);
			}
		}
		
		public function removeRenderTarget(name:String, dispose:Boolean):void
		{
			if (_renderTargets[name] != null)
			{
				if (dispose)
				{
					_renderTargets[name].dispose();
				}
				_renderTargets[name] = null;
			}
		}
		
		public function getRenderTargetTexture(name:String):RenderTexture
		{
			return _renderTargets[name].renderTexture;
		}
		
		public function getRenderTargetRoot(name:String):Sprite
		{
			return _renderTargets[name].root;
		}
		
		public function getRenderTargetLayers(name:String):RenderLayerManager
		{
			return _renderTargets[name].layers;
		}
		
		public function addRenderTargetLayer(name:String, layerName:String, layer:int):void
		{
			_renderTargets[name].addRenderLayer(layerName, layer);
		}
		
		public function doesRenderTargetExist(name:String):Boolean
		{
			return _renderTargets[name] != null;
		}
		
		public function render():void
		{
			for each(var renderTarget:RenderTarget in _renderTargets)
			{
				renderTarget.renderTexture.draw(renderTarget.root);
			}
		}
	}

}