package quadra.world.lib.components
{
	import nape.geom.Vec2;
	import nape.phys.Body;
	import quadra.world.IEntityComponent;

	public class NapePhysicsComponent implements IEntityComponent
	{
		public var body:Body;
		
		public function NapePhysicsComponent(body:Body)
		{
			this.body = body;
		}
	}
}