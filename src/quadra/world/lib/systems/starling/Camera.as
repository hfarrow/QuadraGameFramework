package quadra.world.lib.systems.starling 
{
	import flash.geom.Matrix;
	import nape.geom.Vec2;
	import starling.utils.MatrixUtil;
	/**
	 * ...
	 * @author ...
	 */
	public class Camera 
	{
		private var _position:Vec2;
		private var _offset:Vec2;
		private var _rotation:Number;
		
		private var _transform:Matrix;
		private var _inverseTransform:Matrix;
		private var _dirty:Boolean;
		
		public function Camera(offsetX:Number = 0, offsetY:Number = 0) 
		{
			_position = new Vec2();
			_offset = new Vec2(offsetX, offsetY);
			_rotation = 0;
			_transform = new Matrix();
			_inverseTransform = new Matrix();
			_dirty = true;
		}
		
		public function set x(value:Number):void
		{
			_dirty = true;
			_position.x = value;
		}
		
		public function set y(value:Number):void
		{
			_dirty = true;
			_position.y = value;
		}
		
		public function setxy(x:Number, y:Number):void
		{
			_dirty = true;
			_position.x = x;
			_position.y = y;
		}
		
		public function set offsetX(value:Number):void
		{
			_dirty = true;
			_offset.x = value;
		}
		
		public function set offsetY(value:Number):void
		{
			_dirty = true;
			_offset.y = value;
		}
		
		public function set rotation(value:Number):void
		{
			_dirty = true;
			_rotation = value;
		}
		
		public function get x():Number
		{
			return _position.x;
		}
		
		public function get y():Number
		{
			return _position.y;
		}
		
		public function get offsetX():Number
		{
			return _offset.x;
		}
		
		public function get offsetY():Number
		{
			return _offset.y;
		}
		
		public function get rotation():Number
		{
			return _rotation;
		}
		
		public function get transform():Matrix
		{
			if (_dirty)
			{
				buildTransforms();
			}
			
			return _transform;
		}
		
		public function get inverseTransform():Matrix
		{
			if (_dirty)
			{
				buildTransforms();
			}
			
			return _inverseTransform;
		}
		
		private function buildTransforms():void
		{
			_transform.identity();
			MatrixUtil.prependRotation(_transform, -_rotation * 2 * Math.PI);
			MatrixUtil.prependTranslation(_transform, -_position.x + _offset.x, -_position.y + _offset.y);
			_inverseTransform.copyFrom(_transform);
			_inverseTransform.invert();
			_dirty = false;			
		}
	}

}