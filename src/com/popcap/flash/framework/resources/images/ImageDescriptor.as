package com.popcap.flash.framework.resources.images
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ImageDescriptor
   {
      
      private static var srcRect:Rectangle = new Rectangle();
      
      private static var destPt:Point = new Point();
       
      
      private var mRows:Number;
      
      private var mAlphaClass:Class;
      
      private var mRGBClass:Class;
      
      private var mCols:Number;
      
      public function ImageDescriptor(rgbClass:Class = null, alphaClass:Class = null, rows:Number = 1, cols:Number = 1)
      {
         super();
         this.mRGBClass = rgbClass;
         this.mAlphaClass = alphaClass;
         this.mRows = rows;
         this.mCols = cols;
      }
      
      private function sliceCels(bd:BitmapData, rows:Number, cols:Number, data:ImageData) : void
      {
         var row:Number = NaN;
         var col:Number = NaN;
         var subPixels:BitmapData = null;
         var srcRect:Rectangle = null;
         var celWidth:Number = bd.width / this.mCols;
         var celHeight:Number = bd.height / this.mRows;
         var celRect:Rectangle = new Rectangle(0,0,celWidth,celHeight);
         var destPt:Point = new Point(0,0);
         data.rows = rows;
         data.cols = cols;
         var cels:Array = new Array();
         var numCels:int = rows * cols;
         for(var i:int = 0; i < numCels; i = i + 1)
         {
            row = int(i / cols);
            col = i % cols;
            subPixels = new BitmapData(celWidth,celHeight);
            srcRect = new Rectangle(col * celWidth,row * celHeight,celWidth,celHeight);
            subPixels.copyPixels(bd,srcRect,destPt);
            cels[i] = subPixels;
         }
         data.celWidth = celWidth;
         data.celHeight = celHeight;
         data.cels = cels;
         bd.dispose();
      }
      
      public function createData() : ImageData
      {
         var imgData:BitmapData = null;
         var rgbData:BitmapData = null;
         var alphaData:BitmapData = null;
         if(this.mRGBClass != null)
         {
            rgbData = (new this.mRGBClass() as Bitmap).bitmapData;
         }
         if(this.mAlphaClass != null)
         {
            alphaData = (new this.mAlphaClass() as Bitmap).bitmapData;
         }
         if(rgbData != null)
         {
            imgData = new BitmapData(rgbData.width,rgbData.height,true,0);
         }
         else if(alphaData != null)
         {
            imgData = new BitmapData(alphaData.width,alphaData.height,true,0);
         }
         if(imgData == null)
         {
            throw new Error("Image is empty.");
         }
         srcRect.width = imgData.width;
         srcRect.height = imgData.height;
         if(rgbData != null)
         {
            imgData.copyPixels(rgbData,srcRect,destPt);
         }
         if(alphaData != null)
         {
            if(rgbData == null)
            {
               imgData.copyPixels(alphaData,srcRect,destPt);
            }
            imgData.copyChannel(alphaData,srcRect,destPt,BitmapDataChannel.RED,BitmapDataChannel.ALPHA);
         }
         var data:ImageData = new ImageData(null,this.mRows,this.mCols);
         this.sliceCels(imgData,this.mRows,this.mCols,data);
         return data;
      }
   }
}
