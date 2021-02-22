package com.popcap.flash.framework.resources.fonts
{
   import flash.utils.Dictionary;
   
   public class FontData
   {
       
      
      public var mPointSize:Number;
      
      public var layerMap:Dictionary;
      
      public var layerList:Array;
      
      private var mAscent:Number = 19;
      
      private var mAscentPadding:Number = 0;
      
      private var mHeight:Number;
      
      private var mLineSpacingOffset:Number = 0;
      
      public function FontData()
      {
         super();
         this.layerList = new Array();
         this.layerMap = new Dictionary();
      }
      
      public function charWidthKern(charCode:Number, prevCode:Number) : Number
      {
         var aData:CharData = null;
         if(this.layerList.length == 0)
         {
            return 0;
         }
         var aCharWidth:Number = 0;
         var aNumLayers:int = this.layerList.length;
         for(var i:int = 0; i < aNumLayers; i++)
         {
            aData = this.layerList[i].getCharData(charCode);
            aCharWidth = aCharWidth < aData.mWidth?Number(aData.mWidth):Number(aCharWidth);
         }
         return aCharWidth;
      }
      
      public function getAscent() : Number
      {
         var layer:FontLayer = null;
         var maxVal:Number = 0;
         for each(layer in this.layerList)
         {
            maxVal = layer.mAscent > maxVal?Number(layer.mAscent):Number(maxVal);
         }
         return maxVal;
      }
      
      public function getDescent() : Number
      {
         return 0;
      }
      
      public function charWidth(charCode:Number) : Number
      {
         return this.charWidthKern(charCode,0);
      }
      
      public function stringImageWidth(iStr:String) : Number
      {
         var aCode:Number = NaN;
         var aMaxXPos:Number = NaN;
         var numLayers:int = 0;
         var j:int = 0;
         var layer:FontLayer = null;
         var aData:CharData = null;
         var aLayerXPos:Number = NaN;
         var aSpacing:Number = NaN;
         var aCharWidth:Number = NaN;
         var anImageX:Number = NaN;
         var anImageY:Number = NaN;
         var baseLayer:FontLayer = this.layerList[0];
         var aWidth:Number = 0;
         var aCurXPos:Number = 0;
         var numChars:int = iStr.length;
         for(var i:int = 0; i < numChars; i++)
         {
            aCode = iStr.charCodeAt(i);
            aMaxXPos = aCurXPos;
            numLayers = this.layerList.length;
            for(j = 0; j < numLayers; j++)
            {
               layer = this.layerList[j];
               aData = layer.getCharData(aCode);
               aLayerXPos = aCurXPos;
               aSpacing = 0;
               aCharWidth = aData.mWidth;
               anImageX = aLayerXPos + baseLayer.mOffset.x + aData.mOffset.x;
               anImageY = -(layer.mAscent - layer.mOffset.y - aData.mOffset.y);
               if(aData.mImage != null)
               {
                  aWidth = anImageX + aData.mImage.width;
               }
               aLayerXPos = aLayerXPos + (aCharWidth + aSpacing);
               if(aLayerXPos > aMaxXPos)
               {
                  aMaxXPos = aLayerXPos;
               }
            }
            aCurXPos = aMaxXPos;
         }
         return aWidth;
      }
      
      public function getHeight() : Number
      {
         var layer:FontLayer = null;
         var maxHeight:Number = 0;
         for each(layer in this.layerList)
         {
            maxHeight = layer.height > maxHeight?Number(layer.height):Number(maxHeight);
         }
         return maxHeight;
      }
      
      private function getMappedChar(charCode:Number) : Number
      {
         return 0;
      }
      
      public function getAscentPadding() : Number
      {
         return this.mAscentPadding;
      }
      
      public function getLineSpacingOffset() : Number
      {
         return 0;
      }
      
      public function stringWidth(iStr:String) : Number
      {
         var aCode:Number = NaN;
         var aWidth:Number = 0;
         var aPrevCode:Number = 0;
         var aLen:int = iStr.length;
         for(var i:int = 0; i < aLen; i++)
         {
            aCode = iStr.charCodeAt(i);
            aWidth = aWidth + this.charWidthKern(aCode,aPrevCode);
            aPrevCode = aCode;
         }
         return aWidth;
      }
      
      public function getLineSpacing() : Number
      {
         var layer:FontLayer = null;
         var maxVal:Number = 0;
         for each(layer in this.layerList)
         {
            maxVal = layer.mSpacing > maxVal?Number(layer.mSpacing):Number(maxVal);
         }
         return maxVal;
      }
   }
}
