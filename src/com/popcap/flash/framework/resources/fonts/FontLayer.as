package com.popcap.flash.framework.resources.fonts
{
   import com.popcap.flash.framework.resources.images.ImageInst;
   import flash.geom.Point;
   
   public class FontLayer
   {
       
      
      public var mPointSize:Number;
      
      public var mColorMult:int;
      
      public var mColorAdd:int;
      
      public var mLayerName:String;
      
      public var mBaseOrder:Number;
      
      public var mMinPointSize:Number;
      
      public var mDefaultHeight:Number;
      
      public var mSpacing:Number;
      
      public var mOffset:Point;
      
      public var mAscent:Number;
      
      public var mImageId:String;
      
      public var mAscentPadding:Number;
      
      public var mCharData:Array;
      
      public var mImage:ImageInst;
      
      public var mLineSpacingOffset:Number;
      
      public var mMaxPointSize:Number;
      
      public var mHeight:Number;
      
      public function FontLayer()
      {
         super();
         this.mCharData = new Array();
         this.mOffset = new Point();
         this.mSpacing = 0;
         this.mPointSize = 0;
         this.mAscent = 0;
         this.mAscentPadding = 0;
         this.mMinPointSize = -1;
         this.mMaxPointSize = -1;
         this.mHeight = 0;
         this.mDefaultHeight = 0;
         this.mColorMult = 4294967295;
         this.mColorAdd = 0;
         this.mLineSpacingOffset = 0;
         this.mBaseOrder = 0;
      }
      
      public function getCharData(charCode:int) : CharData
      {
         var data:CharData = this.mCharData[charCode];
         if(data == null)
         {
            data = new CharData();
            data.mCharCode = charCode;
            this.mCharData[charCode] = data;
         }
         return data;
      }
      
      public function get height() : Number
      {
         if(this.mHeight == 0)
         {
            this.mHeight = this.mImage.height;
         }
         return this.mHeight;
      }
   }
}
