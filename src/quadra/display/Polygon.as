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
	import nape.geom.GeomPoly;
	import nape.geom.GeomPolyList;
	import nape.geom.GeomVertexIterator;
	import nape.geom.Vec2;
	import nape.geom.Winding;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.errors.MissingContextError;
	import starling.events.Event;
	import starling.utils.VertexData;
    
    
    
    /** This custom display objects renders a GeomPoly. */
    public class Polygon extends DisplayObject
    {
        private static var PROGRAM_NAME:String = "polygon";
        
		private var _poly:GeomPoly;
        private var _color:uint;
        
        // vertex data 
        private var _vertexData:VertexData;
        private var _vertexBuffer:VertexBuffer3D;
        
        // index data
        private var _indexData:Vector.<uint>;
        private var _indexBuffer:IndexBuffer3D;
        
        // helper objects (to avoid temporary objects)
        private static var sHelperMatrix:Matrix = new Matrix();
        private static var sRenderAlpha:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
        
        /** Creates a regular polygon with the specified redius, number of edges, and color. */
        public function Polygon(poly:GeomPoly, color:uint=0xffffff)
        {
			_poly = poly;
            _color = color;
            
            // setup vertex data and prepare shaders
            setupVertices();
            createBuffers();
            registerPrograms();
            
            // handle lost context
            Starling.current.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
        }
        
        /** Disposes all resources of the display object. */
        public override function dispose():void
        {
            Starling.current.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
            
            if (_vertexBuffer) _vertexBuffer.dispose();
            if (_indexBuffer)  _indexBuffer.dispose();
            
            super.dispose();
        }
        
        private function onContextCreated(event:Event):void
        {
            // the old context was lost, so we create new buffers and shaders.
            createBuffers();
            registerPrograms();
        }
        
        /** Returns a rectangle that completely encloses the object as it appears in another 
         * coordinate system. */
        public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
        {
            if (resultRect == null) resultRect = new Rectangle();
            
            var transformationMatrix:Matrix = targetSpace == this ? 
                null : getTransformationMatrix(targetSpace, sHelperMatrix);
            
            return _vertexData.getBounds(transformationMatrix, 0, -1, resultRect);
        }
        
        /** Creates the required vertex- and index data and uploads it to the GPU. */ 
        private function setupVertices():void
        {
            var i:int;
			
            // create vertices
			var triangles:GeomPolyList = _poly.triangularDecomposition();
			_vertexData = new VertexData(triangles.length * 3);
			_vertexData.setUniformColor(_color);
			_indexData = new <uint>[];
			
			for (i = 0; i < triangles.length; ++i)
			{
				var tri:GeomPoly = triangles.at(i);
				var it:GeomVertexIterator = tri.iterator();
				var index:int = 0;
				while (it.hasNext())
				{
					var pos:Vec2 = it.next();
					_vertexData.setPosition(i * 3 + index, pos.x, pos.y);
					_indexData.push(_indexData.length);					
					index++;
				}
				
				var winding:Winding = tri.winding();
				if (tri.winding() == Winding.ANTICLOCKWISE)
				{
					// Reverse winding order on triangle to be render friendly.
					var endIndex:int = _indexData.length;
					var temp:int = _indexData[endIndex - 1];
					_indexData[endIndex - 1] = _indexData[endIndex];
					_indexData[endIndex] = temp;
				}
			}
        }
        
        /** Creates new vertex- and index-buffers and uploads our vertex- and index-data to those
         *  buffers. */ 
        private function createBuffers():void
        {
            var context:Context3D = Starling.context;
            if (context == null) throw new MissingContextError();
            
            if (_vertexBuffer) _vertexBuffer.dispose();
            if (_indexBuffer)  _indexBuffer.dispose();
            
            _vertexBuffer = context.createVertexBuffer(_vertexData.numVertices, VertexData.ELEMENTS_PER_VERTEX);
            _vertexBuffer.uploadFromVector(_vertexData.rawData, 0, _vertexData.numVertices);
            
            _indexBuffer = context.createIndexBuffer(_indexData.length);
            _indexBuffer.uploadFromVector(_indexData, 0, _indexData.length);
        }
        
        /** Renders the object with the help of a 'support' object and with the accumulated alpha
         * of its parent object. */
        public override function render(support:RenderSupport, alpha:Number):void
        {
            // always call this method when you write custom rendering code!
            // it causes all previously batched quads/images to render.
            support.finishQuadBatch();
            
            // make this call to keep the statistics display in sync.
            support.raiseDrawCount();
            
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
        
        /** Creates vertex and fragment programs from assembly. */
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
        
        /** The color of the regular polygon. */
        public function get color():uint { return _color; }
        public function set color(value:uint):void { _color = value; setupVertices(); }
    }
}