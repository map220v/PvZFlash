package com.popcap.flash.framework.resources.images
{
   import com.popcap.flash.framework.AppBase;
   
   public class ImageManager
   {
       
      
      private var mApp:AppBase;
      
      public function ImageManager(app:AppBase)
      {
         super();
         this.mApp = app;
      }
      
      public function getImageInst(id:String) : ImageInst
      {
         var obj:Object = this.mApp.resourceManager.getResource(id);
         var desc:ImageDescriptor = obj as ImageDescriptor;
         if(desc != null)
         {
            obj = desc.createData();
            this.mApp.resourceManager.setResource(id,obj);
         }
         var data:ImageData = obj as ImageData;
         if(data == null)
         {
            throw new Error("Image \'" + id + "\' is not loaded.");
         }
         var img:ImageInst = new ImageInst(data);
         return img;
      }
      
      public function addDescriptor(id:String, desc:ImageDescriptor) : void
      {
         this.mApp.resourceManager.setResource(id,desc);
      }
   }
}
