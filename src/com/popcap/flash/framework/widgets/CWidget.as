package com.popcap.flash.framework.widgets
{
   import com.popcap.flash.framework.graphics.Color;
   import com.popcap.flash.framework.graphics.Graphics2D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   
   public class CWidget extends CWidgetContainer
   {
      
      public static const LAY_Right:Number = 1024;
      
      public static const LAY_Above:Number = 256;
      
      public static const LAY_GrowToBottom:Number = 524288;
      
      public static const LAY_SameLeft:Number = 4096;
      
      public static const LAY_SetPos:Number = LAY_SetLeft | LAY_SetTop;
      
      public static const LAY_SetHeight:Number = 128;
      
      public static const LAY_Left:Number = 2048;
      
      public static const LAY_SetTop:Number = 32;
      
      public static const LAY_Below:Number = 512;
      
      public static const LAY_GrowToTop:Number = 262144;
      
      public static const LAY_HCenter:Number = 1048576;
      
      public static const LAY_SameCorner:Number = LAY_SameLeft | LAY_SameTop;
      
      public static const LAY_GrowToLeft:Number = 131072;
      
      public static const LAY_Max:Number = 4194304;
      
      public static const LAY_SameSize:Number = LAY_SameWidth | LAY_SameHeight;
      
      public static const LAY_SameWidth:Number = 1;
      
      public static const LAY_SameHeight:Number = 2;
      
      public static const LAY_SetLeft:Number = 16;
      
      public static const LAY_VCenter:Number = 2097152;
      
      public static const LAY_SameBottom:Number = 32768;
      
      public static const LAY_SameTop:Number = 16384;
      
      public static const LAY_GrowToRight:Number = 65536;
      
      public static const LAY_SameRight:Number = 8192;
      
      public static const LAY_SetSize:Number = LAY_SetWidth | LAY_SetHeight;
      
      public static const LAY_SetWidth:Number = 64;
       
      
      protected var mBounds:Rectangle;
      
      public var isOver:Boolean = false;
      
      public var tabNext:CWidget = null;
      
      public var wantsFocus:Boolean = false;
      
      public var hasTransparencies:Boolean = false;
      
      protected var mPolyShape:Vector.<Point>;
      
      public var doFinger:Boolean = false;
      
      public var hasFocus:Boolean = false;
      
      public var tabPrev:CWidget = null;
      
      public var colors:Array;
      
      public var isDown:Boolean = false;
      
      public var visible:Boolean = true;
      
      public var mUsePolyShape:Boolean = false;
      
      public var disabled:Boolean = false;
      
      public function CWidget()
      {
         this.colors = new Array();
         this.mPolyShape = new Vector.<Point>();
         this.mBounds = new Rectangle();
         super();
      }
      
      public function setColors(theColors:Array) : void
      {
         this.colors = new Array();
         var aNumColors:int = theColors.length;
         for(var i:int = 0; i < aNumColors; i++)
         {
            this.setColor(i,this.colors[i]);
         }
         markDirty();
      }
      
      public function deferOverlay(priority:Number) : void
      {
         widgetManager.deferOverlay(this,priority);
      }
      
      public function isPointVisible(x:Number, y:Number) : Boolean
      {
         return true;
      }
      
      public function lostFocus() : void
      {
         this.hasFocus = false;
      }
      
      public function contains(x:Number, y:Number) : Boolean
      {
         var a:Point = null;
         var b:Point = null;
         if(this.width == 0 || this.height == 0)
         {
            return false;
         }
         if(x < this.x)
         {
            return false;
         }
         if(y < this.y)
         {
            return false;
         }
         if(x >= this.x + this.width)
         {
            return false;
         }
         if(y >= this.y + this.height)
         {
            return false;
         }
         if(!this.mUsePolyShape)
         {
            return true;
         }
         if(this.mPolyShape.length < 3)
         {
            return false;
         }
         var inside:* = false;
         var i:int = 0;
         var j:int = 0;
         var numVerts:int = this.mPolyShape.length;
         for(i = 0,j = numVerts - 1; i < numVerts; j = i++)
         {
            a = this.mPolyShape[i];
            b = this.mPolyShape[j];
            if(a.y > y != b.y > y && x < (b.x - a.x) * (y - a.y) / (b.y - a.y) + a.x)
            {
               inside = !inside;
            }
         }
         return inside;
      }
      
      public function setColor(index:int, color:Color) : void
      {
         this.colors[index] = color;
         markDirty();
      }
      
      public function layout(layoutFlags:Number, relative:CWidget, theLeftPad:Number, theTopPad:Number, theWidthPad:Number, theHeightPad:Number) : void
      {
         var aRelLeft:Number = relative.x;
         var aRelTop:Number = relative.y;
         if(relative == parent)
         {
            aRelLeft = 0;
            aRelTop = 0;
         }
         var aRelWidth:Number = relative.width;
         var aRelHeight:Number = relative.height;
         var aRelRight:Number = aRelLeft + aRelWidth;
         var aRelBottom:Number = aRelTop + aRelHeight;
         var aLeft:Number = x;
         var aTop:Number = y;
         var aWidth:Number = width;
         var aHeight:Number = height;
         var aType:Number = 1;
         while(aType < LAY_Max)
         {
            if(layoutFlags & aType)
            {
               switch(aType)
               {
                  case LAY_SameWidth:
                     aWidth = aRelWidth + theWidthPad;
                     break;
                  case LAY_SameHeight:
                     aHeight = aRelHeight + theHeightPad;
                     break;
                  case LAY_Above:
                     aTop = aRelTop - aHeight + theTopPad;
                     break;
                  case LAY_Below:
                     aTop = aRelBottom + theTopPad;
                     break;
                  case LAY_Right:
                     aLeft = aRelRight + theLeftPad;
                     break;
                  case LAY_Left:
                     aLeft = aRelLeft - aWidth + theLeftPad;
                     break;
                  case LAY_SameLeft:
                     aLeft = aRelLeft + theLeftPad;
                     break;
                  case LAY_SameRight:
                     aLeft = aRelRight - aWidth + theLeftPad;
                     break;
                  case LAY_SameTop:
                     aTop = aRelTop + theTopPad;
                     break;
                  case LAY_SameBottom:
                     aTop = aRelBottom - aHeight + theTopPad;
                     break;
                  case LAY_GrowToRight:
                     aWidth = aRelRight - aLeft + theWidthPad;
                     break;
                  case LAY_GrowToLeft:
                     aWidth = aRelLeft - aLeft + theWidthPad;
                     break;
                  case LAY_GrowToTop:
                     aHeight = aRelTop - aTop + theHeightPad;
                     break;
                  case LAY_GrowToBottom:
                     aHeight = aRelBottom - aTop + theHeightPad;
                     break;
                  case LAY_SetLeft:
                     aLeft = theLeftPad;
                     break;
                  case LAY_SetTop:
                     aTop = theTopPad;
                     break;
                  case LAY_SetWidth:
                     aWidth = theWidthPad;
                     break;
                  case LAY_SetHeight:
                     aHeight = theHeightPad;
                     break;
                  case LAY_HCenter:
                     aLeft = aRelLeft + (aRelWidth - aWidth) / 2 + theLeftPad;
                     break;
                  case LAY_VCenter:
                     aTop = aRelTop + (aRelHeight - aHeight) / 2 + theTopPad;
               }
            }
            aType = aType << 1;
         }
         this.resize(aLeft,aTop,aWidth,aHeight);
      }
      
      public function gotFocus() : void
      {
         this.hasFocus = true;
      }
      
      public function getColor(index:Number) : Color
      {
         if(index < 0 || index >= this.colors.length)
         {
            return null;
         }
         return this.colors[index];
      }
      
      public function setVisible(isVisible:Boolean) : void
      {
         if(this.visible == isVisible)
         {
            return;
         }
         this.visible = isVisible;
         if(this.visible == true)
         {
            markDirty();
         }
         else
         {
            markDirtyFull();
         }
         if(widgetManager != null)
         {
            widgetManager.rehupMouse();
         }
      }
      
      public function resize(x:Number, y:Number, width:Number, height:Number) : void
      {
         if(this.x == x && this.y == y && this.width == width && this.height == height)
         {
            return;
         }
         markDirtyFull();
         this.x = x;
         this.y = y;
         this.width = width;
         this.height = height;
         this.mBounds.x = x;
         this.mBounds.y = y;
         this.mBounds.width = width;
         this.mBounds.height = height;
         markDirty();
         if(widgetManager != null)
         {
            widgetManager.rehupMouse();
         }
      }
      
      public function orderInManagerChanged() : void
      {
      }
      
      override public function onKeyUp(keyCode:uint) : void
      {
      }
      
      override public function onMouseUp(x:Number, y:Number) : void
      {
      }
      
      override public function onKeyDown(keyCode:uint) : void
      {
         if(keyCode == Keyboard.TAB)
         {
            if(widgetManager.keyDown[Keyboard.SHIFT])
            {
               if(this.tabPrev != null)
               {
                  widgetManager.setFocus(this.tabPrev);
               }
            }
            else if(this.tabNext != null)
            {
               widgetManager.setFocus(this.tabNext);
            }
         }
      }
      
      override public function draw(g:Graphics2D) : void
      {
      }
      
      public function showFinger(on:Boolean) : void
      {
         if(widgetManager == null)
         {
            return;
         }
         widgetManager.showFinger(on,this);
      }
      
      override public function update() : void
      {
         super.update();
      }
      
      public function widgetRemovedHelper() : void
      {
         var w:CWidget = null;
         var info:CPreModalInfo = null;
         if(widgetManager == null)
         {
            return;
         }
         var aNumWidgets:int = widgets.length;
         for(var i:int = 0; i < aNumWidgets; i++)
         {
            w = widgets[i];
            w.widgetRemovedHelper();
         }
         widgetManager.disableWidget(this);
         var modal:Array = widgetManager.preModalInfoList;
         var aNumInfos:int = modal.length;
         for(i = 0; i < aNumInfos; i++)
         {
            info = modal[i];
            if(info.prevBaseModalWidget == this)
            {
               info.prevBaseModalWidget = null;
            }
            if(info.prevFocusWidget == this)
            {
               info.prevFocusWidget = null;
            }
         }
         removedFromManager(widgetManager);
         markDirtyFull(this);
         widgetManager = null;
      }
      
      override public function onMouseDown(x:Number, y:Number) : void
      {
      }
      
      public function move(x:Number, y:Number) : void
      {
         this.resize(x,y,width,height);
      }
      
      override public function onMouseDrag(x:Number, y:Number) : void
      {
      }
      
      override public function onMouseLeave() : void
      {
      }
      
      public function drawOverlay(g:Graphics2D, priority:Number = 0) : void
      {
      }
      
      override public function onMouseEnter() : void
      {
      }
      
      override public function onMouseWheel(delta:Number) : void
      {
      }
      
      override public function onMouseMove(x:Number, y:Number) : void
      {
      }
      
      public function setPolyShape(vertices:Vector.<Point>) : void
      {
         var p:Point = null;
         this.mPolyShape = vertices;
         var left:Number = Number.MAX_VALUE;
         var right:Number = Number.MIN_VALUE;
         var top:Number = Number.MAX_VALUE;
         var bottom:Number = Number.MIN_VALUE;
         var numVerts:int = vertices.length;
         for(var i:int = 0; i < numVerts; i++)
         {
            p = vertices[i];
            left = Math.min(p.x,left);
            right = Math.max(p.x,right);
            top = Math.min(p.y,top);
            bottom = Math.max(p.y,bottom);
         }
         this.mBounds.left = left;
         this.mBounds.right = right;
         this.mBounds.top = top;
         this.mBounds.bottom = bottom;
         this.x = this.mBounds.x;
         this.y = this.mBounds.y;
         this.width = this.mBounds.width;
         this.height = this.mBounds.height;
         this.mUsePolyShape = true;
      }
      
      override public function onKeyChar(charCode:uint) : void
      {
      }
      
      public function setDisabled(isDisabled:Boolean) : void
      {
         if(this.disabled == isDisabled)
         {
            return;
         }
         this.disabled = isDisabled;
         if(isDisabled && widgetManager != null)
         {
            widgetManager.disableWidget(this);
         }
         markDirty();
         if(!isDisabled && widgetManager != null && this.contains(widgetManager.lastMouseX,widgetManager.lastMouseY))
         {
            widgetManager.setMousePosition(widgetManager.lastMouseX,widgetManager.lastMouseY);
         }
      }
   }
}
