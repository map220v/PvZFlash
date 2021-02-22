package com.popcap.flash.framework.resources.sound
{
   import flash.events.Event;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class SoundInst
   {
       
      
      public var mNumPlays:int;
      
      public var mDead:Boolean = false;
      
      private var mChannel:SoundChannel;
      
      public var mData:SoundData;
      
      private var mTrans:SoundTransform;
      
      private var mPosition:Number = 0;
      
      public function SoundInst()
      {
         super();
         this.mTrans = new SoundTransform();
      }
      
      private function die() : void
      {
         this.mDead = true;
         this.mChannel = null;
         this.mData.mRefCount = this.mData.mRefCount - 1;
      }
      
      private function handleComplete(e:Event) : void
      {
         this.mChannel.removeEventListener(Event.SOUND_COMPLETE,this.handleComplete);
         this.mChannel = null;
         this.play();
      }
      
      public function stop() : void
      {
         if(this.mChannel == null)
         {
            return;
         }
         this.mChannel.stop();
         this.die();
      }
      
      public function resume() : void
      {
         if(this.mDead)
         {
            return;
         }
         if(this.mChannel != null)
         {
            return;
         }
         this.mChannel = this.mData.mSource.play(this.mPosition,0,this.mTrans);
         if(this.mChannel == null)
         {
            this.die();
            return;
         }
         this.mChannel.addEventListener(Event.SOUND_COMPLETE,this.handleComplete);
      }
      
      public function play(volume:Number = 1.0, position:Number = 0) : void
      {
         if(this.mDead)
         {
            return;
         }
         if(this.mChannel != null)
         {
            return;
         }
         if(this.mNumPlays == 0)
         {
            this.die();
            return;
         }
         if(this.mNumPlays > 0)
         {
            this.mNumPlays--;
         }
         this.mTrans.volume = volume;
         this.mChannel = this.mData.mSource.play(position,0,this.mTrans);
         if(this.mChannel == null)
         {
            this.die();
            return;
         }
         this.mChannel.addEventListener(Event.SOUND_COMPLETE,this.handleComplete);
      }
      
      public function isDead() : Boolean
      {
         return this.mDead;
      }
      
      public function pause() : void
      {
         if(this.mChannel == null)
         {
            return;
         }
         this.mPosition = this.mChannel.position;
         this.mChannel.stop();
         this.mChannel = null;
      }
      
      public function setVolume(volume:Number) : void
      {
         this.mTrans.volume = volume;
         if(this.mChannel != null)
         {
            this.mChannel.soundTransform = this.mTrans;
         }
      }
   }
}
