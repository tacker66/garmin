//
// Based on ./samples/Analog from the Garmin Connect IQ SDK
//
// Copyright 2023 Thomas Ackermann
//

import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class GuruFaceSettingsView extends WatchUi.View {

    public function initialize() {

        View.initialize();
        var setting = Storage.getValue(1);
        if(setting == null) {
            Storage.setValue(1, true);
        }
        setting = Storage.getValue(2);
        if(setting == null) {
            Storage.setValue(2, true);
        }
        setting = Storage.getValue(3);
        if(setting == null) {
            Storage.setValue(3, true);
        }
        setting = Storage.getValue(4);
        if(setting == null) {
            Storage.setValue(4, true);
        }
    }

    public function onUpdate(dc as Dc) as Void {

        dc.clearClip();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 30, Graphics.FONT_SMALL, "Press Menu \nfor settings", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class GuruFaceSettingsDelegate extends WatchUi.BehaviorDelegate {

    public function initialize() {
        
        BehaviorDelegate.initialize();
    }

    public function onMenu() as Boolean {

        var menu = new $.GuruFaceSettingsMenu();
        var bool = Storage.getValue(1);
        menu.addItem(new WatchUi.ToggleMenuItem("Show seconds", null, 1, bool, null));
        bool = Storage.getValue(2);
        menu.addItem(new WatchUi.ToggleMenuItem("Show battery", null, 2, bool, null));
        bool = Storage.getValue(3);
        menu.addItem(new WatchUi.ToggleMenuItem("Show date",    null, 3, bool, null));
        bool = Storage.getValue(4);
        menu.addItem(new WatchUi.ToggleMenuItem("Show inverted",null, 4, bool, null));
        WatchUi.pushView(menu, new $.GuruFaceSettingsMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}
