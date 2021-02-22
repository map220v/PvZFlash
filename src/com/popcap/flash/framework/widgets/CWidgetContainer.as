package com.popcap.flash.framework.widgets
{
   import com.popcap.flash.framework.graphics.Graphics2D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class CWidgetContainer
   {
      
      public static var depthCount:Number = 0;
       
      
      public var y:Number = 0;
      
      public var height:Number = 0;
      
      public var parent:CWidgetContainer = null;
      
      public var priority:Number = 0;
      
      public var widgets:Array;
      
      public var lastWMUpdateCount:Number = 0;
      
      public var width:Number = 0;
      
      public var widgetManager:CWidgetManager = null;
      
      public var updateCount:Number = 0;
      
      public var clip:Boolean = true;
      
      public var dirty:Boolean = false;
      
      public var hasAlpha:Boolean = false;
      
      public var zOrder:Number = 0;
      
      public var x:Number = 0;
      
      public function CWidgetContainer()
      {
         this.widgets = new Array();
         super();
         this.x = 0;
         this.y = 0;
         this.width = 0;
         this.height = 0;
         this.parent = null;
         this.widgetManager = null;
         this.dirty = false;
         this.hasAlpha = false;
         this.clip = true;
         this.priority = 0;
         this.zOrder = 0;
      }
      
      public function onMouseEnter() : void
      {
      }
      
      public function markDirty(container:CWidgetContainer = null) : void
      {
         var found:Boolean = false;
         var aNumWidgets:int = 0;
         var i:int = 0;
         var w:CWidget = null;
         if(container == null)
         {
            if(this.parent != null)
            {
               this.parent.markDirty(this);
            }
            else
            {
               this.dirty = true;
            }
            return;
         }
         if(container.dirty == true)
         {
            return;
         }
         this.markDirty();
         container.dirty = true;
         if(this.parent != null)
         {
            return;
         }
         if(container.hasAlpha)
         {
            this.markDirtyFull(container);
         }
         else
         {
            found = false;
            aNumWidgets = this.widgets.length;
            for(i = 0; i < aNumWidgets; i++)
            {
               w = this.widgets[i];
               if(w == container)
               {
                  found = true;
               }
               else if(found)
               {
                  if(w.visible == true && w.intersects(container))
                  {
                     this.markDirty(w);
                  }
               }
            }
         }
      }
      
      public function sysColorChangesAll() : void
      {
         var w:CWidget = null;
         this.sysColorChanged();
         depthCount = 0;
         if(this.widgets.length > 0)
         {
            depthCount++;
         }
         var aNumWidgets:int = this.widgets.length;
         for(var i:int = 0; i < aNumWidgets; i++)
         {
            w = this.widgets[i];
            w.sysColorChangesAll();
         }
      }
      
      public function putInfront(widget:CWidget, reference:CWidget) : void
      {
         var w:CWidget = null;
         var index:Number = this.widgets.indexOf(widget);
         if(index < 0)
         {
            return;
         }
         var aNumWidgets:int = this.widgets.length;
         for(var i:int = 0; i < aNumWidgets; i++)
         {
            w = this.widgets[i];
            if(w == reference)
            {
               this.widgets = this.widgets.splice(i,0,widget);
               return;
            }
         }
      }
      
      public function setFocus(widget:CWidget) : void
      {
      }
      
      public function updateAll(flags:CModalFlags) : void
      {
         var w:CWidget = null;
         if(flags.getFlags() & CWidgetManager.WIDGETFLAGS_MARK_DIRTY)
         {
            this.markDirty();
         }
         if(this.widgetManager == null)
         {
            return;
         }
         if(flags.getFlags() & CWidgetManager.WIDGETFLAGS_UPDATE)
         {
            if(this.lastWMUpdateCount != this.widgetManager.updateCount)
            {
               this.lastWMUpdateCount = this.widgetManager.updateCount;
               this.update();
            }
         }
         var aNumWidgets:int = this.widgets.length;
         for(var i:int = 0; i < aNumWidgets; i++)
         {
            w = this.widgets[i];
            if(w == this.widgetManager.baseModalWidget)
            {
               flags.isOver = true;
            }
            w.updateAll(flags);
         }
      }
      
      public function addedToManager(manager:CWidgetManager) : void
      {
         var w:CWidget = null;
         var aNumWidgets:int = this.widgets.length;
         for(var i:int = 0; i < aNumWidgets; i++)
         {
            w = this.widgets[i];
            w.widgetManager = manager;
            w.addedToManager(manager);
            this.markDirty();
         }
      }
      
      public function getWidgetAtHelper(x:Number, y:Number, flags:Number, local:Point) : CWidget
      {
         var widget:CWidget = null;
         var child:CWidget = null;
         var aNumWidgets:int = this.widgets.length;
         for(var i:int = aNumWidgets - 1; i >= 0; i--)
         {
            widget = this.widgets[i];
            if(widget.visible)
            {
               child = widget.getWidgetAtHelper(x,y,flags,local);
               if(child != null)
               {
                  return child;
               }
               if(widget.contains(x,y))
               {
                  local.x = x - widget.x;
                  local.y = y - widget.y;
                  return widget;
               }
            }
         }
         return null;
      }
      
      public function markAllDirty() : void
      {
         var w:CWidget = null;
         this.markDirty();
         var aNumWidgets:int = this.widgets.length;
         for(var i:int = 0; i < aNumWidgets; i++)
         {
            w = this.widgets[i];
            w.dirty = true;
            w.markAllDirty();
         }
      }
      
      public function removedFromManager(manager:CWidgetManager) : void
      {
         var w:CWidget = null;
         var aNumWidgets:int = this.widgets.length;
         for(var i:int = 0; i < aNumWidgets; i++)
         {
            w = this.widgets[i];
            manager.disableWidget(w);
            w.removedFromManager(manager);
            w.widgetManager = null;
         }
         if(manager.popupCommandWidget == this)
         {
            manager.popupCommandWidget = null;
         }
      }
      
      public function putBehind(widget:CWidget, reference:CWidget) : void
      {
         var w:CWidget = null;
         var index:Number = this.widgets.indexOf(widget);
         if(index < 0)
         {
            return;
         }
         var aNumWidgets:int = this.widgets.length;
         for(var i:int = 0; i < aNumWidgets; i++)
         {
            w = this.widgets[i];
            if(w == reference)
            {
               this.widgets = this.widgets.splice(i + 1,0,widget);
               return;
            }
         }
      }
      
      public function isBelow(a:CWidget, b:CWidget) : Boolean
      {
         return this.isBelowHelper(a,b);
      }
      
      public function intersects(widget:CWidgetContainer) : Boolean
      {
         return this.getRect().intersects(widget.getRect());
      }
      
      public function isBelowHelper(a:CWidget, b:CWidget) : Boolean
      {
         var w:CWidget = null;
         var result:Boolean = false;
         var aNumWidgets:int = this.widgets.length;
         for(var i:int = 0; i < aNumWidgets; i++)
         {
            w = this.widgets[i];
            if(w == a)
            {
               return true;
            }
            if(w == b)
            {
               return false;
            }
            result = w.isBelowHelper(a,b);
            if(result)
            {
               return true;
            }
         }
         return false;
      }
      
      public function bringToBack(widget:CWidget) : void
      {
         var index:Number = this.widgets.indexOf(widget);
         if(index < 0)
         {
            return;
         }
         this.widgets = this.widgets.splice(index,1);
         this.widgets.push(widget);
         widget.orderInManagerChanged();
      }
      
      public function drawAll(flags:CModalFlags, g:Graphics2D) : void
      {
         var w:CWidget = null;
         if(this.priority > this.widgetManager.minDeferredOverlayPriority)
         {
            this.widgetManager.flushDeferredOverlayWidgets(g,this.priority);
         }
         if(this.clip && flags.getFlags() & CWidgetManager.WIDGETFLAGS_CLIP)
         {
         }
         if(this.widgets.length == 0)
         {
            if(flags.getFlags() & CWidgetManager.WIDGETFLAGS_DRAW)
            {
               this.draw(g);
            }
            return;
         }
         if(flags.getFlags() & CWidgetManager.WIDGETFLAGS_DRAW)
         {
            g.pushState();
            this.draw(g);
            g.popState();
         }
         var aNumWidgets:int = this.widgets.length;
         for(var i:int = 0; i < aNumWidgets; i++)
         {
            w = this.widgets[i];
            if(w.visible == true)
            {
               g.pushState();
               g.translate(w.x,w.y);
               w.drawAll(flags,g);
               g.popState();
               w.dirty = false;
            }
         }
      }
      
      public function sysColorChanged() : void
      {
      }
      
      public function onMouseUp(x:Number, y:Number) : void
      {
      }
      
      public function onKeyDown(keyCode:uint) : void
      {
      }
      
      public function markDirtyFull(widget:CWidgetContainer = null) : void
      {
         var rect:Rectangle = null;
         if(widget == null)
         {
            if(this.parent != null)
            {
               this.parent.markDirtyFull(this);
            }
            else
            {
               this.dirty = true;
            }
            return;
         }
         this.markDirtyFull();
         widget.dirty = true;
         if(this.parent != null)
         {
            return;
         }
         var index:Number = this.widgets.indexOf(widget);
         if(index == -1)
         {
            return;
         }
         var i:int = index;
         var j:int = 0;
         var w:CWidget = null;
         for(i = 0; i >= 0; i = i + -1)
         {
            for(j = i; j >= 0; j = j + -1)
            {
               w = this.widgets[j];
               if(w.visible == true)
               {
                  if(!w.hasTransparencies && !w.hasAlpha)
                  {
                     rect = new Rectangle(w.x,w.y,w.width,w.height).intersection(new Rectangle(0,0,this.width,this.height));
                     if(w.contains(rect.x,rect.y) && w.contains(rect.x + rect.width - 1,rect.y + rect.height - 1))
                     {
                        w.markDirty();
                        break;
                     }
                  }
               }
            }
            i = j;
         }
         i = index;
         for(var aNumWidgets:int = this.widgets.length; i < aNumWidgets; )
         {
            w = this.widgets[i];
            if(w.visible && w.intersects(widget))
            {
               w.markDirty();
            }
            i++;
         }
      }
      
      public function draw(g:Graphics2D) : void
      {
      }
      
      public function addWidget(widget:CWidget) : void
      {
         if(widget.parent == this)
         {
            return;
         }
         if(widget.parent != null)
         {
            widget.parent.removeWidget(widget);
         }
         this.widgets.push(widget);
         widget.widgetManager = this.widgetManager;
         widget.parent = this;
         if(this.widgetManager != null)
         {
            widget.addedToManager(this.widgetManager);
            widget.markDirtyFull();
            this.widgetManager.rehupMouse();
         }
         this.markDirty();
      }
      
      public function onKeyUp(keyCode:uint) : void
      {
      }
      
      public function disableWidget(widget:CWidget) : void
      {
      }
      
      public function onMouseLeave() : void
      {
      }
      
      public function onMouseDown(x:Number, y:Number) : void
      {
      }
      
      public function update() : void
      {
         this.updateCount++;
      }
      
      public function getRect() : Rectangle
      {
         return new Rectangle(this.x,this.y,this.width,this.height);
      }
      
      public function onMouseDrag(x:Number, y:Number) : void
      {
      }
      
      public function insertWidgetHelper(widget:CWidget) : void
      {
         var w:CWidget = null;
         var aNumWidgets:int = this.widgets.length;
         for(var i:int = 0; i < aNumWidgets; i++)
         {
            w = this.widgets[i];
            if(widget.zOrder < w.zOrder)
            {
               this.widgets = this.widgets.splice(i,0,widget);
               return;
            }
         }
      }
      
      public function removeWidget(widget:CWidget) : void
      {
         if(widget.parent != this)
         {
            return;
         }
         widget.widgetRemovedHelper();
         widget.parent = null;
         var index:Number = this.widgets.indexOf(widget);
         this.widgets.splice(index,1);
      }
      
      public function removeAllWidgets(recursive:Boolean = true) : void
      {
         var w:CWidget = null;
         while(this.widgets.length > 0)
         {
            w = this.widgets.shift();
            if(recursive)
            {
               w.removeAllWidgets(recursive);
            }
         }
      }
      
      public function onMouseWheel(delta:Number) : void
      {
      }
      
      public function onKeyChar(charCode:uint) : void
      {
      }
      
      public function onMouseMove(x:Number, y:Number) : void
      {
      }
      
      public function bringToFront(widget:CWidget) : void
      {
         var index:Number = this.widgets.indexOf(widget);
         if(index < 0)
         {
            return;
         }
         this.widgets = this.widgets.splice(index,1);
         this.widgets.unshift(widget);
         widget.orderInManagerChanged();
      }
      
      public function hasWidget(widget:CWidget) : Boolean
      {
         return widget.parent == this;
      }
      
      public function getAbsPos() : Point
      {
         var p:Point = new Point(this.x,this.y);
         if(this.parent != null)
         {
            p.add(this.parent.getAbsPos());
         }
         return p;
      }
   }
}
