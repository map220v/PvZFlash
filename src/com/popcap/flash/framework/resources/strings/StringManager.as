package com.popcap.flash.framework.resources.strings
{
   import com.popcap.flash.framework.AppBase;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class StringManager implements IEventDispatcher
   {
       
      
      private var mLoader:URLLoader;
      
      private var mApp:AppBase;
      
      private var mStrings:Dictionary;
      
      private var mDispatcher:EventDispatcher;
      
      public function StringManager(app:AppBase)
      {
         super();
         this.mApp = app;
         this.mStrings = new Dictionary();
         this.mLoader = new URLLoader();
         this.mLoader.addEventListener(Event.COMPLETE,this.handleComplete);
         this.mLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleError);
         this.mDispatcher = new EventDispatcher(this);
      }
      
      private function handleComplete(e:Event) : void
      {
         var aLine:String = null;
         var index:Number = NaN;
         var aTextFile:String = this.mLoader.data;
         aTextFile = aTextFile.replace(/\r\n/g,"\n");
         aTextFile = aTextFile.replace(/\r/g,"\n");
         var aLines:Array = aTextFile.split(/\n/);
         var aCurrentKey:String = null;
         var aCurrentValue:String = null;
         var aNumLines:int = aLines.length;
         for(var i:int = 0; i < aNumLines; i++)
         {
            aLine = aLines[i];
            if(aLine.length != 0)
            {
               index = aLine.search(/\[[A-Z0-9_]+\]/);
               if(index == 0)
               {
                  if(aCurrentKey == null)
                  {
                     aCurrentKey = aLine;
                  }
                  else
                  {
                     this.mStrings[aCurrentKey] = aCurrentValue;
                     aCurrentKey = aLine;
                     aCurrentValue = null;
                  }
               }
               else if(aCurrentValue == null)
               {
                  aCurrentValue = aLine;
               }
               else
               {
                  aCurrentValue = aCurrentValue + "\n" + aLine;
               }
            }
         }
         this.mStrings[aCurrentKey] = aCurrentValue;
         this.mDispatcher.dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return this.mDispatcher.hasEventListener(type);
      }
      
      private function handleError(e:IOErrorEvent) : void
      {
         AppBase.log("Unable to load strings file","ERROR");
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return this.mDispatcher.willTrigger(type);
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         this.mDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         this.mDispatcher.removeEventListener(type,listener,useCapture);
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         return this.mDispatcher.dispatchEvent(event);
      }
      
      public function loadStrings(filename:String) : void
      {
         var url:URLRequest = new URLRequest(filename);
         this.mLoader.load(url);
      }
      
      public function translateString(key:String) : String
      {
         var aValue:String = this.mStrings[key];
         if(aValue == null)
         {
            return "\'" + key + "\' string has not been loaded.";
         }
         return aValue;
      }
   }
}
