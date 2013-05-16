package quadra.world.lib.components
{
	import quadra.world.IEntityComponent;
	

	public class SpatialComponent implements IEntityComponent
	{
		public var x:Number;
		public var y:Number;
		public var rotation:Number;
		
		public function SpatialComponent(x:Number = 0, y:Number = 0, rotation:Number = 0)
		{
			this.x = x;
			this.y = y;
			this.rotation = rotation;
		}
	}
}