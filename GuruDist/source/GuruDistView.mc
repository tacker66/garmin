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

class GuruDistField extends WatchUi.SimpleDataField {

    public function initialize() {
        SimpleDataField.initialize();
    }

    public function compute(info as Info) as Numeric or Duration or String or Null {
        var value_picked = "0.0";
        if(info.elapsedDistance != null) {
            var dist = info.elapsedDistance / 1000.0;
            value_picked = dist.format("%.1f");
        }
        return value_picked;
    }
}
