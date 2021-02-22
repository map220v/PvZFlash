package com.popcap.flash.framework.resources.images
{
   import com.popcap.flash.framework.graphics.Graphics2D;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ImageInst
   {
       
      
      private var mFrame:Number;
      
      public var destPt:Point;
      
      private var mColorTransform:ColorTransform;
      
      private var mGraphics:Graphics2D;
      
      public var doAdditiveBlend:Boolean = false;
      
      public var useColor:Boolean = false;
      
      public var doSmoothing:Boolean = true;
      
      private var mData:ImageData;
      
      private var mPixels:BitmapData;
      
      private var mSrcRect:Rectangle;
      
      public function ImageInst(data:ImageData)
      {
         super();
         this.destPt = new Point();
         this.mData = data;
         this.mFrame = 0;
         this.mColorTransform = new ColorTransform();
      }
      
      public function set x(value:Number) : void
      {
         this.destPt.x = value;
      }
      
      public function get green() : Number
      {
         return this.mColorTransform.greenMultiplier;
      }
      
      public function get graphics() : Graphics2D
      {
         if(this.mGraphics == null)
         {
            this.mGraphics = new Graphics2D(this.pixels);
         }
         return this.mGraphics;
      }
      
      public function get width() : Number
      {
         return this.pixels.width;
      }
      
      public function setColor(a:Number, r:Number, g:Number, b:Number) : void
      {
         this.mColorTransform.alphaMultiplier = a;
         this.mColorTransform.redMultiplier = r;
         this.mColorTransform.greenMultiplier = g;
         this.mColorTransform.blueMultiplier = b;
      }
      
      public function get red() : Number
      {
         return this.mColorTransform.redMultiplier;
      }
      
      public function get alpha() : Number
      {
         return this.mColorTransform.alphaMultiplier;
      }
      
      public function get blue() : Number
      {
         return this.mColorTransform.blueMultiplier;
      }
      
      public function get height() : Number
      {
         return this.pixels.height;
      }
      
      public function get srcRect() : Rectangle
      {
         var p:BitmapData = null;
         if(this.mSrcRect == null)
         {
            p = this.pixels;
            this.mSrcRect = new Rectangle(0,0,p.width,p.height);
         }
         return this.mSrcRect;
      }
      
      public function setFrame(frame:int, col:int, row:int) : void
      {
         var value:int = frame + col + row * this.mData.cols;
         var numFrames:int = this.mData.cels.length;
         value = value < 0?0:int(value);
         value = value >= numFrames?int(numFrames - 1):int(value);
         this.mFrame = value;
         this.mPixels = this.mData.cels[value];
         this.mSrcRect = null;
      }
      
      public function get pixels() : BitmapData
      {
         if(this.mPixels == null)
         {
            this.mPixels = this.mData.cels[0];
         }
         return this.mPixels;
      }
      
      public function set y(value:Number) : void
      {
         this.destPt.y = value;
      }
      
      public function get y() : Number
      {
         return this.destPt.y;
      }
      
      public function set frame(value:Number) : void
      {
         if(value < 0 || value >= this.mData.cels.length)
         {
            throw new Error("Frame \'" + value + "\' is out of range [0, " + (this.mData.cels.length - 1) + "]");
         }
         if(this.mFrame == value)
         {
            return;
         }
         this.mFrame = value;
         this.mPixels = this.mData.cels[value];
         this.mSrcRect = null;
      }
      
      public function get x() : Number
      {
         return this.destPt.x;
      }
   }
}
