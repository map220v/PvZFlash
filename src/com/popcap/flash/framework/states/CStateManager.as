package com.popcap.flash.framework.states
{
   import com.popcap.flash.framework.graphics.Graphics2D;
   
   public class CStateManager implements IStateManager
   {
       
      
      private var states:Object;
      
      private var stack:Array;
      
      public function CStateManager()
      {
         super();
         this.states = new Object();
         this.stack = new Array();
      }
      
      public function popState() : void
      {
         var newState:IState = null;
         if(this.stack.length == 0)
         {
            return;
         }
         var oldState:IState = this.stack.pop() as IState;
         oldState.onExit();
         if(this.stack.length > 0)
         {
            newState = this.stack[this.stack.length - 1] as IState;
            newState.onPop();
         }
      }
      
      public function changeState(id:String) : void
      {
         var state:IState = null;
         var newState:IState = this.states[id] as IState;
         if(newState == null)
         {
            throw new ArgumentError("ID " + id + " is unbound, cannot change states.");
         }
         var aNumStates:int = this.stack.length;
         for(var i:int = aNumStates - 1; i >= 0; i--)
         {
            state = this.stack[i] as IState;
            state.onExit();
         }
         this.stack = new Array();
         this.stack.push(newState);
         newState.onEnter();
      }
      
      public function draw(g:Graphics2D) : void
      {
         var state:IState = null;
         var aNumStates:int = this.stack.length;
         for(var i:int = 0; i < aNumStates; i++)
         {
            state = this.stack[i] as IState;
            state.draw(g);
         }
      }
      
      public function bindState(id:String, state:IState) : void
      {
         this.states[id] = state;
      }
      
      public function pushState(id:String) : void
      {
         var oldState:IState = null;
         var newState:IState = this.states[id] as IState;
         if(newState == null)
         {
            throw new ArgumentError("ID " + id + " is unbound, cannot push onto stack.");
         }
         if(this.stack.length > 0)
         {
            oldState = this.stack[this.stack.length - 1] as IState;
            oldState.onPush();
         }
         this.stack.push(newState);
         newState.onEnter();
      }
      
      public function update() : void
      {
         var index:int = this.stack.length - 1;
         if(index < 0)
         {
            return;
         }
         var state:IState = this.stack[index] as IState;
         state.update();
      }
   }
}
