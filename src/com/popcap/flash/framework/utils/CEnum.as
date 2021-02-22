package com.popcap.flash.framework.utils
{
   import flash.utils.describeType;
   
   public class CEnum
   {
       
      
      public var name:String;
      
      public function CEnum()
      {
         super();
      }
      
      public static function InitEnumConstants(inType:*) : void
      {
         var constant:XML = null;
         var type:XML = describeType(inType);
         for each(constant in type.constant)
         {
            inType[constant.@name].name = constant.@name;
         }
      }
   }
}
