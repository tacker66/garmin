//
// Based on ./samples/SimpleDataField from the Connect IQ SDK
//
// Copyright 2023 Thomas Ackermann
//

import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class GuruDist extends Application.AppBase {

    public function initialize() {
        AppBase.initialize();
    }

    public function onStart(state as Dictionary?) as Void {
    }

    public function onStop(state as Dictionary?) as Void {
    }

    public function getInitialView() as Array<Views or InputDelegates>? {
        return [new $.GuruDistField()] as Array<Views>;
    }
}
