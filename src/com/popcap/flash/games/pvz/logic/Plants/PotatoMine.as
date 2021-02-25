package com.popcap.flash.games.pvz.logic.Plants {

import com.popcap.flash.framework.resources.particles.ParticleSystem;
import com.popcap.flash.framework.resources.reanimator.Reanimation;
import com.popcap.flash.framework.resources.reanimator.looptypes.ReanimLoopOnceAndIdle;
import com.popcap.flash.games.pvz.PVZApp;
import com.popcap.flash.games.pvz.PVZFoleyType;
import com.popcap.flash.games.pvz.logic.Board;
import com.popcap.flash.games.pvz.logic.Projectile;
import com.popcap.flash.games.pvz.logic.TodCommon;
import com.popcap.flash.games.pvz.logic.Zombies.Zombie;
import com.popcap.flash.games.pvz.renderables.ParticleRenderable;
import com.popcap.flash.games.pvz.resources.PVZParticles;
import com.popcap.flash.games.pvz.resources.PVZReanims;

import flash.geom.Rectangle;

public class PotatoMine extends CPlant
{
    public function PotatoMine(theGridX:int, theGridY:int, theSeedType:int, app:PVZApp, theBoard:Board)
    {
        super();
        this.app = app;
        mBoard = theBoard;
        mPlantCol = theGridX;
        mRow = theGridY;
        if(mBoard)
        {
            mX = mBoard.GridToPixelX(theGridX);
            mY = mBoard.GridToPixelY(theGridY);
        }
        mAnimCounter = 0;
        mAnimPing = true;
        mFrame = 0;
        mShootingCounter = 0;
        mFrameLength = 18;
        mNumFrames = 5;
        mDead = false;
        mSquished = false;
        mSeedType = theSeedType;
        mPlantHealth = 300;
        mDoSpecialCountdown = 0;
        mDisappearCountdown = 200;
        mTargetX = -1;
        mTargetY = -1;
        mStateCountdown = 0;
        mStartRow = mRow;
        mBlinkCountdown = 0;
        mRecentlyEatenCountdown = 0;
        mEatenFlashCountdown = 0;
        mWidth = 54;
        mHeight = 54;
        mBodyReanimation = app.reanimator.createReanimation(PVZReanims.REANIM_POTATOMINE);
        mBodyReanimation.loopType = Reanimation.LOOP_TYPE_ALWAYS;
        mBodyReanimation.currentTrack = "anim_idle";
        mPlantMaxHealth = mPlantHealth;
    }

    override public function Update() : void
    {
        if(mBoard.mGameScene == Board.SCENE_ZOMBIES_WON || mBoard.mGameScene == Board.SCENE_AWARD || mBoard.mGameScene == Board.SCENE_LEVEL_INTRO)
        {
            return;
        }
        if(mStateCountdown > 0)
        {
            mStateCountdown--;
        }
        this.PotatoMineUpdate();
        Animate();
        if(mPlantHealth < 0)
        {
            Die();
        }
        UpdateReanimColor();
        UpdateReanim();
    }

    var PotatoArmedCountdown:int = 336
    public function PotatoMineUpdate() : Boolean {
        if(mState == STATE_NOTREADY)
        {
            this.PotatoArmedCountdown--
            if(PotatoArmedCountdown == 0){
                mBodyReanimation.currentTrack = "anim_rise";
                app.foleyManager.playFoley(PVZFoleyType.REVERSE_EXPLOSION);
                mState = STATE_POTATO_PRIMED
            }
        }
        if(mState == STATE_POTATO_PRIMED)
        {
            var aZombie:Zombie = FindTargetZombie(this.mRow,WEAPON_PRIMARY);
            if(!aZombie)
            {
                return false;
            }
            this.DoSpecial();
        }
        //var aZombie:Zombie = FindTargetZombie(mRow,WEAPON_PRIMARY);
        //if(!aZombie)
        //{
        //    return false;
        //}
        //mShootingCounter++;
        //if(mShootingCounter == 80)
        //{
            //mHeadReanimation.animRate = 35;
            //mHeadReanimation.currentTrack = "anim_shooting";
            //mHeadReanimation.loopType = new ReanimLoopOnceAndIdle("anim_head_idle",mBodyReanimation.animRate);
        //}
        //if(mShootingCounter == 100)
        //{
        //    this.Fire(null,mRow,WEAPON_PRIMARY);
        //    mShootingCounter = 0;
        //}
        return true;
    }

    override public function DoSpecial() : void
    {
        var aPosX:int = mX + mWidth / 2;
        var aPosY:int = mY + mHeight / 2;
        app.foleyManager.playFoley(PVZFoleyType.CHERRYBOMB);
        app.foleyManager.playFoley(PVZFoleyType.JUICY);
        mBoard.KillAllZombiesInRadius(mRow,aPosX,aPosY,30,0,true);
        var anEffect:ParticleSystem = app.particleManager.spawnParticleSystem(PVZParticles.PARTICLE_POWIE);
        anEffect.setPosition(aPosX,aPosY);
        mBoard.mRenderManager.add(new ParticleRenderable(anEffect));
        mBoard.ShakeBoard(10,-15);
        Die();
    }

}
}