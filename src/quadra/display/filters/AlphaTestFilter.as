package quadra.display.filters
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import starling.filters.FragmentFilter;
	import starling.filters.FragmentFilterMode;
	import starling.utils.VertexData;
 
	import starling.textures.Texture;
 
	public class AlphaTestFilter extends FragmentFilter
	{
		private var mVars:Vector.<Number> = new <Number>[.8,0,0,0]; // x is used as an alpha threshold for kil
		private var mColor:Vector.<Number> = new <Number>[0,0,1,0];
		private var mShaderProgram:Program3D;
 
		public function AlphaTestFilter()
		{
			mode = FragmentFilterMode.REPLACE;
		}
 
		public override function dispose():void
		{
			if (mShaderProgram) mShaderProgram.dispose();
			super.dispose();
		}
 
		protected override function createPrograms():void
		{			
			var fragmentProgramCode:String =
				"tex ft0, v0, fs0 <2d,clamp,linear> \n" +
				"sub ft1.x ft0.w fc0.x \n" +
				"kil ft1.x \n" +
				"mov oc, ft0 \n";
 
			mShaderProgram = assembleAgal(fragmentProgramCode);
        }
 
		protected override function activate(pass:int, context:Context3D, texture:Texture):void
		{
			// already set by super class:
			//
			// vertex constants 0-3: mvpMatrix (3D)
			// vertex attribute 0:   vertex position (FLOAT_2)
			// vertex attribute 1:   texture coordinates (FLOAT_2)
			// texture 0:            input texture
			
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, mVars, 1);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, mColor, 1);
			context.setProgram(mShaderProgram);
        }
    }
}