//
// Based on ./samples/Analog from the Garmin Connect IQ SDK
//
// Copyright 2023 Thomas Ackermann
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class GuruFace extends Application.AppBase {

    public function initialize() {
        AppBase.initialize();
    }

    public function onStart(state as Dictionary?) as Void {
    }

    public function onStop(state as Dictionary?) as Void {
    }

    public function getInitialView() as Array<Views or InputDelegates>? {
        if (WatchUi has :WatchFaceDelegate) {
            var view = new $.GuruFaceView();
            var delegate = new $.GuruFaceDelegate(view);
            return [view, delegate] as Array<Views or InputDelegates>;
        } else {
            return [new $.GuruFaceView()] as Array<Views>;
        }
    }

    public function getSettingsView() as Array<Views or InputDelegates>? {
        return [new $.GuruFaceSettingsView(), new $.GuruFaceSettingsDelegate()] as Array<Views or InputDelegates>;
    }
}
