package quadra.world 
{
	public interface IEntityComponent 
	{
		function init(entity:Entity):void;
		function shutdown():void;
	}
}