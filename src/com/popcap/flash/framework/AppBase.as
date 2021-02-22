package com.popcap.flash.framework
{
   import com.popcap.flash.framework.graphics.Graphics2D;
   import com.popcap.flash.framework.resources.ResourceManager;
   import com.popcap.flash.framework.resources.fonts.FontManager;
   import com.popcap.flash.framework.resources.images.ImageManager;
   import com.popcap.flash.framework.resources.music.MusicManager;
   import com.popcap.flash.framework.resources.sound.SoundManager;
   import com.popcap.flash.framework.resources.strings.StringManager;
   import com.popcap.flash.framework.states.CStateManager;
   import com.popcap.flash.framework.states.IStateManager;
   import com.popcap.flash.framework.widgets.CWidgetManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.SharedObject;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.ui.Mouse;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class AppBase extends Sprite
   {
      
      private static const SHIFT_FLAG:int = 4;
      
      public static var LOW_QUALITY:Boolean = true;
      
      private static const ALT_FLAG:int = 2;
      
      public static const UPDATE_STEP_TIME:Number = 10;
      
      private static const CONTROL_FLAG:int = 1;
       
      
      private var mCodeMap:Dictionary;
      
      private var bufferData:BitmapData;
      
      private var mPaused:Boolean = false;
      
      private var screenGraphics:Graphics2D;
      
      private var mCheatBindings:Dictionary;
      
      private var _appHeight:Number = 240;
      
      private var avgFlashTime:Number = 0;
      
      private var mUpdatesPaused:Boolean = false;
      
      private var screenData:BitmapData;
      
      private var mStepsPerTick:int = 1;
      
      private var destPt:Point;
      
      private var mSaveData:Object = null;
      
      private var canvas:Sprite;
      
      private var fpsTime:Number;
      
      private var lastUpdateTime:Number;
      
      private var screenRect:Rectangle;
      
      private var mPlugins:Vector.<BaseAppPlugin>;
      
      private var _resourceManager:ResourceManager;
      
      private var _appWidth:Number = 320;
      
      private var excessUpdateTime:Number;
      
      private var screen:Bitmap;
      
      private var _screenHeight:Number = 240;
      
      private var _fontManager:FontManager;
      
      private var fpsCount:Number;
      
      private var avgUpdateTime:Number = 0;
      
      private var mVersion:String = "v0.0";
      
      private var mSoundManager:SoundManager;
      
      private var mDebugInfo:TextField;
      
      private var mAppId:String = "";
      
      private var mShowDebugInfo:Boolean = false;
      
      private var mUpdateHooks:Array;
      
      private var _stateManager:CStateManager;
      
      private var mSaveDataSO:SharedObject = null;
      
      private var mServiceMap:Dictionary;
      
      private var mDoStep:Boolean = false;
      
      private var _widgetManager:CWidgetManager;
      
      private var mCheats:Dictionary;
      
      private var initialized:Boolean = false;
      
      private var mMusicManager:MusicManager;
      
      private var mReferences:Dictionary;
      
      private var mImageManager:ImageManager;
      
      protected var mDataXML:XML = null;
      
      private var avgTaskTime:Number = 0;
      
      public var mMasterMute:Boolean = false;
      
      private var lastFlashTime:Number;
      
      private var mStringManager:StringManager;
      
      private var avgRenderTime:Number = 0;
      
      private var _screenWidth:Number = 320;
      
      private var mMuted:Boolean = false;
      
      public function AppBase(id:String)
      {
         this.mPlugins = new Vector.<BaseAppPlugin>();
         this.mServiceMap = new Dictionary(false);
         this.mReferences = new Dictionary(true);
         this.mCheats = new Dictionary(true);
         this.mCheatBindings = new Dictionary();
         this.mUpdateHooks = [];
         super();
         if(id == null || id.length == 0)
         {
            throw new ArgumentError("You must specify an application id.");
         }
         this.mAppId = id;
         this.registerCheat("toggleDebug",this.toggleDebug);
         this.registerCheat("globalPause",this.globalPause);
         this.registerCheat("stepUpdates",this.stepUpdates);
         this.registerCheat("resumeUpdates",this.resumeUpdates);
         this.registerCheat("slowerUpdates",this.slowerUpdates);
         this.registerCheat("fasterUpdates",this.fasterUpdates);
      }
      
      public static function log(msg:String, level:String = "Loading") : void
      {
         if(level == "Loading")
         {
            return;
         }
         trace("[" + level + "]: " + msg);
      }
      
      private function handleStringsLoaded(e:Event) : void
      {
         var loader:URLLoader = new URLLoader();
         var dataURL:URLRequest = new URLRequest("data.xml");
         loader.addEventListener(Event.COMPLETE,this.handleDataLoaded);
         loader.load(dataURL);
      }
      
      protected function handleMouseUp(e:MouseEvent) : void
      {
         this._widgetManager.doMouseUp(e.stageX,e.stageY);
      }
      
      protected function handleMouseMove(e:MouseEvent) : void
      {
         this._widgetManager.doMouseMove(e.stageX,e.stageY);
      }
      
      public function togglePause(isPaused:Boolean) : void
      {
         if(isPaused)
         {
            this.mPaused = true;
            this.musicManager.pauseMusic();
            this.soundManager.pauseAll();
         }
         else
         {
            this.mPaused = false;
            this.musicManager.resumeMusic();
            this.soundManager.resumeAll();
         }
      }

      public function addUpdateHook(hook:Function) : void
      {
         this.mUpdateHooks.push(hook);
      }
      
      public function init() : void
      {
         if(this.initialized)
         {
            return;
         }
         this.mCodeMap = new Dictionary();
         this.mCodeMap["UP"] = Keyboard.UP;
         this.mCodeMap["DOWN"] = Keyboard.DOWN;
         this.mCodeMap["LEFT"] = Keyboard.LEFT;
         this.mCodeMap["RIGHT"] = Keyboard.RIGHT;
         this.mCodeMap["SHIFT"] = Keyboard.SHIFT;
         this.mCodeMap["CONTROL"] = Keyboard.CONTROL;
         this.mCodeMap["TAB"] = Keyboard.TAB;
         this.mCodeMap["CAPS_LOCK"] = Keyboard.CAPS_LOCK;
         this.mCodeMap["ENTER"] = Keyboard.ENTER;
         this.mCodeMap["ESCAPE"] = Keyboard.ESCAPE;
         this.mCodeMap["END"] = Keyboard.END;
         this.mCodeMap["HOME"] = Keyboard.HOME;
         this.mCodeMap["INSERT"] = Keyboard.INSERT;
         this.mCodeMap["PAGE_UP"] = Keyboard.PAGE_UP;
         this.mCodeMap["PAGE_DOWN"] = Keyboard.PAGE_DOWN;
         this.mCodeMap["DELETE"] = Keyboard.DELETE;
         this.mCodeMap["F1"] = Keyboard.F1;
         this.mCodeMap["F2"] = Keyboard.F2;
         this.mCodeMap["F3"] = Keyboard.F3;
         this.mCodeMap["F4"] = Keyboard.F4;
         this.mCodeMap["F5"] = Keyboard.F5;
         this.mCodeMap["F6"] = Keyboard.F6;
         this.mCodeMap["F7"] = Keyboard.F7;
         this.mCodeMap["F8"] = Keyboard.F8;
         this.mCodeMap["F9"] = Keyboard.F9;
         this.mCodeMap["F11"] = Keyboard.F11;
         this.mCodeMap["F12"] = Keyboard.F12;
         this.mCodeMap["F13"] = Keyboard.F13;
         this.mCodeMap["F14"] = Keyboard.F14;
         this.mCodeMap["F15"] = Keyboard.F15;
         this.mCodeMap["NUMPAD_0"] = Keyboard.NUMPAD_0;
         this.mCodeMap["NUMPAD_1"] = Keyboard.NUMPAD_1;
         this.mCodeMap["NUMPAD_2"] = Keyboard.NUMPAD_2;
         this.mCodeMap["NUMPAD_3"] = Keyboard.NUMPAD_3;
         this.mCodeMap["NUMPAD_4"] = Keyboard.NUMPAD_4;
         this.mCodeMap["NUMPAD_5"] = Keyboard.NUMPAD_5;
         this.mCodeMap["NUMPAD_6"] = Keyboard.NUMPAD_6;
         this.mCodeMap["NUMPAD_7"] = Keyboard.NUMPAD_7;
         this.mCodeMap["NUMPAD_8"] = Keyboard.NUMPAD_8;
         this.mCodeMap["NUMPAD_9"] = Keyboard.NUMPAD_9;
         this.mCodeMap["NUMPAD_MULTIPLY"] = Keyboard.NUMPAD_MULTIPLY;
         this.mCodeMap["NUMPAD_ADD"] = Keyboard.NUMPAD_ADD;
         this.mCodeMap["NUMPAD_ENTER"] = Keyboard.NUMPAD_ENTER;
         this.mCodeMap["NUMPAD_SUBTRACT"] = Keyboard.NUMPAD_SUBTRACT;
         this.mCodeMap["NUMPAD_DECIMAL"] = Keyboard.NUMPAD_DECIMAL;
         this.mCodeMap["NUMPAD_DIVIDE"] = Keyboard.NUMPAD_DIVIDE;
         this.mCodeMap["0"] = 48;
         this.mCodeMap["1"] = 49;
         this.mCodeMap["2"] = 50;
         this.mCodeMap["3"] = 51;
         this.mCodeMap["4"] = 52;
         this.mCodeMap["5"] = 53;
         this.mCodeMap["6"] = 54;
         this.mCodeMap["7"] = 55;
         this.mCodeMap["8"] = 56;
         this.mCodeMap["9"] = 57;
         this.mCodeMap["A"] = 65;
         this.mCodeMap["B"] = 66;
         this.mCodeMap["C"] = 67;
         this.mCodeMap["D"] = 68;
         this.mCodeMap["E"] = 69;
         this.mCodeMap["F"] = 70;
         this.mCodeMap["G"] = 71;
         this.mCodeMap["H"] = 72;
         this.mCodeMap["I"] = 73;
         this.mCodeMap["J"] = 74;
         this.mCodeMap["K"] = 75;
         this.mCodeMap["L"] = 76;
         this.mCodeMap["M"] = 77;
         this.mCodeMap["N"] = 78;
         this.mCodeMap["O"] = 79;
         this.mCodeMap["P"] = 80;
         this.mCodeMap["Q"] = 81;
         this.mCodeMap["R"] = 82;
         this.mCodeMap["S"] = 83;
         this.mCodeMap["T"] = 84;
         this.mCodeMap["U"] = 85;
         this.mCodeMap["V"] = 86;
         this.mCodeMap["W"] = 87;
         this.mCodeMap["X"] = 88;
         this.mCodeMap["Y"] = 89;
         this.mCodeMap["Z"] = 90;
         this.mCodeMap[";"] = 186;
         this.mCodeMap[":"] = 186;
         this.mCodeMap["="] = 187;
         this.mCodeMap["+"] = 187;
         this.mCodeMap["-"] = 189;
         this.mCodeMap["_"] = 189;
         this.mCodeMap["/"] = 191;
         this.mCodeMap["?"] = 191;
         this.mCodeMap["`"] = 192;
         this.mCodeMap["~"] = 192;
         this.mCodeMap["["] = 219;
         this.mCodeMap["{"] = 219;
         this.mCodeMap["\\"] = 220;
         this.mCodeMap["|"] = 220;
         this.mCodeMap["]"] = 221;
         this.mCodeMap["}"] = 221;
         this.mCodeMap["\'"] = 222;
         this.mCodeMap[","] = 188;
         this.mCodeMap["<"] = 188;
         this.mCodeMap["."] = 190;
         this.mCodeMap[">"] = 190;
         stage.frameRate = 1000;
         stage.quality = StageQuality.BEST;
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel);
         stage.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         stage.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyUp);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
         this.screenRect = new Rectangle(0,0,this._screenWidth,this._screenHeight);
         this.destPt = new Point(0,0);
         this.bufferData = new BitmapData(this._screenWidth,this._screenHeight,false);
         this.screenData = new BitmapData(this._screenWidth,this._screenHeight,false);
         this.screen = new Bitmap(this.screenData);
         this.screenGraphics = new Graphics2D(this.bufferData);
         this._widgetManager = new CWidgetManager(this);
         this._resourceManager = new ResourceManager(this);
         this._stateManager = new CStateManager();
         this.mMusicManager = new MusicManager(this);
         this.mImageManager = new ImageManager(this);
         this.mSoundManager = new SoundManager(this);
         this._fontManager = new FontManager(this);
         this.mStringManager = new StringManager(this);
         this.canvas = new Sprite();
         this.canvas.useHandCursor = false;
         this.canvas.buttonMode = true;
         this.canvas.tabEnabled = false;
         this.canvas.addChild(this.screen);
         this.canvas.width = this._appWidth;
         this.canvas.height = this._appHeight;
         addChild(this.canvas);
         this.mDebugInfo = new TextField();
         this.mDebugInfo.textColor = 16777215;
         this.mDebugInfo.filters = [new GlowFilter(0,1,4,4,10)];
         this.mDebugInfo.selectable = false;
         this.mDebugInfo.width = 540;
         this.mDebugInfo.height = 20;
         this.mDebugInfo.y = 385;
         this.fpsCount = 0;
         this.initialized = true;
         this.load();
      }
      
      protected function handleKeyUp(e:KeyboardEvent) : void
      {
         this._widgetManager.doKeyUp(e.keyCode);
      }
      
      private function globalPause() : void
      {
         this.togglePause(!this.mPaused);
      }
      
      protected function handleMouseWheel(e:MouseEvent) : void
      {
         this._widgetManager.doMouseWheel(e.delta);
      }
      
      public function get appWidth() : Number
      {
         return this._appWidth;
      }
      
      private function handleFrame(e:Event) : void
      {
         var plugin:BaseAppPlugin = null;
         var thisTime:Number = NaN;
         var elapsed:Number = NaN;
         stage.quality = StageQuality.BEST;
         for each(plugin in this.mPlugins)
         {
            if(!plugin.isLoaded())
            {
               return;
            }
         }
         thisTime = getTimer();
         elapsed = thisTime - this.lastUpdateTime;
         this.lastUpdateTime = getTimer();
         this.avgFlashTime = this.avgFlashTime + (thisTime - this.lastFlashTime);
         this.excessUpdateTime = this.excessUpdateTime + elapsed;
         if(this.mShowDebugInfo)
         {
            this.fpsTime = this.fpsTime + elapsed;
            while(this.fpsTime >= 1000)
            {
               this.fpsTime = this.fpsTime - 1000;
               if(this.fpsCount > 0)
               {
                  this.avgUpdateTime = Math.round(this.avgUpdateTime / this.fpsCount);
                  this.avgRenderTime = Math.round(this.avgRenderTime / this.fpsCount);
                  this.avgTaskTime = Math.round(this.avgTaskTime / this.fpsCount);
                  this.avgFlashTime = Math.round(this.avgFlashTime / this.fpsCount);
               }
               this.mDebugInfo.text = this.mVersion + " ";
               this.mDebugInfo.appendText("[FPS: " + this.fpsCount);
               this.mDebugInfo.appendText("] [Avg. Update Time: " + this.avgUpdateTime);
               this.mDebugInfo.appendText("] [Avg. Render Time: " + this.avgRenderTime);
               this.mDebugInfo.appendText("] [Avg. Task Time: " + this.avgTaskTime);
               this.mDebugInfo.appendText("] [Avg. Flash Time: " + this.avgFlashTime + "]");
               if(this.fpsCount > 0)
               {
                  this.avgUpdateTime = 0;
                  this.avgRenderTime = 0;
                  this.avgTaskTime = 0;
                  this.avgFlashTime = 0;
               }
               this.fpsCount = 0;
            }
         }
         var startTime:Number = getTimer();
         while(this.excessUpdateTime >= UPDATE_STEP_TIME)
         {
            this.updateStep();
            this.excessUpdateTime = this.excessUpdateTime - UPDATE_STEP_TIME;
         }
         this.avgUpdateTime = this.avgUpdateTime + (getTimer() - startTime);
         startTime = getTimer();
         this.renderStep();
         this.avgRenderTime = this.avgRenderTime + (getTimer() - startTime);
         this.fpsCount++;
         this.lastFlashTime = getTimer();
         if(this.canvas.useHandCursor != this.widgetManager.mShowFinger)
         {
            this.canvas.useHandCursor = this.widgetManager.mShowFinger;
            Mouse.hide();
            Mouse.show();
         }
      }

      private function updateStep() : void
      {
         var k:int = 0;
         var hook:Function = null;
         if(this.mUpdatesPaused && !this.mDoStep)
         {
            return;
         }
         this.mDoStep = false;
         for(var i:int = 0; i < this.mStepsPerTick; i++)
         {
            for(k = 0; k < this.mUpdateHooks.length; k++)
            {
               hook = this.mUpdateHooks[k];
               hook();
            }
            this.musicManager.update();
            this._stateManager.update();
         }
      }
      
      public function getProperties() : XML
      {
         return this.mDataXML;
      }
      
      private function getSO() : SharedObject
      {
         if(this.mSaveDataSO == null)
         {
            this.mSaveDataSO = SharedObject.getLocal(this.mAppId);
         }
         return this.mSaveDataSO;
      }
      
      public function getSaveData() : Object
      {
         var so:SharedObject = null;
         var bytes:ByteArray = null;
         if(this.mSaveData != null)
         {
            return this.mSaveData;
         }
         if(!this.canLoadData())
         {
            this.mSaveData = {};
         }
         else
         {
            so = this.getSO();
            bytes = new ByteArray();
            bytes.writeObject(so.data.saveData);
            bytes.position = 0;
            this.mSaveData = bytes.readObject();
            if(this.mSaveData == null)
            {
               this.mSaveData = {};
            }
         }
         return this.mSaveData;
      }
      
      public function setSaveData(data:Object) : void
      {
         this.mSaveData = data;
         if(!this.canSaveData())
         {
            return;
         }
         var so:SharedObject = this.getSO();
         var bytes:ByteArray = new ByteArray();
         bytes.writeObject(this.mSaveData);
         bytes.position = 0;
         so.data.saveData = bytes.readObject();
         so.setProperty("saveData",data);
         so.flush();
      }
      
      public function set appWidth(value:Number) : void
      {
         if(this.initialized)
         {
            return;
         }
         if(value <= 0)
         {
            throw new ArgumentError("Application width must be >= 1");
         }
         this._appWidth = value;
      }
      
      public function set appHeight(value:Number) : void
      {
         if(this.initialized)
         {
            return;
         }
         if(value <= 0)
         {
            throw new ArgumentError("Application height must be >= 1");
         }
         this._appHeight = value;
      }
      
      protected function handleKeyDown(e:KeyboardEvent) : void
      {
         var code:* = 0;
         var key:String = null;
         var cheatFunc:Function = null;
         var cheatsEnabled:Boolean = AppUtils.asBoolean(this.getProperties().cheats.enabled);
         if(cheatsEnabled)
         {
            code = e.keyCode << 3;
            if(e.ctrlKey)
            {
               code = code | CONTROL_FLAG;
            }
            if(e.altKey)
            {
               code = code | ALT_FLAG;
            }
            if(e.shiftKey)
            {
               code = code | SHIFT_FLAG;
            }
            key = this.mCheatBindings[code];
            if(key != null)
            {
               cheatFunc = this.mCheats[key];
               if(cheatFunc != null)
               {
                  cheatFunc();
               }
            }
         }
         this._widgetManager.doKeyDown(e.keyCode);
         this._widgetManager.doKeyChar(e.charCode);
      }
      
      public function get stringManager() : StringManager
      {
         return this.mStringManager;
      }
      
      private function toggleDebug() : void
      {
         this.mShowDebugInfo = !this.mShowDebugInfo;
         if(this.mShowDebugInfo)
         {
            this.mDebugInfo.text = "Calculating...";
            addChild(this.mDebugInfo);
         }
         else
         {
            removeChild(this.mDebugInfo);
         }
      }

      public function start() : void
      {
         this.mVersion = "v" + this.mDataXML.version.major + "." + this.mDataXML.version.minor;
         var numBindings:int = this.mDataXML.cheats.bind.length();
         for(var i:int = 0; i < numBindings; i++)
         {
            this.addBinding(this.mDataXML.cheats.bind[i]);
         }
         this.fpsTime = 0;
         this.excessUpdateTime = 0;
         this.lastUpdateTime = getTimer();
         this.lastFlashTime = this.lastUpdateTime;
         addEventListener(Event.ENTER_FRAME,this.handleFrame);
      }
      
      public function set screenHeight(value:Number) : void
      {
         if(this.initialized)
         {
            return;
         }
         if(value <= 0)
         {
            throw new ArgumentError("Screen height must be >= 1");
         }
         this._screenHeight = value;
      }
      
      public function getServiceReferences(clazz:String) : Vector.<IAppServiceReference>
      {
         var registration:BaseAppServiceRegistration = null;
         var reference:IAppServiceReference = null;
         var references:Vector.<IAppServiceReference> = new Vector.<IAppServiceReference>();
         var services:Array = this.mServiceMap[clazz];
         if(services == null)
         {
            return references;
         }
         for each(registration in services)
         {
            reference = registration.getReference();
            this.mReferences[reference] = registration.getService();
            references.push(reference);
         }
         return references;
      }
      
      public function getPlugins() : Vector.<IAppPlugin>
      {
         return this.mPlugins.slice();
      }
      
      public function get fontManager() : FontManager
      {
         return this._fontManager;
      }
      
      private function slowerUpdates() : void
      {
         this.mStepsPerTick = Math.max(1,this.mStepsPerTick - 1);
      }
      
      public function getService(reference:IAppServiceReference) : Object
      {
         return this.mReferences[reference];
      }
      
      private function fasterUpdates() : void
      {
         this.mStepsPerTick = Math.min(30,this.mStepsPerTick + 1);
      }
      
      private function renderStep() : void
      {
         this.screenGraphics.reset();
         this._stateManager.draw(this.screenGraphics);
         this.screenData.lock();
         this.screenData.copyPixels(this.bufferData,this.screenRect,this.destPt);
         this.screenData.unlock();
      }
      
      public function set screenWidth(value:Number) : void
      {
         if(this.initialized)
         {
            return;
         }
         if(value <= 0)
         {
            throw new ArgumentError("Screen width must be >= 1");
         }
         this._screenWidth = value;
      }
      
      public function toggleMute(isMuted:Boolean, masterMute:Boolean = false) : void
      {
         if(masterMute)
         {
            this.mMasterMute = isMuted;
         }
         isMuted = isMuted || this.mMasterMute;
         if(isMuted)
         {
            this.mMuted = true;
            this.musicManager.mute();
            this.soundManager.mute();
         }
         else
         {
            this.mMuted = false;
            this.musicManager.unmute();
            this.soundManager.unmute();
         }
      }

      private function handleDataLoaded(e:Event) : void
      {
         var properties:XML = null;
         var plugin:BaseAppPlugin = null;
         var loader:URLLoader = e.target as URLLoader;
         loader.removeEventListener(Event.COMPLETE,this.handleDataLoaded);
         var xml:XML = new XML(e.target.data);
         this.mDataXML = xml;
         var len:int = xml.Plugins.Plugin.length();
         for(var i:int = 0; i < len; i++)
         {
            properties = xml.Plugins.Plugin[i];
            plugin = new BaseAppPlugin(this,properties);
            this.mPlugins.push(plugin);
            plugin.load();
         }
         this.start();
      }
      
      public function registerService(plugin:BaseAppPlugin, classes:Vector.<String>, service:Object, properties:XML) : IAppServiceRegistration
      {
         var clazz:String = null;
         var services:Vector.<BaseAppServiceRegistration> = null;
         var registration:BaseAppServiceRegistration = new BaseAppServiceRegistration(this,plugin,classes,service,properties);
         for each(clazz in classes)
         {
            services = this.mServiceMap[clazz];
            if(services == null)
            {
               services = new Vector.<BaseAppServiceRegistration>();
            }
            if(services.indexOf(service) < 0)
            {
               services.push(registration);
            }
         }
         return registration;
      }
      
      public function get soundManager() : SoundManager
      {
         return this.mSoundManager;
      }
      
      public function canLoadData() : Boolean
      {
         return AppUtils.asBoolean(this.mDataXML.saveData.canLoad,true);
      }
      
      private function addBinding(binding:XML) : void
      {
         var piece:String = null;
         var matcher:String = null;
         var combo:String = binding.@keyCombo;
         var code:int = this.mCodeMap[combo];
         if(code > 0)
         {
            this.mCheatBindings[code << 3] = binding.toString();
            return;
         }
         var pieces:Array = combo.split("+");
         var modifiers:* = 0;
         for each(piece in pieces)
         {
            matcher = piece.toUpperCase();
            if(matcher == "CONTROL")
            {
               modifiers = modifiers | CONTROL_FLAG;
            }
            else if(matcher == "ALT")
            {
               modifiers = modifiers | ALT_FLAG;
            }
            else if(matcher == "SHIFT")
            {
               modifiers = modifiers | SHIFT_FLAG;
            }
            else
            {
               code = this.mCodeMap[matcher];
               if(code == 0)
               {
                  return;
               }
            }
         }
         this.mCheatBindings[code << 3 | modifiers] = binding.toString();
      }
      
      protected function handleMouseDown(e:MouseEvent) : void
      {
         this._widgetManager.doMouseDown(e.stageX,e.stageY);
      }
      
      public function get screenHeight() : Number
      {
         return this._screenHeight;
      }
      
      protected function handleMouseOut(e:MouseEvent) : void
      {
      }
      
      public function get screenWidth() : Number
      {
         return this._screenWidth;
      }
      
      public function get resourceManager() : ResourceManager
      {
         return this._resourceManager;
      }
      
      public function get widgetManager() : CWidgetManager
      {
         return this._widgetManager;
      }
      
      public function get musicManager() : MusicManager
      {
         return this.mMusicManager;
      }
      
      private function stepUpdates() : void
      {
         if(this.mUpdatesPaused)
         {
            this.mDoStep = true;
         }
         this.mUpdatesPaused = true;
      }
      
      public function get imageManager() : ImageManager
      {
         return this.mImageManager;
      }
      
      public function canSaveData() : Boolean
      {
         return AppUtils.asBoolean(this.mDataXML.saveData.canSave,true);
      }
      
      private function resumeUpdates() : void
      {
         this.mUpdatesPaused = false;
      }
      
      public function get appHeight() : Number
      {
         return this._appHeight;
      }
      
      public function get stateManager() : IStateManager
      {
         return this._stateManager;
      }
      
      protected function handleMouseOver(e:MouseEvent) : void
      {
         this._widgetManager.onMouseEnter();
      }
      
      private function load() : void
      {
         this.stringManager.addEventListener(Event.COMPLETE,this.handleStringsLoaded);
         this.stringManager.loadStrings("properties/externalStrings.txt");
      }
      
      public function registerCheat(key:String, callback:Function) : void
      {
         this.mCheats[key] = callback;
      }
      
      public function get isPaused() : Boolean
      {
         return this.mPaused;
      }
      
      public function ungetService(reference:IAppServiceReference) : void
      {
         throw new Error("Unimplemented stub method.");
      }
   }
}
