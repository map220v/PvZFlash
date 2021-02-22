package com.popcap.flash.framework
{
   import flash.events.Event;
   
   public class BaseAppPluginContext implements IAppPluginContext
   {
       
      
      private var mPlugin:BaseAppPlugin;
      
      private var mApp:AppBase;
      
      public function BaseAppPluginContext(app:AppBase, plugin:BaseAppPlugin)
      {
         super();
         this.mApp = app;
         this.mPlugin = plugin;
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return this.mApp.willTrigger(type);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         this.mApp.removeEventListener(type,listener,useCapture);
      }
      
      public function getService(reference:IAppServiceReference) : Object
      {
         return this.mApp.getService(reference);
      }
      
      public function registerService(classes:Vector.<String>, service:Object, properties:XML) : IAppServiceRegistration
      {
         return this.mApp.registerService(this.mPlugin,classes,service,properties);
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         this.mApp.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function ungetService(reference:IAppServiceReference) : void
      {
         this.mApp.ungetService(reference);
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         return this.mApp.dispatchEvent(event);
      }
      
      public function getServiceReferences(clazz:String) : Vector.<IAppServiceReference>
      {
         return this.mApp.getServiceReferences(clazz);
      }
      
      public function getPlugin() : IAppPlugin
      {
         return this.mPlugin;
      }
      
      public function getPlugins() : Vector.<IAppPlugin>
      {
         return this.mApp.getPlugins();
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return this.mApp.hasEventListener(type);
      }
   }
}
