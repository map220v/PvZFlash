package com.popcap.flash.games.pvz
{

[SWF(width="540", height="405",backgroundColor="0")]
public class PVZFlash extends PVZApp
   {
      public function PVZFlash()
      {
         super();
         appWidth = stage.stageWidth;
         appHeight = stage.stageHeight;
         screenWidth = 540;//800 - 1.481481481481481
         screenHeight = 405;//600 - 1.481481481481481
         init();
      }
   }
}
