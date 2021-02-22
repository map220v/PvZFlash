package com.popcap.flash.framework
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   public class BaseAppPlugin implements IAppPlugin
   {
       
      
      private var mContext:BaseAppPluginContext;
      
      private var mLoader:Loader;
      
      private var mProperties:XML;
      
      private var mLoaded:Boolean = false;
      
      private var mApp:AppBase;
      
      private var mActivator:IAppPluginActivator;
      
      public function BaseAppPlugin(app:AppBase, properties:XML)
      {
         super();
         this.mApp = app;
         this.mLoader = new Loader();
         var info:LoaderInfo = this.mLoader.contentLoaderInfo;
         info.addEventListener(IOErrorEvent.IO_ERROR,this.handleLoadFailure);
         info.addEventListener(Event.COMPLETE,this.handleLoadSuccess);
         this.mProperties = properties;
      }
      
      public function load() : void
      {
         var url:URLRequest = new URLRequest(this.mProperties.@source);
         this.mLoader.load(url);
      }
      
      public function getProperties() : XML
      {
         return this.mProperties;
      }
      
      private function handleLoadSuccess(e:Event) : void
      {
         var loader:LoaderInfo = e.target as LoaderInfo;
         this.mContext = new BaseAppPluginContext(this.mApp,this);
         this.mActivator = loader.content as IAppPluginActivator;
         this.mActivator.start(this.mContext);
         this.mLoaded = true;
      }
      
      public function isLoaded() : Boolean
      {
         return this.mLoaded;
      }
      
      private function handleLoadFailure(e:IOErrorEvent) : void
      {
         this.mLoaded = true;
      }
   }
}
