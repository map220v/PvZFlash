package com.popcap.flash.framework.resources.particles
{
   import com.popcap.flash.framework.utils.CEnum;
   
   public class ParticleFieldType extends CEnum
   {
      
      public static const ACCELERATION:ParticleFieldType = new ParticleFieldType();
      
      public static const FRICTION:ParticleFieldType = new ParticleFieldType();
      
      public static const ATTRACTOR:ParticleFieldType = new ParticleFieldType();
      
      public static const CIRCLE:ParticleFieldType = new ParticleFieldType();
      
      public static const GROUND_CONSTRAINT:ParticleFieldType = new ParticleFieldType();
      
      public static const INVALID:ParticleFieldType = new ParticleFieldType();
      
      public static const VELOCITY:ParticleFieldType = new ParticleFieldType();
      
      public static const SHAKE:ParticleFieldType = new ParticleFieldType();
      
      public static const POSITION:ParticleFieldType = new ParticleFieldType();
      
      public static const AWAY:ParticleFieldType = new ParticleFieldType();
      
      public static const MAX_VELOCITY:ParticleFieldType = new ParticleFieldType();
      
      public static const SYSTEM_POSITION:ParticleFieldType = new ParticleFieldType();
      
      {
         CEnum.InitEnumConstants(ParticleFieldType);
      }
      
      public function ParticleFieldType()
      {
         super();
      }
      
      public static function fromUInt(value:uint) : ParticleFieldType
      {
         switch(value)
         {
            case 0:
               return INVALID;
            case 1:
               return FRICTION;
            case 2:
               return ACCELERATION;
            case 3:
               return ATTRACTOR;
            case 4:
               return MAX_VELOCITY;
            case 5:
               return VELOCITY;
            case 6:
               return POSITION;
            case 7:
               return SYSTEM_POSITION;
            case 8:
               return GROUND_CONSTRAINT;
            case 9:
               return SHAKE;
            case 10:
               return CIRCLE;
            case 11:
               return AWAY;
            default:
               return null;
         }
      }
      
      public static function fromString(str:String) : ParticleFieldType
      {
         switch(str)
         {
            case "Friction":
               return FRICTION;
            case "Acceleration":
               return ACCELERATION;
            case "Attractor":
               return ATTRACTOR;
            case "MaxVelocity":
               return MAX_VELOCITY;
            case "Velocity":
               return VELOCITY;
            case "Position":
               return POSITION;
            case "SystemPosition":
               return SYSTEM_POSITION;
            case "GroundConstraint":
               return GROUND_CONSTRAINT;
            case "Shake":
               return SHAKE;
            case "Circle":
               return CIRCLE;
            case "Away":
               return AWAY;
            default:
               throw new ArgumentError("Unknown ParticleFieldType " + str);
         }
      }
      
      public static function toUInt(value:ParticleFieldType) : uint
      {
         if(value == INVALID)
         {
            return 0;
         }
         if(value == FRICTION)
         {
            return 1;
         }
         if(value == ACCELERATION)
         {
            return 2;
         }
         if(value == ATTRACTOR)
         {
            return 3;
         }
         if(value == MAX_VELOCITY)
         {
            return 4;
         }
         if(value == VELOCITY)
         {
            return 5;
         }
         if(value == POSITION)
         {
            return 6;
         }
         if(value == SYSTEM_POSITION)
         {
            return 7;
         }
         if(value == GROUND_CONSTRAINT)
         {
            return 8;
         }
         if(value == SHAKE)
         {
            return 9;
         }
         if(value == CIRCLE)
         {
            return 10;
         }
         if(value == AWAY)
         {
            return 11;
         }
         throw new Error("How did I get here?");
      }
      
      public function toString() : String
      {
         return name;
      }
   }
}
