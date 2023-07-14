//
// Based on ./samples/SimpleDataField from the Connect IQ SDK
//
// Copyright 2023 Thomas Ackermann
//

import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class GuruPaceField extends WatchUi.SimpleDataField {

    public function initialize() {
        SimpleDataField.initialize();
    }

    public function compute(info as Info) as Numeric or Duration or String or Null {
        var value_picked = "0:00.0";
        if ((info.averageSpeed != null) && (info.averageSpeed > 0.0)) {
            var speed = 1000.0 / (60.0 * info.averageSpeed);
            var pace_min = speed.toNumber();
            var pace_sec = (speed - pace_min) * 60.0;
            value_picked = pace_min.format("%d") + ":" + pace_sec.format("%02.1f");
        }
        return value_picked;
    }
}
