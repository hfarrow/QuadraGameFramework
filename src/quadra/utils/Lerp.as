package quadra.utils
{

	public class Lerp
	{
		public static function number(min:Number, max:Number, t:Number):Number
		{
			return (max - min) * t + min;
		}
		
		public static function color(min:uint, max:uint, t:Number):uint
		{
			var minRed:Number = (0xff0000 & min) >> 16;
			var minGreen:Number = (0xff00 & min) >> 8;
			var minBlue:Number = (0xff & min);
			
			var maxRed:Number = (0xff0000 & max) >> 16;
			var maxGreen:Number = (0xff00 & max) >> 8;
			var maxBlue:Number = (0xff & max);
			
			var color:Number = 0;
			color |= Lerp.number(minRed, maxRed, t) << 16;
			color |= Lerp.number(minGreen, maxGreen, t) << 8;
			color |= Lerp.number(minBlue, maxBlue, t);
			return color;
		}
	}
}