package com.popcap.flash.framework.widgets
{
   public class CFlagsMod
   {
       
      
      public var removeFlags:Number = 0;
      
      public var addFlags:Number = 0;
      
      public function CFlagsMod()
      {
         super();
      }
      
      public static function getModFlags(flags:Number, mod:CFlagsMod) : Number
      {
         return (flags | mod.addFlags) & ~mod.removeFlags;
      }
   }
}
