package com.popcap.flash.games.pvz.resources.loaders {
import com.popcap.flash.framework.resources.images.ImageDescriptor;
import com.popcap.flash.games.pvz.PVZApp;
import com.popcap.flash.games.pvz.resources.PVZImages;
import com.popcap.flash.games.pvz.resources.images.PVZImageLoader_IMAGE_POTATOMINE_RGB_CLASS;
import com.popcap.flash.games.pvz.resources.images.PVZImageLoader_IMAGE_REANIM_POTATOMINE_BLINK1_RGB_CLASS;
import com.popcap.flash.games.pvz.resources.images.PVZImageLoader_IMAGE_REANIM_POTATOMINE_BLINK2_RGB_CLASS;
import com.popcap.flash.games.pvz.resources.images.PVZImageLoader_IMAGE_REANIM_POTATOMINE_BODY_RGB_CLASS;
import com.popcap.flash.games.pvz.resources.images.PVZImageLoader_IMAGE_REANIM_POTATOMINE_EYES_RGB_CLASS;
import com.popcap.flash.games.pvz.resources.images.PVZImageLoader_IMAGE_REANIM_POTATOMINE_LIGHT1_RGB_CLASS;
import com.popcap.flash.games.pvz.resources.images.PVZImageLoader_IMAGE_REANIM_POTATOMINE_LIGHT2_RGB_CLASS;
import com.popcap.flash.games.pvz.resources.images.PVZImageLoader_IMAGE_REANIM_POTATOMINE_MASHED_RGB_CLASS;
import com.popcap.flash.games.pvz.resources.images.PVZImageLoader_IMAGE_REANIM_POTATOMINE_ROCK1_RGB_CLASS;
import com.popcap.flash.games.pvz.resources.images.PVZImageLoader_IMAGE_REANIM_POTATOMINE_ROCK2_RGB_CLASS;
import com.popcap.flash.games.pvz.resources.images.PVZImageLoader_IMAGE_REANIM_POTATOMINE_ROCK3_RGB_CLASS;
import com.popcap.flash.games.pvz.resources.images.PVZImageLoader_IMAGE_REANIM_POTATOMINE_ROCK4_RGB_CLASS;
import com.popcap.flash.games.pvz.resources.images.PVZImageLoader_IMAGE_REANIM_POTATOMINE_ROCK5_RGB_CLASS;
import com.popcap.flash.games.pvz.resources.images.PVZImageLoader_IMAGE_REANIM_POTATOMINE_ROCK6_RGB_CLASS;
import com.popcap.flash.games.pvz.resources.images.PVZImageLoader_IMAGE_REANIM_POTATOMINE_STEM_RGB_CLASS;

public class PVZImageLoader {

    public function PVZImageLoader() {
        super();
    }

    public static function init(app:PVZApp) : void
    {
        app.imageManager.addDescriptor(PVZImages.IMAGE_POTATOMINE,new ImageDescriptor(PVZImageLoader_IMAGE_POTATOMINE_RGB_CLASS));
        app.imageManager.getImageInst(PVZImages.IMAGE_POTATOMINE)
        app.imageManager.addDescriptor(PVZImages.IMAGE_REANIM_POTATOMINE_MASHED,new ImageDescriptor(PVZImageLoader_IMAGE_REANIM_POTATOMINE_MASHED_RGB_CLASS));
        app.imageManager.getImageInst(PVZImages.IMAGE_REANIM_POTATOMINE_MASHED)
        app.imageManager.addDescriptor(PVZImages.IMAGE_REANIM_POTATOMINE_ROCK1,new ImageDescriptor(PVZImageLoader_IMAGE_REANIM_POTATOMINE_ROCK1_RGB_CLASS));
        app.imageManager.getImageInst(PVZImages.IMAGE_REANIM_POTATOMINE_ROCK1)
        app.imageManager.addDescriptor(PVZImages.IMAGE_REANIM_POTATOMINE_ROCK2,new ImageDescriptor(PVZImageLoader_IMAGE_REANIM_POTATOMINE_ROCK2_RGB_CLASS));
        app.imageManager.getImageInst(PVZImages.IMAGE_REANIM_POTATOMINE_ROCK2)
        app.imageManager.addDescriptor(PVZImages.IMAGE_REANIM_POTATOMINE_ROCK3,new ImageDescriptor(PVZImageLoader_IMAGE_REANIM_POTATOMINE_ROCK3_RGB_CLASS));
        app.imageManager.getImageInst(PVZImages.IMAGE_REANIM_POTATOMINE_ROCK3)
        app.imageManager.addDescriptor(PVZImages.IMAGE_REANIM_POTATOMINE_ROCK4,new ImageDescriptor(PVZImageLoader_IMAGE_REANIM_POTATOMINE_ROCK4_RGB_CLASS));
        app.imageManager.getImageInst(PVZImages.IMAGE_REANIM_POTATOMINE_ROCK4)
        app.imageManager.addDescriptor(PVZImages.IMAGE_REANIM_POTATOMINE_ROCK5,new ImageDescriptor(PVZImageLoader_IMAGE_REANIM_POTATOMINE_ROCK5_RGB_CLASS));
        app.imageManager.getImageInst(PVZImages.IMAGE_REANIM_POTATOMINE_ROCK5)
        app.imageManager.addDescriptor(PVZImages.IMAGE_REANIM_POTATOMINE_ROCK6,new ImageDescriptor(PVZImageLoader_IMAGE_REANIM_POTATOMINE_ROCK6_RGB_CLASS));
        app.imageManager.getImageInst(PVZImages.IMAGE_REANIM_POTATOMINE_ROCK6)
        app.imageManager.addDescriptor(PVZImages.IMAGE_REANIM_POTATOMINE_BODY,new ImageDescriptor(PVZImageLoader_IMAGE_REANIM_POTATOMINE_BODY_RGB_CLASS));
        app.imageManager.getImageInst(PVZImages.IMAGE_REANIM_POTATOMINE_BODY)
        app.imageManager.addDescriptor(PVZImages.IMAGE_REANIM_POTATOMINE_STEM,new ImageDescriptor(PVZImageLoader_IMAGE_REANIM_POTATOMINE_STEM_RGB_CLASS));
        app.imageManager.getImageInst(PVZImages.IMAGE_REANIM_POTATOMINE_STEM)
        app.imageManager.addDescriptor(PVZImages.IMAGE_REANIM_POTATOMINE_EYES,new ImageDescriptor(PVZImageLoader_IMAGE_REANIM_POTATOMINE_EYES_RGB_CLASS));
        app.imageManager.getImageInst(PVZImages.IMAGE_REANIM_POTATOMINE_EYES)
        app.imageManager.addDescriptor(PVZImages.IMAGE_REANIM_POTATOMINE_BLINK1,new ImageDescriptor(PVZImageLoader_IMAGE_REANIM_POTATOMINE_BLINK1_RGB_CLASS));
        app.imageManager.getImageInst(PVZImages.IMAGE_REANIM_POTATOMINE_BLINK1)
        app.imageManager.addDescriptor(PVZImages.IMAGE_REANIM_POTATOMINE_BLINK2,new ImageDescriptor(PVZImageLoader_IMAGE_REANIM_POTATOMINE_BLINK2_RGB_CLASS));
        app.imageManager.getImageInst(PVZImages.IMAGE_REANIM_POTATOMINE_BLINK2)
        app.imageManager.addDescriptor(PVZImages.IMAGE_REANIM_POTATOMINE_LIGHT1,new ImageDescriptor(PVZImageLoader_IMAGE_REANIM_POTATOMINE_LIGHT1_RGB_CLASS));
        app.imageManager.getImageInst(PVZImages.IMAGE_REANIM_POTATOMINE_LIGHT1)
        app.imageManager.addDescriptor(PVZImages.IMAGE_REANIM_POTATOMINE_LIGHT2,new ImageDescriptor(PVZImageLoader_IMAGE_REANIM_POTATOMINE_LIGHT2_RGB_CLASS));
        app.imageManager.getImageInst(PVZImages.IMAGE_REANIM_POTATOMINE_LIGHT2)
    }
}
}
