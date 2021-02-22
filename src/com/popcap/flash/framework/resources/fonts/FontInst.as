package com.popcap.flash.framework.resources.fonts
{
   import com.popcap.flash.framework.graphics.Color;
   import com.popcap.flash.framework.graphics.Graphics2D;
   import com.popcap.flash.framework.resources.images.ImageInst;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class FontInst
   {
       
      
      private var mColorTransform:ColorTransform;
      
      private var mData:FontData;
      
      private var mScale:Number;
      
      public function FontInst(data:FontData)
      {
         this.mColorTransform = new ColorTransform();
         super();
         this.mData = data;
         this.mScale = 1;
      }
      
      public function getAscentPadding() : Number
      {
         return this.mData.getAscentPadding() * this.mScale;
      }
      
      public function stringImageWidth(str:String) : Number
      {
         return this.mData.stringImageWidth(str) * this.mScale;
      }
      
      public function getDescent() : Number
      {
         return this.mData.getDescent() * this.mScale;
      }
      
      public function setColor(a:Number, r:Number, g:Number, b:Number) : void
      {
         this.mColorTransform.alphaMultiplier = a;
         this.mColorTransform.redMultiplier = r;
         this.mColorTransform.greenMultiplier = g;
         this.mColorTransform.blueMultiplier = b;
      }
      
      public function get scale() : Number
      {
         return this.mScale;
      }
      
      public function draw(g:Graphics2D, x:Number, y:Number, str:String, clipRect:Rectangle) : void
      {
         var layer:FontLayer = null;
         var aCurXPos:Number = NaN;
         var numChars:int = 0;
         var i:int = 0;
         var aCode:Number = NaN;
         var aData:CharData = null;
         var aMaxXPos:Number = NaN;
         var aLayerXPos:Number = NaN;
         var aSpacing:Number = NaN;
         var aCharWidth:Number = NaN;
         var anImageX:Number = NaN;
         var anImageY:Number = NaN;
         var aLayerColor:Color = null;
         var aImage:ImageInst = null;
         var baseLayer:FontLayer = this.mData.layerList[0];
         var wordTransform:Matrix = g.getTransform();
         var charTransform:Matrix = new Matrix();
         g.identity();
         var numLayers:int = this.mData.layerList.length;
         for(var j:int = 0; j < numLayers; j++)
         {
            layer = this.mData.layerList[j];
            aCurXPos = 0;
            numChars = str.length;
            for(i = 0; i < numChars; i++)
            {
               aCode = str.charCodeAt(i);
               aData = layer.getCharData(aCode);
               aMaxXPos = aCurXPos;
               aLayerXPos = aCurXPos;
               aSpacing = 0;
               aCharWidth = aData.mWidth;
               anImageX = aLayerXPos + baseLayer.mOffset.x + aData.mOffset.x;
               anImageY = -(layer.mAscent - layer.mOffset.y - aData.mOffset.y);
               if(aData.mImage != null)
               {
                  aLayerColor = Color.fromInt(layer.mColorMult);
                  aImage = aData.mImage;
                  aImage.setColor(this.mColorTransform.alphaMultiplier * aLayerColor.alpha,this.mColorTransform.redMultiplier * aLayerColor.red,this.mColorTransform.greenMultiplier * aLayerColor.green,this.mColorTransform.blueMultiplier * aLayerColor.blue);
                  aImage.useColor = true;
                  charTransform.identity();
                  charTransform.translate(anImageX,0);
                  charTransform.scale(this.mScale,this.mScale);
                  charTransform.concat(wordTransform);
                  g.setTransform(charTransform);
                  g.drawImage(aData.mImage,x,y);
               }
               aLayerXPos = aLayerXPos + (aCharWidth + aSpacing);
               if(aLayerXPos > aMaxXPos)
               {
                  aMaxXPos = aLayerXPos;
               }
               aCurXPos = aMaxXPos;
            }
         }
         g.setTransform(wordTransform);
      }
      
      public function getAscent() : Number
      {
         return this.mData.getAscent() * this.mScale;
      }
      
      public function set scale(value:Number) : void
      {
         this.mScale = value;
      }
      
      public function getHeight() : Number
      {
         return this.mData.getHeight() * this.mScale;
      }
      
      public function getLineSpacing() : Number
      {
         return this.mData.getLineSpacing() * this.mScale;
      }
      
      public function getLineSpacingOffset() : Number
      {
         return this.mData.getLineSpacingOffset() * this.mScale;
      }
      
      public function stringWidth(str:String) : Number
      {
         return this.mData.stringWidth(str) * this.mScale;
      }
   }
}
