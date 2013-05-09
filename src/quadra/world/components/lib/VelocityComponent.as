package quadra.world.components.lib
{
	import nape.geom.Vec2;
	import quadra.world.IEntityComponent;
	

	public class VelocityComponent implements IEntityComponent
	{
		public var velocity:Vec2;
		
		public function VelocityComponent(velocity:Vec2 = null)
		{
			if (velocity == null)
			{
				velocity = new Vec2(0, 0);
			}
			this.velocity = velocity;
		}
	}
}