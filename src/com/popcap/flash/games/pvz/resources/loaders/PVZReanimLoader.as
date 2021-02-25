package com.popcap.flash.games.pvz.resources.loaders {
import com.popcap.flash.framework.resources.reanimator.XMLReanimDescriptor;
import com.popcap.flash.games.pvz.PVZApp;
import com.popcap.flash.games.pvz.resources.PVZReanims;
import com.popcap.flash.games.pvz.resources.reanims.PVZReanimLoader_REANIM_POTATOMINE_CLASS;

import flash.utils.ByteArray;

import flash.utils.Dictionary;


public class PVZReanimLoader {

    public function PVZReanimLoader() {
        super();
    }

    public static function init(app:PVZApp) : void
    {
        app.reanimator.loadReanim(PVZReanims.REANIM_POTATOMINE, new XMLReanimDescriptor(new PVZReanimLoader_REANIM_POTATOMINE_CLASS()))
    }

}
}
