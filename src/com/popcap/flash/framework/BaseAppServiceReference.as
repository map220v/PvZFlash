package com.popcap.flash.framework
{
   public class BaseAppServiceReference implements IAppServiceReference
   {
       
      
      private var mPlugin:BaseAppPlugin;
      
      private var mRegistration:BaseAppServiceRegistration;
      
      public function BaseAppServiceReference(plugin:BaseAppPlugin, registration:BaseAppServiceRegistration)
      {
         super();
         this.mPlugin = plugin;
         this.mRegistration = registration;
      }
      
      public function getProperties() : XML
      {
         return this.mRegistration.getProperties();
      }
      
      public function getUsingPlugins() : Vector.<IAppPlugin>
      {
         throw new Error("Unimplemented stub method.");
      }
      
      public function getPlugin() : IAppPlugin
      {
         return this.mPlugin;
      }
   }
}
