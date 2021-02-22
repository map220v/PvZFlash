package com.popcap.flash.framework.resources.particles
{
   public class ParticleFlags
   {
      
      public static const SOFTWARE_ONLY:uint = 1024;
      
      public static const RANDOM_LAUNCH_SPIN:uint = 1;
      
      public static const ADDITIVE:uint = 256;
      
      public static const DIE_IF_OVERLOADED:uint = 128;
      
      public static const SYSTEM_LOOPS:uint = 8;
      
      public static const HARDWARE_ONLY:uint = 2048;
      
      public static const RANDOM_START_TIME:uint = 64;
      
      public static const PARTICLES_DONT_FOLLOW:uint = 32;
      
      public static const ALIGN_LAUNCH_SPIN:uint = 2;
      
      public static const PARTICLE_LOOPS:uint = 16;
      
      public static const FULLSCREEN:uint = 512;
      
      public static const ALIGN_TO_PIXEL:uint = 4;
       
      
      private var mFlags:uint = 0;
      
      public function ParticleFlags()
      {
         super();
      }
      
      public static function fromString(str:String) : uint
      {
         switch(str)
         {
            case "RandomLaunchSpin":
               return RANDOM_LAUNCH_SPIN;
            case "AlignLaunchSpin":
               return ALIGN_LAUNCH_SPIN;
            case "AlignToPixel":
               return ALIGN_TO_PIXEL;
            case "SystemLoops":
               return SYSTEM_LOOPS;
            case "ParticleLoops":
               return PARTICLE_LOOPS;
            case "ParticlesDontFollow":
               return PARTICLES_DONT_FOLLOW;
            case "RandomStartTime":
               return RANDOM_START_TIME;
            case "DieIfOverloaded":
               return DIE_IF_OVERLOADED;
            case "Additive":
               return ADDITIVE;
            case "FullScreen":
               return FULLSCREEN;
            case "SoftwareOnly":
               return SOFTWARE_ONLY;
            case "HardwareOnly":
               return HARDWARE_ONLY;
            default:
               throw new ArgumentError("Unknown ParticleFlags type \'" + str + "\'");
         }
      }
      
      public function setFlags(flags:uint) : void
      {
         this.mFlags = this.mFlags | flags;
      }
      
      public function clearFlags(flags:uint) : void
      {
         this.mFlags = this.mFlags & ~flags;
      }
      
      public function fromUInt(value:uint) : void
      {
         this.mFlags = value;
      }
      
      public function toUInt() : uint
      {
         return this.mFlags;
      }
      
      public function hasFlags(testFlags:uint) : Boolean
      {
         return (this.mFlags & testFlags) != 0;
      }
      
      public function toString() : String
      {
         var str:* = "[" + this.mFlags;
         if(this.hasFlags(RANDOM_LAUNCH_SPIN))
         {
            str = str + "|RANDOM_LAUNCH_SPIN";
         }
         if(this.hasFlags(ALIGN_LAUNCH_SPIN))
         {
            str = str + "|ALIGN_LAUNCH_SPING";
         }
         if(this.hasFlags(SYSTEM_LOOPS))
         {
            str = str + "|SYSTEM_LOOPS";
         }
         if(this.hasFlags(PARTICLE_LOOPS))
         {
            str = str + "|PARTICLE_LOOPS";
         }
         if(this.hasFlags(PARTICLES_DONT_FOLLOW))
         {
            str = str + "|PARTICLES_DONT_FOLLOW";
         }
         if(this.hasFlags(RANDOM_START_TIME))
         {
            str = str + "|RANDOM_START_TIME";
         }
         if(this.hasFlags(DIE_IF_OVERLOADED))
         {
            str = str + "|DIE_IF_OVERLOADED";
         }
         if(this.hasFlags(ADDITIVE))
         {
            str = str + "|ADDITIVE";
         }
         if(this.hasFlags(FULLSCREEN))
         {
            str = str + "|FULLSCREEN";
         }
         if(this.hasFlags(SOFTWARE_ONLY))
         {
            str = str + "|SOFTWARE_ONLY";
         }
         if(this.hasFlags(HARDWARE_ONLY))
         {
            str = str + "|HARDWARE_ONLY";
         }
         str = str + "]";
         return str;
      }
   }
}
