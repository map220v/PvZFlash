package com.popcap.flash.framework.resources.reanimator
{
   import com.popcap.flash.framework.resources.images.ImageInst;
   import flash.geom.Matrix;
   
   public class ReanimTransform
   {
       
      
      public var matrix:Matrix;
      
      public var sX:Number;
      
      public var sY:Number;
      
      public var cache:ImageInst;
      
      public var kX:Number;
      
      public var kY:Number;
      
      public var image:ImageInst;
      
      public var alpha:Number;
      
      public var tX:Number;
      
      public var tY:Number;
      
      public var frame:Number;
      
      public var imageID:String;
      
      public function ReanimTransform()
      {
         super();
         this.tX = NaN;
         this.tY = NaN;
         this.kX = NaN;
         this.kY = NaN;
         this.sX = NaN;
         this.sY = NaN;
         this.frame = NaN;
         this.alpha = NaN;
         this.image = null;
      }
      
      public function fillInFrom(other:ReanimTransform) : void
      {
         if(other == null)
         {
            other = new ReanimTransform();
            other.tX = 0;
            other.tY = 0;
            other.kX = 0;
            other.kY = 0;
            other.sX = 1;
            other.sY = 1;
            other.frame = -1;
            other.alpha = 1;
         }
         if(isNaN(this.tX))
         {
            this.tX = other.tX;
         }
         if(isNaN(this.tY))
         {
            this.tY = other.tY;
         }
         if(isNaN(this.kX))
         {
            this.kX = other.kX;
         }
         if(isNaN(this.kY))
         {
            this.kY = other.kY;
         }
         if(isNaN(this.sX))
         {
            this.sX = other.sX;
         }
         if(isNaN(this.sY))
         {
            this.sY = other.sY;
         }
         if(isNaN(this.frame))
         {
            this.frame = other.frame;
         }
         if(isNaN(this.alpha))
         {
            this.alpha = other.alpha;
         }
         if(this.image == null)
         {
            this.image = other.image;
         }
         this.calcMatrix();
      }
      
      public function calcMatrix() : void
      {
         this.matrix = new Matrix(Math.cos(this.kX) * this.sX,-Math.sin(this.kX) * this.sX,Math.sin(this.kY) * this.sY,Math.cos(this.kY) * this.sY,this.tX,this.tY);
      }
      
      public function toString() : String
      {
         return "[" + this.frame + "] x:" + this.tX + " y:" + this.tY + " image:" + this.image;
      }
   }
}
