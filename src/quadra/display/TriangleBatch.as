package quadra.display
{
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.errors.MissingContextError;
	import starling.events.Event;
	import starling.utils.VertexData;
	

	public class TriangleBatch extends DisplayObject
	{
		private static const PROGRAM_NAME:String = "TB_";
		
		// vertex data 
        private var _vertexData:VertexData;
        private var _vertexBuffer:VertexBuffer3D;
        
        // index data
        private var _indexData:Vector.<uint>;
        private var _indexBuffer:IndexBuffer3D;
        
        // helper objects (to avoid temporary objects)
        private static var sHelperMatrix:Matrix = new Matrix();
        private static var sRenderAlpha:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
		
		public function TriangleBatch()
		{
            registerPrograms();
			_vertexData = new VertexData(0);
			_indexData = new Vector.<uint>
			
			Starling.current.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
        }
        
        /** Disposes all resources of the display object. */
        public override function dispose():void
        {
            Starling.current.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
            
            if (_vertexBuffer) _vertexBuffer.dispose();
            if (_indexBuffer)  _indexBuffer.dispose();
        }
        
        private function onContextCreated(event:Event):void
        {
            // the old context was lost, so we create new buffers and shaders.
            createBuffers();
            registerPrograms();
        }
		
		private function createBuffers():void
        {
            var context:Context3D = Starling.context;
            if (context == null) throw new MissingContextError();
            
            if (_vertexBuffer) _vertexBuffer.dispose();
            if (_indexBuffer)  _indexBuffer.dispose();
            
            _vertexBuffer = context.createVertexBuffer(_vertexData.numVertices, VertexData.ELEMENTS_PER_VERTEX);
            _indexBuffer = context.createIndexBuffer(_indexData.length);
        }
		
		private static function registerPrograms():void
        {
            var target:Starling = Starling.current;
            if (target.hasProgram(PROGRAM_NAME)) return; // already registered
            
            // va0 -> position
            // va1 -> color
            // vc0 -> mvpMatrix (4 vectors, vc0 - vc3)
            // vc4 -> alpha
            
            var vertexProgramCode:String =
                "m44 op, va0, vc0 \n" + // 4x4 matrix transform to output space
                "mul v0, va1, vc4 \n";  // multiply color with alpha and pass it to fragment shader
            
            var fragmentProgramCode:String =
                "mov oc, v0";           // just forward incoming color
            
            var vertexProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            vertexProgramAssembler.assemble(Context3DProgramType.VERTEX, vertexProgramCode);
            
            var fragmentProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            fragmentProgramAssembler.assemble(Context3DProgramType.FRAGMENT, fragmentProgramCode);
            
            target.registerProgram(PROGRAM_NAME, vertexProgramAssembler.agalcode,
                fragmentProgramAssembler.agalcode);
        }
		
		public function clear():void
		{
			_vertexData.numVertices = 0;
			_indexData.splice(0, _indexData.length);
		}
		
		public function addVertices(vertexData:VertexData, indices:Vector.<uint>=null):void
		{
			var nextIndex:int = _vertexData.numVertices;
			_vertexData.numVertices += vertexData.numVertices;
			vertexData.copyTo(_vertexData, nextIndex);
			
			if (indices == null)
			{
				for (var i:int = nextIndex; i < _vertexData.numVertices; ++i)
				{
					_indexData.push(nextIndex + i);
				}
			}
			else
			{
				for (var j:int = 0; j < indices.length; ++j)
				{
					_indexData.push(nextIndex + indices[j]);
				}
			}
		}
		
		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
        {
            if (resultRect == null) resultRect = new Rectangle();
            
            var transformationMatrix:Matrix = targetSpace == this ?
                null : getTransformationMatrix(targetSpace, sHelperMatrix);
            
            return _vertexData.getBounds(transformationMatrix, 0, _vertexData.numVertices, resultRect);
        }
		
		public override function render(support:RenderSupport, parentAlpha:Number):void
        {
            if (_vertexData.numVertices > 3)
            {
                support.finishQuadBatch();
                support.raiseDrawCount();
                renderCustom(support);
            }
        }
		
		private function renderCustom(support:RenderSupport):void
		{
			createBuffers();
			
			_vertexBuffer.uploadFromVector(_vertexData.rawData, 0, _vertexData.numVertices);
			_indexBuffer.uploadFromVector(_indexData, 0, _indexData.length);
            
            sRenderAlpha[0] = sRenderAlpha[1] = sRenderAlpha[2] = 1.0;
            sRenderAlpha[3] = alpha * this.alpha;
            
            var context:Context3D = Starling.context;
            if (context == null) throw new MissingContextError();
            
            // apply the current blendmode
            support.applyBlendMode(false);
            
            // activate program (shader) and set the required buffers / constants 
            context.setProgram(Starling.current.getProgram(PROGRAM_NAME));
            context.setVertexBufferAt(0, _vertexBuffer, VertexData.POSITION_OFFSET, Context3DVertexBufferFormat.FLOAT_2); 
            context.setVertexBufferAt(1, _vertexBuffer, VertexData.COLOR_OFFSET,    Context3DVertexBufferFormat.FLOAT_4);
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, support.mvpMatrix3D, true);            
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, sRenderAlpha, 1);
            
            // finally: draw the object!
            context.drawTriangles(_indexBuffer);
            
            // reset buffers
            context.setVertexBufferAt(0, null);
            context.setVertexBufferAt(1, null);
		}
	}
}