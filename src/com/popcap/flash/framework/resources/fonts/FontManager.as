package com.popcap.flash.framework.resources.fonts
{
   import com.popcap.flash.framework.AppBase;
   import flash.utils.Dictionary;
   
   public class FontManager
   {
       
      
      private var mApp:AppBase;
      
      private var mFontDataMap:Dictionary;
      
      private var mFontTypeMap:Dictionary;
      
      public function FontManager(app:AppBase)
      {
         super();
         this.mApp = app;
         this.mFontTypeMap = new Dictionary();
         this.mFontDataMap = new Dictionary();
      }
      
      public function addDescriptor(id:String, fontDesc:FontDescriptor) : void
      {
         this.mApp.resourceManager.setResource(id,fontDesc);
      }
      
      public function getFontInst(id:String) : FontInst
      {
         var obj:Object = this.mApp.resourceManager.getResource(id);
         var desc:FontDescriptor = obj as FontDescriptor;
         if(desc != null)
         {
            obj = desc.createFontData(this.mApp);
            this.mApp.resourceManager.setResource(id,obj);
         }
         var data:FontData = obj as FontData;
         if(data == null)
         {
            throw new Error("Font \'" + id + "\' is not loaded.");
         }
         var anInst:FontInst = new FontInst(data);
         return anInst;
      }
   }
}
