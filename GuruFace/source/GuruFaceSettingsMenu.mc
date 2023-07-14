//
// Based on ./samples/Analog from the Garmin Connect IQ SDK
//
// Copyright 2023 Thomas Ackermann
//

import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;

class GuruFaceSettingsMenu extends WatchUi.Menu2 {

    public function initialize() {
        Menu2.initialize({:title=>"Settings"});
    }
}

class GuruFaceSettingsMenuDelegate extends WatchUi.Menu2InputDelegate {

    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect(menuItem as MenuItem) as Void {
        if (menuItem instanceof ToggleMenuItem) {
            Storage.setValue(menuItem.getId() as Number, menuItem.isEnabled());
        }
    }
}
