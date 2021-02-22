package com.popcap.flash.framework.resources.music
{
   import com.popcap.flash.framework.AppBase;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundLoaderContext;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class MusicManager
   {
       
      
      private var mFadeVolume:Number = 0;
      
      private var mPlayingChannel:SoundChannel;
      
      private var mPlayingPosition:Number;
      
      private var mQueuedLoop:Boolean = false;
      
      private var mSongs:Dictionary;
      
      private var mFailed:Boolean = false;
      
      private var mFadeTimer:Number = 0;
      
      private var mIdle:Boolean = true;
      
      private var mSoundTransform:SoundTransform;
      
      private var mIDs:Array;
      
      private var mLoop:Boolean = false;
      
      private var mApp:AppBase;
      
      private var mFadeTime:Number = 0;
      
      private var mQueuedId:MusicId = null;
      
      private var mPlayingId:MusicId;
      
      private var mMuted:Boolean = false;
      
      public function MusicManager(app:AppBase)
      {
         super();
         this.mApp = app;
         this.mIDs = new Array();
         this.mSongs = new Dictionary();
         this.mSoundTransform = new SoundTransform();
      }
      
      private function handleError(e:IOErrorEvent) : void
      {
         throw new Error("Unable to load music.\n" + e.toString());
      }
      
      private function handleComplete(e:Event) : void
      {
         if(this.mPlayingId == null)
         {
            return;
         }
         this.mPlayingChannel.removeEventListener(Event.SOUND_COMPLETE,this.handleComplete);
         this.mPlayingChannel = null;
         this.mPlayingPosition = 0;
         this.resumeMusic();
      }
      
      public function resumeMusic() : void
      {
         if(this.mPlayingId == null)
         {
            this.mFailed = false;
            return;
         }
         if(this.mPlayingChannel != null)
         {
            this.mFailed = false;
            return;
         }
         var aSong:Sound = this.mSongs[this.mPlayingId];
         var aChannel:SoundChannel = aSong.play(this.mPlayingPosition,0,this.mSoundTransform);
         if(aChannel == null)
         {
            this.mFailed = true;
            return;
         }
         this.mPlayingChannel = aChannel;
         if(this.mLoop)
         {
            this.mPlayingChannel.addEventListener(Event.SOUND_COMPLETE,this.handleComplete);
         }
         this.mPlayingPosition = 0;
         this.mFailed = false;
      }
      
      public function pauseMusic() : void
      {
         if(this.mPlayingChannel == null)
         {
            return;
         }
         this.mPlayingPosition = this.mPlayingChannel.position;
         this.mPlayingChannel.stop();
         this.mPlayingChannel.removeEventListener(Event.SOUND_COMPLETE,this.handleComplete);
         this.mPlayingChannel = null;
      }
      
      public function update() : void
      {
         var trans:SoundTransform = null;
         if(this.mFadeTimer > 0)
         {
            this.mFadeTimer--;
            this.mFadeVolume = this.mFadeTimer / this.mFadeTime;
            if(this.mPlayingChannel != null && !this.mMuted)
            {
               trans = this.mPlayingChannel.soundTransform;
               trans.volume = this.mFadeVolume;
               this.mPlayingChannel.soundTransform = trans;
            }
            if(this.mFadeTimer == 0)
            {
               this.playMusic(this.mQueuedId,this.mQueuedLoop,0);
            }
         }
         else
         {
            this.mFadeVolume = 1;
         }
         if(!this.mFailed)
         {
            return;
         }
         this.resumeMusic();
      }
      
      public function stopMusic(id:MusicId) : void
      {
         if(this.mPlayingChannel == null)
         {
            return;
         }
         this.mPlayingPosition = 0;
         this.mPlayingChannel.stop();
         this.mPlayingChannel.removeEventListener(Event.SOUND_COMPLETE,this.handleComplete);
         this.mPlayingChannel = null;
         this.mPlayingId = null;
      }
      
      public function playMusic(id:MusicId, loop:Boolean = true, fadeTime:Number = 0) : void
      {
         var aSong:Sound = this.mSongs[id];
         if(aSong == null)
         {
            throw new Error("Cannot play unregistered music with id \'" + id + "\'");
         }
         if(this.mPlayingId != null && fadeTime > 0)
         {
            this.mFadeTime = fadeTime;
            this.mFadeTimer = this.mFadeTime;
            this.mQueuedLoop = loop;
            this.mQueuedId = id;
            return;
         }
         if(this.mPlayingId != null)
         {
            this.stopMusic(this.mPlayingId);
         }
         this.mPlayingId = id;
         this.mPlayingPosition = 0;
         this.mLoop = loop;
         var aChannel:SoundChannel = aSong.play(0,0,this.mSoundTransform);
         if(aChannel == null)
         {
            this.mFailed = true;
            return;
         }
         this.mPlayingChannel = aChannel;
         if(this.mLoop)
         {
            this.mPlayingChannel.addEventListener(Event.SOUND_COMPLETE,this.handleComplete);
         }
         this.mFailed = false;
      }
      
      public function registerMusic(id:MusicId, filename:String) : Boolean
      {
         if(this.mSongs[id] != null)
         {
            throw new Error("Music is already registered to id \'" + id + "\'");
         }
         var aSound:Sound = new Sound();
         var url:URLRequest = new URLRequest(filename);
         var context:SoundLoaderContext = new SoundLoaderContext(1000,true);
         aSound.addEventListener(IOErrorEvent.IO_ERROR,this.handleError);
         aSound.load(url,context);
         this.mSongs[id] = aSound;
         this.mIDs.push(id);
         return true;
      }
      
      public function setVolume(volume:Number) : void
      {
         this.mSoundTransform.volume = volume;
         if(this.mMuted)
         {
            this.mSoundTransform.volume = 0;
         }
         if(this.mPlayingChannel != null)
         {
            this.mPlayingChannel.soundTransform = this.mSoundTransform;
         }
      }
      
      public function mute() : void
      {
         this.mMuted = true || this.mApp.mMasterMute;
         this.setVolume(0);
      }
      
      public function stopAllMusic() : void
      {
         var id:MusicId = null;
         for each(id in this.mIDs)
         {
            this.stopMusic(id);
         }
      }
      
      public function isMuted() : Boolean
      {
         return this.mMuted;
      }
      
      public function unmute() : void
      {
         this.mMuted = false || this.mApp.mMasterMute;
         this.setVolume(this.mFadeVolume);
      }
      
      public function getPlayingId() : MusicId
      {
         return this.mPlayingId;
      }
   }
}
