package com.popcap.flash.framework
{
   public class BaseAppServiceRegistration implements IAppServiceRegistration
   {
       
      
      private var mProperties:XML;
      
      private var mApp:AppBase;
      
      private var mService:Object;
      
      private var mPlugin:BaseAppPlugin;
      
      private var mClasses:Vector.<String>;
      
      public function BaseAppServiceRegistration(app:AppBase, plugin:BaseAppPlugin, classes:Vector.<String>, service:Object, properties:XML)
      {
         super();
         this.mApp = app;
         this.mPlugin = plugin;
         this.mClasses = classes;
         this.mService = service;
         this.mProperties = properties;
      }
      
      public function unregister() : void
      {
         throw new Error("Unimplemented stub method.");
      }
      
      public function setProperties(properties:XML) : void
      {
         this.mProperties = properties.copy();
      }
      
      public function getProperties() : XML
      {
         return this.mProperties.copy();
      }
      
      public function getReference() : IAppServiceReference
      {
         return new BaseAppServiceReference(this.mPlugin,this);
      }
      
      public function getService() : Object
      {
         return this.mService;
      }
   }
}
