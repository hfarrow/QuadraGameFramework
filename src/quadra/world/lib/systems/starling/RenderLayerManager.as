package quadra.world.lib.systems.starling 
{
	import flash.utils.Dictionary;
	import quadra.world.lib.components.StarlingDisplayComponent;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class RenderLayerManager 
	{
		private var _layers:Dictionary;
		private var _root:DisplayObjectContainer;
		
		public function RenderLayerManager(root:DisplayObjectContainer) 
		{
			_layers = new Dictionary();
			_root = root;
		}
		
		public function addRenderLayer(name:String, layer:int):void
		{			
			if (_layers[layer] != null)
			{
				throw new Error("A layer named '" + _layers[layer].name + "' at index " + layer + " already exists.");
			}
			
			var layerSprite:Sprite = new Sprite();
			_layers[layer] = new RenderLayer(name, layer, layerSprite);			
			
			for (var i:int = 0; i <= _root.numChildren; ++i)
			{
				if (i == _root.numChildren)
				{
					layerSprite.name = i.toString();
					_root.addChild(layerSprite);
					break;
				}
				
				var child:DisplayObject = _root.getChildAt(i);
				var childLayer:int = int(child.name);
				if (childLayer > int(layer))
				{
					layerSprite.name = i.toString();
					_root.addChildAt(layerSprite, i);
					break;
				}
			}
		}
		
		public function addToLayer(display:DisplayObject, layer:int):void
		{
			if (_layers[layer] == null)
			{
				addRenderLayer("auto_" + layer, layer);
			}
			
			_layers[layer].root.addChild(display);
		}
	}

}