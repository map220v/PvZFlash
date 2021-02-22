package com.popcap.flash.framework.resources.sound
{
   import flash.media.Sound;
   
   public class SoundDescriptor
   {
       
      
      private var mSoundClass:Class;
      
      public function SoundDescriptor(soundClass:Class)
      {
         super();
         this.mSoundClass = soundClass;
      }
      
      public function createData() : SoundData
      {
         return new SoundData(new this.mSoundClass() as Sound);
      }
   }
}
