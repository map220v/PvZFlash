package com.popcap.flash.framework.resources
{
   import com.popcap.flash.framework.AppBase;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class ResourceManager
   {
       
      
      private var mIsLoading:Boolean;
      
      private var mLoader:Loader;
      
      private var mLibrary:ResourceLibrary;
      
      private var mApp:AppBase;
      
      private var mResources:Dictionary;
      
      public function ResourceManager(app:AppBase)
      {
         super();
         this.mApp = app;
         this.init();
      }
      
      public function getResource(id:String) : Object
      {
         if(this.mLibrary == null)
         {
            return this.mResources[id];
         }
         if(this.mResources[id] != null)
         {
            return this.mResources[id];
         }
         return this.mLibrary.getResource(id);
      }
      
      public function isLoading() : Boolean
      {
         return this.mIsLoading;
      }
      
      public function getPercentageLoaded() : Number
      {
         if(!this.mIsLoading)
         {
            return 1;
         }
         var loaded:Number = this.mLoader.contentLoaderInfo.bytesLoaded;
         var total:Number = this.mLoader.contentLoaderInfo.bytesTotal + 1;
         var percent:Number = loaded / total;
         if(isNaN(percent))
         {
            return 0;
         }
         return percent;
      }
      
      public function loadResourceLibrary(filename:String) : void
      {
         if(this.mIsLoading)
         {
            throw new Error("Only one library may be loaded at a time.");
         }
         this.mIsLoading = true;
         var url:URLRequest = new URLRequest(filename);
         this.mLoader.load(url);
      }
      
      private function init() : void
      {
         this.mResources = new Dictionary();
         this.mIsLoading = false;
         this.mLoader = new Loader();
         var cli:LoaderInfo = this.mLoader.contentLoaderInfo;
         cli.addEventListener(Event.COMPLETE,this.handleLibrary);
      }
      
      private function handleLibrary(e:Event) : void
      {
         this.mLibrary = this.mLoader.content as ResourceLibrary;
         this.mIsLoading = false;
      }
      
      public function setResource(id:String, resource:Object) : void
      {
         this.mResources[id] = resource;
      }
   }
}
