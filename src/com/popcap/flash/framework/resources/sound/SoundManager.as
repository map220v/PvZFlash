package com.popcap.flash.framework.resources.sound
{
   import com.popcap.flash.framework.AppBase;
   
   public class SoundManager
   {
       
      
      private var mGlobalVolume:Number = 1.0;
      
      private var mInstPool:Array;
      
      private var mApp:AppBase;
      
      private var mMuted:Boolean = false;
      
      public function SoundManager(app:AppBase)
      {
         this.mInstPool = new Array();
         super();
         this.mApp = app;
      }
      
      private function getData(id:String) : SoundData
      {
         var obj:Object = this.mApp.resourceManager.getResource(id);
         var desc:SoundDescriptor = obj as SoundDescriptor;
         if(desc != null)
         {
            obj = desc.createData();
            this.mApp.resourceManager.setResource(id,obj);
         }
         var data:SoundData = obj as SoundData;
         if(data == null)
         {
            throw new Error("Sound \'" + id + "\' is not loaded.");
         }
         return data;
      }
      
      public function isMuted() : Boolean
      {
         return this.mMuted;
      }
      
      public function playSound(id:String, numPlays:Number = 1) : SoundInst
      {
         var data:SoundData = this.getData(id);
         var anInst:SoundInst = this.getSoundInst(data,numPlays);
         anInst.play(this.mGlobalVolume);
         return anInst;
      }
      
      public function resumeAll() : void
      {
         var inst:SoundInst = null;
         var len:int = this.mInstPool.length;
         for(var i:int = 0; i < len; i++)
         {
            inst = this.mInstPool[i];
            inst.resume();
         }
      }
      
      private function getSoundInst(data:SoundData, numPlays:int) : SoundInst
      {
         var inst:SoundInst = null;
         var probe:SoundInst = null;
         var len:int = this.mInstPool.length;
         for(var i:int = 0; i < len; i++)
         {
            probe = this.mInstPool[i];
            if(probe.isDead())
            {
               inst = probe;
               break;
            }
         }
         if(inst == null)
         {
            inst = new SoundInst();
            this.mInstPool.push(inst);
         }
         inst.mDead = false;
         inst.mData = data;
         inst.mNumPlays = numPlays;
         data.mRefCount = data.mRefCount + 1;
         return inst;
      }
      
      public function setVolume(volume:Number) : void
      {
         var inst:SoundInst = null;
         this.mGlobalVolume = volume;
         if(this.mMuted)
         {
            this.mGlobalVolume = 0;
         }
         var len:int = this.mInstPool.length;
         for(var i:int = 0; i < len; i++)
         {
            inst = this.mInstPool[i];
            inst.setVolume(this.mGlobalVolume);
         }
      }
      
      public function pauseAll() : void
      {
         var inst:SoundInst = null;
         var len:int = this.mInstPool.length;
         for(var i:int = 0; i < len; i++)
         {
            inst = this.mInstPool[i];
            inst.pause();
         }
      }
      
      public function toggleMute() : void
      {
         if(this.mMuted)
         {
            this.unmute();
         }
         else
         {
            this.mute();
         }
      }
      
      public function addDescriptor(id:String, desc:SoundDescriptor) : void
      {
         this.mApp.resourceManager.setResource(id,desc);
      }
      
      public function unmute() : void
      {
         this.mMuted = false || this.mApp.mMasterMute;
         this.setVolume(1);
      }
      
      public function getNumPlaying(id:String) : Number
      {
         var data:SoundData = this.getData(id);
         return data.mRefCount;
      }
      
      public function mute() : void
      {
         this.mMuted = true || this.mApp.mMasterMute;
         this.setVolume(0);
      }
      
      public function stopAll() : void
      {
         var inst:SoundInst = null;
         var len:int = this.mInstPool.length;
         for(var i:int = 0; i < len; i++)
         {
            inst = this.mInstPool[i];
            inst.stop();
         }
      }
   }
}
