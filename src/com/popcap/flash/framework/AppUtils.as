package com.popcap.flash.framework
{
   public class AppUtils
   {
       
      
      public function AppUtils()
      {
         super();
      }
      
      public static function asNumber(value:String, defaultValue:Number = 0) : Number
      {
         if(value == null)
         {
            return defaultValue;
         }
         var num:Number = parseFloat(value);
         if(isNaN(num))
         {
            return defaultValue;
         }
         return num;
      }
      
      public static function asBoolean(value:String, defaultValue:Boolean = false) : Boolean
      {
         if(value == null || value.length == 0)
         {
            return defaultValue;
         }
         if(value.toLowerCase() == "true")
         {
            return true;
         }
         var num:Number = parseFloat(value);
         if(isNaN(num))
         {
            return false;
         }
         if(num > 0)
         {
            return true;
         }
         return false;
      }
   }
}
