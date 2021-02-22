package com.popcap.flash.framework.resources.particles
{
   public class FloatParameterTrack
   {
       
      
      public var mNodes:Array;
      
      public function FloatParameterTrack()
      {
         super();
         this.mNodes = new Array();
      }
      
      public function curveEvaluate(time:Number, start:Number, end:Number, curve:CurveType) : Number
      {
         var aWarpedTime:Number = NaN;
         switch(curve)
         {
            case CurveType.CONSTANT:
               aWarpedTime = 0;
               break;
            case CurveType.LINEAR:
               aWarpedTime = time;
               break;
            case CurveType.EASE_IN:
               aWarpedTime = this.curveQuad(time);
               break;
            case CurveType.EASE_OUT:
               aWarpedTime = this.curveInvQuad(time);
               break;
            case CurveType.EASE_IN_OUT:
               aWarpedTime = this.curveS(this.curveS(time));
               break;
            case CurveType.EASE_IN_OUT_WEAK:
               aWarpedTime = this.curveS(time);
               break;
            case CurveType.FAST_IN_OUT:
               aWarpedTime = this.curveInvQuadS(this.curveInvQuadS(time));
               break;
            case CurveType.FAST_IN_OUT_WEAK:
               aWarpedTime = this.curveInvQuadS(time);
               break;
            case CurveType.BOUNCE:
               aWarpedTime = this.curveBounce(time);
               break;
            case CurveType.BOUNCE_FAST_MIDDLE:
               aWarpedTime = this.curveQuad(this.curveBounce(time));
               break;
            case CurveType.BOUNCE_SLOW_MIDDLE:
               aWarpedTime = this.curveInvQuad(this.curveBounce(time));
               break;
            case CurveType.SIN_WAVE:
               aWarpedTime = Math.sin(time * Math.PI * 2);
               break;
            case CurveType.EASE_SIN_WAVE:
               aWarpedTime = Math.sin(this.curveS(time) * Math.PI * 2);
               break;
            default:
               throw new Error("Unknown curve type \'" + curve + "\'");
         }
         return start + (end - start) * aWarpedTime;
      }
      
      private function curveInvQuad(time:Number) : Number
      {
         return 2 * time - time * time;
      }
      
      public function scale(scale:Number) : void
      {
         var aNode:FloatParameterTrackNode = null;
         var aNumNodes:int = this.mNodes.length;
         for(var i:int = 0; i < aNumNodes; i++)
         {
            aNode = this.mNodes[i];
            aNode.mHighValue = aNode.mHighValue * scale;
            aNode.mLowValue = aNode.mLowValue * scale;
         }
      }
      
      private function curveS(time:Number) : Number
      {
         return 3 * time * time - 2 * time * time * time;
      }
      
      private function curveQuadS(time:Number) : Number
      {
         if(time <= 0.5)
         {
            return this.curveQuad(time * 2) * 0.5;
         }
         return this.curveInvQuad((time - 0.5) * 2) * 0.5 + 0.5;
      }
      
      public function evaluateLast(time:Number, interp:Number) : Number
      {
         if(time < 0)
         {
            return 0;
         }
         return this.evaluate(time,interp);
      }
      
      private function curveInvQuadS(time:Number) : Number
      {
         if(time <= 0.5)
         {
            return this.curveInvQuad(time * 2) * 0.5;
         }
         return this.curveQuad((time - 0.5) * 2) * 0.5 + 0.5;
      }
      
      public function isConstantZero() : Boolean
      {
         if(this.mNodes.length == 0)
         {
            return true;
         }
         if(this.mNodes.length != 1)
         {
            return false;
         }
         var aNode:FloatParameterTrackNode = this.mNodes[0];
         if(aNode.mLowValue == 0 && aNode.mHighValue == 0)
         {
            return true;
         }
         return false;
      }
      
      public function isSet() : Boolean
      {
         if(this.mNodes.length == 0)
         {
            return false;
         }
         if(this.mNodes[0].mCurveType == CurveType.CONSTANT)
         {
            return false;
         }
         return true;
      }
      
      public function evaluate(time:Number, interp:Number) : Number
      {
         var aRightNode:FloatParameterTrackNode = null;
         var aLeftNode:FloatParameterTrackNode = null;
         var aTimeFraction:Number = NaN;
         var aLeftValue:Number = NaN;
         var aRightValue:Number = NaN;
         if(this.mNodes.length == 0)
         {
            return 0;
         }
         var first:FloatParameterTrackNode = this.mNodes[0];
         if(time < first.mTime)
         {
            return this.curveEvaluate(interp,first.mLowValue,first.mHighValue,first.mDistribution);
         }
         var aNodeCount:int = this.mNodes.length;
         for(var i:int = 1; i < aNodeCount; )
         {
            aRightNode = this.mNodes[i];
            if(time > aRightNode.mTime)
            {
               i++;
               continue;
            }
            aLeftNode = this.mNodes[i - 1];
            aTimeFraction = (time - aLeftNode.mTime) / (aRightNode.mTime - aLeftNode.mTime);
            aLeftValue = this.curveEvaluate(interp,aLeftNode.mLowValue,aLeftNode.mHighValue,aLeftNode.mDistribution);
            aRightValue = this.curveEvaluate(interp,aRightNode.mLowValue,aRightNode.mHighValue,aRightNode.mDistribution);
            return this.curveEvaluate(aTimeFraction,aLeftValue,aRightValue,aLeftNode.mCurveType);
         }
         var last:FloatParameterTrackNode = this.mNodes[aNodeCount - 1];
         return this.curveEvaluate(interp,last.mLowValue,last.mHighValue,last.mDistribution);
      }
      
      public function toString() : String
      {
         return "[FloatParameterTrack -- " + this.mNodes + "]";
      }
      
      private function curveQuad(time:Number) : Number
      {
         return time * time;
      }
      
      private function curveBounce(time:Number) : Number
      {
         return 1 - Math.abs(1 - time * 2);
      }
      
      public function setDefault(value:Number) : void
      {
         if(this.mNodes.length != 0 || value == 0)
         {
            return;
         }
         var aNode:FloatParameterTrackNode = new FloatParameterTrackNode();
         aNode.mTime = 0;
         aNode.mLowValue = value;
         aNode.mHighValue = value;
         aNode.mCurveType = CurveType.CONSTANT;
         aNode.mDistribution = CurveType.LINEAR;
         this.mNodes.push(aNode);
      }
   }
}
