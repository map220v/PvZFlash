package com.popcap.flash.framework.resources.images
{
   import flash.display.BitmapData;
   
   public class ImageData
   {
       
      
      public var cels:Array;
      
      public var cols:Number;
      
      public var rows:Number;
      
      public var celWidth:Number;
      
      public var celHeight:Number;
      
      public function ImageData(pixels:BitmapData = null, rows:Number = 1, cols:Number = 1)
      {
         super();
         this.cels = new Array(pixels);
         this.rows = rows;
         this.cols = cols;
      }
      
      public function toString() : String
      {
         return "Data [" + this.rows + "x" + this.cols + ", " + this.cels + "]";
      }
   }
}
