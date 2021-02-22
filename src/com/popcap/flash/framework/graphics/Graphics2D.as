package com.popcap.flash.framework.graphics
{
   import com.popcap.flash.framework.resources.fonts.FontInst;
   import com.popcap.flash.framework.resources.images.ImageInst;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Graphics2D
   {
      
      private static var mScratchRect:Rectangle = new Rectangle();
      
      private static var mScratchPoint:Point = new Point();
      
      private static var mScratchMatrix:Matrix = new Matrix();
      
      private static var mScratchData:BitmapData;
      
      private static var mScratchColorTransform:ColorTransform = new ColorTransform();
       
      
      private var stateStack:Array;
      
      public var state:GraphicsState;
      
      private var data:BitmapData;
      
      private var stackPos:int;
      
      public function Graphics2D(data:BitmapData)
      {
         super();
         this.data = data;
         this.stateStack = new Array();
         this.stackPos = 0;
         this.state = new GraphicsState();
         this.state.clipRect.width = data.width;
         this.state.clipRect.height = data.height;
         if(mScratchData == null)
         {
            mScratchData = new BitmapData(data.width,data.height,true,0);
         }
         this.stateStack.push(this.state);
      }
      
      public function popState() : void
      {
         if(this.stackPos == 0)
         {
            throw new Error("Unable to pop empty stack.");
         }
         this.stackPos = this.stackPos + -1;
         this.state = this.stateStack[this.stackPos];
      }
      
      public function clearClipRect() : void
      {
         this.state.clipRect = new Rectangle(0,0,this.data.width,this.data.height);
      }
      
      public function fillRect(x:Number, y:Number, w:Number, h:Number, color:uint) : void
      {
         mScratchRect.x = 0;
         mScratchRect.y = 0;
         mScratchRect.width = w;
         mScratchRect.height = h;
         mScratchPoint.x = x;
         mScratchPoint.y = y;
         mScratchData.fillRect(mScratchRect,color);
         this.data.copyPixels(mScratchData,mScratchRect,mScratchPoint,null,null,true);
      }
      
      public function scale(sX:Number, sY:Number) : void
      {
         this.state.affineMatrix.scale(sX,sY);
      }
      
      public function clear() : void
      {
         this.fillRect(0,0,this.data.width,this.data.height,4278190080);
      }
      
      public function translate(tX:Number, tY:Number) : void
      {
         this.state.affineMatrix.translate(tX,tY);
      }
      
      public function reset() : void
      {
         this.stackPos = 0;
         this.state = this.stateStack[this.stackPos];
         this.state.affineMatrix.identity();
         this.state.clipRect.x = 0;
         this.state.clipRect.y = 0;
         this.state.clipRect.width = this.data.width;
         this.state.clipRect.height = this.data.height;
         this.state.font = null;
      }
      
      public function setFont(font:FontInst) : void
      {
         this.state.font = font;
      }
      
      public function setClipRect(x:Number, y:Number, w:Number, h:Number, clear:Boolean = true) : void
      {
         var newClip:Rectangle = new Rectangle(x,y,w,h);
         if(clear)
         {
            this.state.clipRect = newClip;
            return;
         }
         this.state.clipRect = this.state.clipRect.intersection(newClip);
      }
      
      public function pushState() : void
      {
         var newState:GraphicsState = null;
         this.stackPos = this.stackPos + 1;
         if(this.stackPos >= this.stateStack.length)
         {
            newState = new GraphicsState();
            this.stateStack.push(newState);
         }
         var oldState:GraphicsState = this.state;
         this.state = this.stateStack[this.stackPos];
         this.state.affineMatrix.a = oldState.affineMatrix.a;
         this.state.affineMatrix.b = oldState.affineMatrix.b;
         this.state.affineMatrix.c = oldState.affineMatrix.c;
         this.state.affineMatrix.d = oldState.affineMatrix.d;
         this.state.affineMatrix.tx = oldState.affineMatrix.tx;
         this.state.affineMatrix.ty = oldState.affineMatrix.ty;
         this.state.clipRect.x = oldState.clipRect.x;
         this.state.clipRect.y = oldState.clipRect.y;
         this.state.clipRect.width = oldState.clipRect.width;
         this.state.clipRect.height = oldState.clipRect.height;
         this.state.font = oldState.font;
      }
      
      public function rotate(angle:Number) : void
      {
         this.state.affineMatrix.rotate(angle);
      }
      
      public function blitImage(img:ImageInst, tX:Number = 0, tY:Number = 0) : void
      {
         var pixels:BitmapData = img.pixels;
         var srcRect:Rectangle = img.srcRect;
         var destPt:Point = mScratchPoint;
         if(img.useColor)
         {
            destPt.x = 0;
            destPt.y = 0;
            mScratchData.copyPixels(pixels,srcRect,destPt);
            mScratchColorTransform.alphaMultiplier = img.alpha;
            mScratchColorTransform.redMultiplier = img.red;
            mScratchColorTransform.greenMultiplier = img.green;
            mScratchColorTransform.blueMultiplier = img.blue;
            mScratchData.colorTransform(srcRect,mScratchColorTransform);
            pixels = mScratchData;
         }
         destPt.x = this.state.affineMatrix.tx + tX + img.destPt.x;
         destPt.y = this.state.affineMatrix.ty + tY + img.destPt.y;
         this.data.copyPixels(pixels,srcRect,destPt,null,null,true);
      }
      
      public function setTransform(matrix:Matrix) : void
      {
         this.state.affineMatrix = matrix.clone();
      }
      
      public function transform(matrix:Matrix) : void
      {
         var first:Matrix = matrix.clone();
         first.concat(this.state.affineMatrix);
         this.state.affineMatrix = first;
      }
      
      public function drawString(str:String, x:Number, y:Number) : void
      {
         if(this.state.font == null)
         {
            return;
         }
         this.state.font.draw(this,x,y,str,this.state.clipRect);
      }
      
      public function getTransform() : Matrix
      {
         return this.state.affineMatrix.clone();
      }
      
      public function drawImage(img:ImageInst, x:Number = 0, y:Number = 0) : void
      {
         if(img.width == 0 || img.height == 0)
         {
            return;
         }
         var aColorTrans:ColorTransform = null;
         if(img.useColor)
         {
            mScratchColorTransform.alphaMultiplier = img.alpha;
            mScratchColorTransform.redMultiplier = img.red;
            mScratchColorTransform.greenMultiplier = img.green;
            mScratchColorTransform.blueMultiplier = img.blue;
            aColorTrans = mScratchColorTransform;
         }
         this.state.affineMatrix.translate(x,y);
         this.data.draw(img.pixels,this.state.affineMatrix,aColorTrans,null,this.state.clipRect,img.doSmoothing);
         this.state.affineMatrix.translate(-x,-y);
      }
      
      public function identity() : void
      {
         this.state.affineMatrix = new Matrix();
      }
   }
}
