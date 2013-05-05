package quadra.utils
{
	import flash.filters.BitmapFilter;
	import flash.utils.ByteArray;
	public class BitField
	{
		private static const BYTE_SIZE:uint = 8;
		private static const _sHelper:BitField = new BitField();
		
		private var _bytes:Vector.<int>;
		
		public function BitField()
		{
			_bytes = new Vector.<int>();
			clearAllBits();
		}
		
		public function set length(numBytes:uint):void
		{
			// truncate if numBytes is less than current length.
			if (_bytes.length > numBytes)
			{
				_bytes.length = numBytes;
			}
			
			// Expand if current length is less than numBytes
			while (_bytes.length < numBytes)
			{
				_bytes.push(0);
			}			
		}
		
		public function get length():uint
		{
			return _bytes.length;
		}
		
		public function setBit(bitIndex:uint):void
		{
			var byteIndex:uint = bitIndex / BYTE_SIZE;
			if (_bytes.length < byteIndex + 1)
			{
				var i:int = _bytes.length;
				while (i <= byteIndex)
				{
					_bytes.push(0);
					++i;
				}
			}
			
			_bytes[byteIndex] |= 1 << bitIndex;
		}
		
		public function clearBit(bitIndex:uint):void
		{
			var byteIndex:uint = bitIndex / BYTE_SIZE;
			if (byteIndex <= _bytes.length - 1)
			{
				_bytes[byteIndex] &= ~(1 << bitIndex);
			}
		}
		
		public function isBitSet(bitIndex:uint):Boolean
		{
			var byteIndex:uint = bitIndex / BYTE_SIZE;
			if (byteIndex <= _bytes.length - 1)
			{
				return (_bytes[byteIndex] & (1 << bitIndex)) != 0;
			}
			
			return false;
		}
		
		public function clearAllBits():void
		{
			_bytes.length = 0;
			_bytes.push(0);
		}
		
		public function isEmpty():Boolean
		{
			for (var i:int = 0; i < _bytes.length; ++i)
			{
				if (_bytes[i] != 0)
				{
					return false;
				}
			}
			return true;
		}
		
		public function and(other:BitField, out:BitField):void
		{
			out.length = uint(Math.max(other.length, this.length));
			out.clearAllBits();
			for (var i:int = 0; i < out.length; ++i)
			{
				if (i < other.length && i < this.length)
				{
					out._bytes[i] = _bytes[i] & other._bytes[i];
				}
				else
				{
					out._bytes[i] = 0;
				}
			}
		}
		
		public function or(other:BitField, out:BitField):void
		{
			out.length = uint(Math.max(other.length, this.length));
			for (var i:int = 0; i < out.length; ++i)
			{
				if (i < other.length && i < this.length)
				{
					out._bytes[i] = _bytes[i] | other._bytes[i];
				}
				else if (i < other.length)
				{
					out._bytes[i] = _bytes[i];
				}
				else
				{
					out._bytes[i] = other._bytes[i];
				}
			}
		}
		
		public function equals(other:BitField):Boolean
		{
			var maxLength:uint = uint(Math.max(other.length, this.length));
			for (var i:int = 0; i < maxLength; ++i)
			{
				if (i < other.length && i < this.length)
				{
					if (_bytes[i] != other._bytes[i])
					{
						return false;
					}
				}
				else if (i < other.length)
				{
					if (_bytes[i] != 0)
					{
						return false;
					}
				}
				else
				{
					if (other._bytes[i] != 0)
					{
						return false;
					}
				}
			}
			
			return true;
		}
		
		// Both bit fields have at least one of the same bits set
		public function intersects(other:BitField):Boolean
		{
			this.and(other, _sHelper);			
			return !_sHelper.isEmpty();
		}		
		
		// other contains all of the values in this
		public function contains(other:BitField):Boolean
		{
			this.and(other, _sHelper);			
			return _sHelper.equals(this);
		}
	}
}