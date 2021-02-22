package com.popcap.flash.framework.resources.particles
{
   import com.popcap.flash.framework.utils.CEnum;
   
   public class CurveType extends CEnum
   {
      
      public static const EASE_IN_OUT:CurveType = new CurveType();
      
      public static const BOUNCE:CurveType = new CurveType();
      
      public static const EASE_IN:CurveType = new CurveType();
      
      public static const FAST_IN_OUT:CurveType = new CurveType();
      
      public static const EASE_SIN_WAVE:CurveType = new CurveType();
      
      public static const BOUNCE_SLOW_MIDDLE:CurveType = new CurveType();
      
      public static const EASE_OUT:CurveType = new CurveType();
      
      public static const FAST_IN_OUT_WEAK:CurveType = new CurveType();
      
      public static const BOUNCE_FAST_MIDDLE:CurveType = new CurveType();
      
      public static const CONSTANT:CurveType = new CurveType();
      
      public static const LINEAR:CurveType = new CurveType();
      
      public static const SIN_WAVE:CurveType = new CurveType();
      
      public static const EASE_IN_OUT_WEAK:CurveType = new CurveType();
      
      {
         CEnum.InitEnumConstants(CurveType);
      }
      
      public function CurveType()
      {
         super();
      }
      
      public static function fromUInt(value:uint) : CurveType
      {
         switch(value)
         {
            case 0:
               return CONSTANT;
            case 1:
               return LINEAR;
            case 2:
               return EASE_IN;
            case 3:
               return EASE_OUT;
            case 4:
               return EASE_IN_OUT;
            case 5:
               return EASE_IN_OUT_WEAK;
            case 6:
               return FAST_IN_OUT;
            case 7:
               return FAST_IN_OUT_WEAK;
            case 8:
               return BOUNCE;
            case 9:
               return BOUNCE_FAST_MIDDLE;
            case 10:
               return BOUNCE_SLOW_MIDDLE;
            case 11:
               return SIN_WAVE;
            case 12:
               return EASE_SIN_WAVE;
            default:
               throw new ArgumentError("Value does not map to a CurveType");
         }
      }
      
      public static function toUInt(value:CurveType) : uint
      {
         if(value == CONSTANT)
         {
            return 0;
         }
         if(value == LINEAR)
         {
            return 1;
         }
         if(value == EASE_IN)
         {
            return 2;
         }
         if(value == EASE_OUT)
         {
            return 3;
         }
         if(value == EASE_IN_OUT)
         {
            return 4;
         }
         if(value == EASE_IN_OUT_WEAK)
         {
            return 5;
         }
         if(value == FAST_IN_OUT)
         {
            return 6;
         }
         if(value == FAST_IN_OUT_WEAK)
         {
            return 7;
         }
         if(value == BOUNCE)
         {
            return 8;
         }
         if(value == BOUNCE_FAST_MIDDLE)
         {
            return 9;
         }
         if(value == BOUNCE_SLOW_MIDDLE)
         {
            return 10;
         }
         if(value == SIN_WAVE)
         {
            return 11;
         }
         if(value == EASE_SIN_WAVE)
         {
            return 12;
         }
         throw new Error("How did I get here?");
      }
      
      public function toString() : String
      {
         return name;
      }
   }
}
