package com.popcap.flash.framework.widgets
{
   import com.popcap.flash.framework.AppBase;
   import com.popcap.flash.framework.graphics.Graphics2D;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   
   public class CWidgetManager extends CWidgetContainer
   {
      
      public static const WIDGETFLAGS_DRAW:Number = 4;
      
      public static const WIDGETFLAGS_UPDATE:Number = 1;
      
      public static const WIDGETFLAGS_CLIP:Number = 8;
      
      public static const WIDGETFLAGS_ALLOW_FOCUS:Number = 32;
      
      public static const WIDGETFLAGS_ALLOW_MOUSE:Number = 16;
      
      public static const WIDGETFLAGS_MARK_DIRTY:Number = 2;
       
      
      public var minDeferredOverlayPriority:Number = 0;
      
      public var deferredOverlayWidgets:Array;
      
      public var lastMouseX:Number = 0;
      
      public var lastMouseY:Number = 0;
      
      public var mShowFinger:Boolean = false;
      
      public var belowModalFlagsMod:CFlagsMod;
      
      public var defaultTab:CWidget = null;
      
      public var keyDown:Array;
      
      public var popupCommandWidget:CWidget;
      
      public var app:AppBase;
      
      public var mouseIn:Boolean = true;
      
      public var lostFocusFlagsMod:CFlagsMod;
      
      public var widgetFlags:Number = 0;
      
      public var overWidget:CWidget;
      
      public var lastDownWidget:CWidget;
      
      public var defaultBelowModalFlagsMod:CFlagsMod;
      
      public var baseModalWidget:CWidget;
      
      public var focusWidget:CWidget;
      
      public var lastInputUpdateCount:Number = 0;
      
      public var preModalInfoList:Array;
      
      private var modalFlags:CModalFlags;
      
      public var hasFocus:Boolean = true;
      
      public var downButtons:Number = 0;
      
      public function CWidgetManager(app:AppBase)
      {
         this.modalFlags = new CModalFlags();
         this.keyDown = new Array();
         this.deferredOverlayWidgets = new Array();
         this.preModalInfoList = new Array();
         this.lostFocusFlagsMod = new CFlagsMod();
         this.belowModalFlagsMod = new CFlagsMod();
         this.defaultBelowModalFlagsMod = new CFlagsMod();
         super();
         this.app = app;
         widgetManager = this;
         this.widgetFlags = WIDGETFLAGS_UPDATE | WIDGETFLAGS_DRAW | WIDGETFLAGS_CLIP | WIDGETFLAGS_ALLOW_MOUSE | WIDGETFLAGS_ALLOW_FOCUS;
         for(var i:int = 0; i < 255; i++)
         {
            this.keyDown[i] = false;
         }
      }
      
      public function getWidgetAt(x:Number, y:Number, localPos:Point) : CWidget
      {
         var w:CWidget = this.getAnyWidgetAt(x,y,localPos);
         if(w != null && w.disabled)
         {
            w = null;
         }
         return w;
      }
      
      public function doKeyUp(keyCode:uint) : void
      {
         this.lastInputUpdateCount = updateCount;
         this.keyDown[keyCode] = false;
         if(keyCode == Keyboard.TAB && this.keyDown[Keyboard.CONTROL])
         {
            return;
         }
         if(this.focusWidget != null)
         {
            this.focusWidget.onKeyUp(keyCode);
         }
      }
      
      public function initModalFlags(modalFlags:CModalFlags) : void
      {
         modalFlags.isOver = this.baseModalWidget == null;
         modalFlags.overFlags = this.getWidgetFlags();
         modalFlags.underFlags = CFlagsMod.getModFlags(modalFlags.overFlags,this.belowModalFlagsMod);
      }
      
      public function rehupMouse() : void
      {
         var widget:CWidget = null;
         var tmpWidget:CWidget = null;
         if(this.lastDownWidget != null)
         {
            if(this.overWidget != null)
            {
               widget = this.getWidgetAt(this.lastMouseX,this.lastMouseY,new Point());
               if(widget != this.lastDownWidget)
               {
                  tmpWidget = this.overWidget;
                  this.overWidget = null;
                  this.doMouseLeave(tmpWidget);
               }
            }
         }
         else if(this.mouseIn)
         {
            this.setMousePosition(this.lastMouseX,this.lastMouseY);
         }
      }
      
      public function doMouseUps(widget:CWidget = null, downCode:Number = 0) : void
      {
         if(widget == null)
         {
            if(this.lastDownWidget != null && this.downButtons != 0)
            {
               this.doMouseUps(this.lastDownWidget,this.downButtons);
               this.downButtons = 0;
               this.lastDownWidget = null;
            }
            return;
         }
         widget.isDown = false;
         widget.onMouseUp(this.lastMouseX - widget.x,this.lastMouseY - widget.y);
      }
      
      public function doMouseExit(x:Number, y:Number) : void
      {
         this.lastInputUpdateCount = updateCount;
         this.mouseIn = false;
         if(this.overWidget != null)
         {
            this.doMouseLeave(this.overWidget);
            this.overWidget = null;
         }
      }
      
      public function setBaseModal(widget:CWidget, flagsMod:CFlagsMod) : void
      {
         var aDownButtons:Number = NaN;
         this.baseModalWidget = widget;
         this.belowModalFlagsMod = flagsMod;
         var tmpWidget:CWidget = null;
         if(this.overWidget != null && this.belowModalFlagsMod.removeFlags & WIDGETFLAGS_ALLOW_MOUSE && isBelow(this.overWidget,this.baseModalWidget))
         {
            tmpWidget = this.overWidget;
            this.overWidget = null;
            this.doMouseLeave(tmpWidget);
         }
         if(this.lastDownWidget != null && this.belowModalFlagsMod.removeFlags & WIDGETFLAGS_ALLOW_MOUSE && isBelow(this.lastDownWidget,this.baseModalWidget))
         {
            tmpWidget = this.lastDownWidget;
            aDownButtons = this.downButtons;
            this.downButtons = 0;
            this.lastDownWidget = null;
            this.doMouseUps(tmpWidget,aDownButtons);
         }
         if(this.focusWidget != null && this.belowModalFlagsMod.removeFlags & WIDGETFLAGS_ALLOW_FOCUS && isBelow(this.focusWidget,this.baseModalWidget))
         {
            tmpWidget = this.focusWidget;
            this.focusWidget = null;
            tmpWidget.lostFocus();
         }
      }
      
      public function doMouseUp(x:Number, y:Number) : void
      {
         var widget:CWidget = null;
         this.lastInputUpdateCount = updateCount;
         if(this.lastDownWidget != null && this.downButtons != 0)
         {
            widget = this.lastDownWidget;
            this.downButtons = 0;
            this.lastDownWidget = null;
            widget.isDown = false;
            widget.onMouseUp(x - widget.x,y - widget.y);
         }
         this.setMousePosition(x,y);
      }
      
      override public function setFocus(widget:CWidget) : void
      {
         if(widget == this.focusWidget)
         {
            return;
         }
         if(this.focusWidget != null)
         {
            this.focusWidget.lostFocus();
         }
         if(widget != null && widget.widgetManager == this)
         {
            this.focusWidget = widget;
            if(this.hasFocus && this.focusWidget != null)
            {
               this.focusWidget.gotFocus();
            }
         }
         else
         {
            this.focusWidget = null;
         }
      }
      
      public function doMouseEnter(widget:CWidget) : void
      {
         widget.isOver = true;
         widget.onMouseEnter();
         if(widget.doFinger)
         {
            widget.showFinger(true);
         }
      }
      
      public function deferOverlay(widget:CWidget, priority:Number) : void
      {
         var o:Object = new Object();
         o.widget = widget;
         o.priority = priority;
         this.deferredOverlayWidgets.push(o);
         if(priority < this.minDeferredOverlayPriority)
         {
            this.minDeferredOverlayPriority = priority;
         }
      }
      
      public function flushDeferredOverlayWidgets(g:Graphics2D, maxPriority:Number) : void
      {
         var nextMinPriority:Number = NaN;
         var aNumWidgets:int = 0;
         var i:int = 0;
         var o:Object = null;
         var w:CWidget = null;
         var priority:Number = NaN;
         do
         {
            nextMinPriority = Number.MAX_VALUE;
            aNumWidgets = this.deferredOverlayWidgets.length;
            for(i = 0; i < aNumWidgets; i++)
            {
               o = this.deferredOverlayWidgets[i];
               w = o.widget;
               if(o.widget != null)
               {
                  priority = o.priority;
                  if(priority == this.minDeferredOverlayPriority)
                  {
                     g.pushState();
                     g.translate(w.x,w.y);
                     w.drawOverlay(g,priority);
                     g.popState();
                     o.widget = null;
                  }
                  else if(priority < nextMinPriority)
                  {
                     nextMinPriority = priority;
                  }
               }
            }
            this.minDeferredOverlayPriority = nextMinPriority;
            if(nextMinPriority == Number.MAX_VALUE)
            {
               this.deferredOverlayWidgets = new Array();
               break;
            }
         }
         while(nextMinPriority < maxPriority);
         
      }
      
      public function setPopupCommandWidget(widget:CWidget) : void
      {
         this.popupCommandWidget = widget;
         addWidget(this.popupCommandWidget);
      }
      
      public function updateFrame() : Boolean
      {
         this.initModalFlags(this.modalFlags);
         updateCount++;
         lastWMUpdateCount = updateCount;
         updateAll(this.modalFlags);
         return dirty;
      }
      
      public function doMouseWheel(delta:Number) : void
      {
         this.lastInputUpdateCount = updateCount;
         if(this.focusWidget != null)
         {
            this.focusWidget.onMouseWheel(delta);
         }
      }
      
      public function doMouseDrag(x:Number, y:Number) : void
      {
         var tmpWidget:CWidget = null;
         var absPos:Point = null;
         var localPos:Point = null;
         this.lastInputUpdateCount = updateCount;
         this.mouseIn = true;
         this.lastMouseX = x;
         this.lastMouseY = y;
         if(this.overWidget != null && this.overWidget != this.lastDownWidget)
         {
            tmpWidget = this.overWidget;
            this.overWidget = null;
            this.doMouseLeave(tmpWidget);
         }
         if(this.lastDownWidget != null)
         {
            absPos = this.lastDownWidget.getAbsPos();
            localPos = new Point(x - absPos.x,y - absPos.y);
            this.lastDownWidget.onMouseDrag(localPos.x,localPos.y);
            tmpWidget = this.getWidgetAt(x,y,new Point());
            if(tmpWidget == this.lastDownWidget && tmpWidget != null)
            {
               if(this.overWidget == null)
               {
                  this.overWidget = this.lastDownWidget;
                  this.doMouseEnter(this.overWidget);
               }
            }
            else if(this.overWidget != null)
            {
               tmpWidget = this.overWidget;
               this.overWidget = null;
               this.doMouseLeave(tmpWidget);
            }
         }
      }
      
      public function lostFocus() : void
      {
         var i:Number = NaN;
         if(this.hasFocus)
         {
            this.downButtons = 0;
            for(i = 0; i < this.keyDown.length; i++)
            {
               if(this.keyDown[i])
               {
                  onKeyUp(i);
               }
               this.hasFocus = false;
               if(this.focusWidget != null)
               {
                  this.focusWidget.lostFocus();
               }
            }
         }
      }
      
      public function addBaseModal(widget:CWidget, flagsMod:CFlagsMod) : void
      {
         var info:CPreModalInfo = new CPreModalInfo();
         info.baseModalWidget = widget;
         info.prevBaseModalWidget = this.baseModalWidget;
         info.prevFocusWidget = this.focusWidget;
         info.prevBelowModalFlagsMod = this.belowModalFlagsMod;
         this.preModalInfoList.push(info);
         this.setBaseModal(widget,flagsMod);
      }
      
      public function doMouseDown(x:Number, y:Number) : void
      {
         this.lastInputUpdateCount = updateCount;
         this.downButtons = 1;
         this.setMousePosition(x,y);
         var localPos:Point = new Point();
         var widget:CWidget = this.getWidgetAt(x,y,localPos);
         if(this.lastDownWidget != null)
         {
            widget = this.lastDownWidget;
         }
         this.lastDownWidget = widget;
         if(widget != null)
         {
            if(widget.wantsFocus)
            {
               this.setFocus(widget);
            }
            widget.isDown = true;
            widget.onMouseDown(localPos.x,localPos.y);
         }
      }
      
      public function gotFocus() : void
      {
         if(!this.hasFocus)
         {
            this.hasFocus = true;
            if(this.focusWidget != null)
            {
               this.focusWidget.gotFocus();
            }
         }
      }
      
      public function showFinger(on:Boolean, target:CWidget) : void
      {
         if(this.overWidget == target || this.overWidget == null)
         {
            this.mShowFinger = on;
         }
      }
      
      public function removeBaseModal(widget:CWidget) : void
      {
         var info:CPreModalInfo = null;
         var done:Boolean = false;
         if(this.preModalInfoList.length == 0)
         {
            throw new Error("Empty modal list.");
         }
         var first:Boolean = true;
         while(true)
         {
            if(this.preModalInfoList.length > 0)
            {
               info = this.preModalInfoList[this.preModalInfoList.length - 1];
               if(first && info.baseModalWidget != widget)
               {
                  break;
               }
               done = info.prevBaseModalWidget != null || this.preModalInfoList.length == 1;
               this.setBaseModal(info.prevBaseModalWidget,info.prevBelowModalFlagsMod);
               if(this.focusWidget == null)
               {
                  this.focusWidget = info.prevFocusWidget;
                  if(this.focusWidget != null)
                  {
                     this.focusWidget.gotFocus();
                  }
               }
               this.preModalInfoList.pop();
               if(!done)
               {
                  first = false;
                  continue;
               }
            }
            return;
         }
      }
      
      public function doKeyChar(charCode:uint) : void
      {
         this.lastInputUpdateCount = updateCount;
         if(charCode == Keyboard.TAB)
         {
            if(this.keyDown[Keyboard.CONTROL])
            {
               if(this.defaultTab != null)
               {
                  this.defaultTab.onKeyChar(charCode);
               }
               return;
            }
         }
         if(this.focusWidget != null)
         {
            this.focusWidget.onKeyChar(charCode);
         }
      }
      
      override public function disableWidget(widget:CWidget) : void
      {
         var tmpWidget:CWidget = null;
         if(this.overWidget == widget)
         {
            tmpWidget = this.overWidget;
            this.overWidget = null;
            this.doMouseLeave(tmpWidget);
         }
         if(this.lastDownWidget == widget)
         {
            tmpWidget = this.lastDownWidget;
            this.lastDownWidget = null;
            this.doMouseUps(tmpWidget,this.downButtons);
            this.downButtons = 0;
         }
         if(this.focusWidget == widget)
         {
            tmpWidget = this.focusWidget;
            this.focusWidget = null;
            tmpWidget.lostFocus();
         }
         if(this.baseModalWidget == widget)
         {
            this.baseModalWidget = null;
         }
      }
      
      public function removePopupCommandWidget() : void
      {
         var tmpWidget:CWidget = null;
         if(this.popupCommandWidget != null)
         {
            tmpWidget = this.popupCommandWidget;
            this.popupCommandWidget = null;
            removeWidget(tmpWidget);
         }
      }
      
      public function doKeyDown(keyCode:uint) : void
      {
         this.lastInputUpdateCount = updateCount;
         this.keyDown[keyCode] = true;
         if(this.focusWidget != null)
         {
            this.focusWidget.onKeyDown(keyCode);
         }
      }
      
      public function drawScreen(g:Graphics2D) : void
      {
         this.initModalFlags(this.modalFlags);
         var drewStuff:Boolean = false;
         var dirtyCount:Number = 0;
         var hasTransients:Boolean = false;
         var hasDirtyTransients:Boolean = false;
         var i:Number = 0;
         var w:CWidget = null;
         var aNumWidgets:int = widgets.length;
         for(i = 0; i < aNumWidgets; i++)
         {
            w = widgets[i];
            if(w.dirty)
            {
               dirtyCount++;
            }
         }
         this.minDeferredOverlayPriority = Number.MAX_VALUE;
         this.deferredOverlayWidgets = new Array();
         if(dirtyCount > 0)
         {
            g.pushState();
            aNumWidgets = widgets.length;
            for(i = 0; i < aNumWidgets; i++)
            {
               w = widgets[i];
               if(w == widgetManager.baseModalWidget)
               {
                  this.modalFlags.isOver = true;
               }
               if(w.dirty && w.visible)
               {
                  g.pushState();
                  g.translate(w.x,w.y);
                  w.drawAll(this.modalFlags,g);
                  g.popState();
                  dirtyCount++;
                  drewStuff = true;
               }
            }
            g.popState();
         }
         this.flushDeferredOverlayWidgets(g,Number.MAX_VALUE);
      }
      
      public function setMousePosition(x:Number, y:Number) : void
      {
         var tmpWidget:CWidget = null;
         var lastX:Number = this.lastMouseX;
         var lastY:Number = this.lastMouseY;
         this.lastMouseX = x;
         this.lastMouseY = y;
         var localPos:Point = new Point(0,0);
         var widget:CWidget = this.getWidgetAt(x,y,localPos);
         if(widget != this.overWidget)
         {
            tmpWidget = this.overWidget;
            this.overWidget = null;
            if(tmpWidget != null)
            {
               this.doMouseLeave(tmpWidget);
            }
            this.overWidget = widget;
            if(widget != null)
            {
               this.doMouseEnter(widget);
               widget.onMouseMove(localPos.x,localPos.y);
            }
         }
         else if(lastX != x || lastY != y)
         {
            if(widget != null)
            {
               widget.onMouseMove(localPos.x,localPos.y);
            }
         }
      }
      
      public function remapMouse(x:Number, y:Number) : void
      {
      }
      
      public function doMouseMove(x:Number, y:Number) : void
      {
         this.lastInputUpdateCount = updateCount;
         if(this.downButtons != 0)
         {
            this.doMouseDrag(x,y);
         }
         this.mouseIn = true;
         this.setMousePosition(x,y);
      }
      
      public function getAnyWidgetAt(x:Number, y:Number, localPos:Point) : CWidget
      {
         return getWidgetAtHelper(x,y,this.getWidgetFlags(),localPos);
      }
      
      public function getWidgetFlags() : Number
      {
         return !!this.hasFocus?Number(this.widgetFlags):Number(CFlagsMod.getModFlags(this.widgetFlags,this.lostFocusFlagsMod));
      }
      
      public function doMouseLeave(widget:CWidget) : void
      {
         widget.isOver = false;
         widget.onMouseLeave();
         if(widget.doFinger)
         {
            widget.showFinger(false);
         }
      }
   }
}
