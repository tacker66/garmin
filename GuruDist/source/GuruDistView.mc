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

class GuruDistField extends WatchUi.DataField {

    hidden var value="0.0";

    public function initialize() {
        DataField.initialize();
    }

    public function compute(info as Info) as Numeric or Duration or String or Null {
        if(info.elapsedDistance != null) {
            var dist = info.elapsedDistance / 1000.0;
            value = dist.format("%.1f");
        }
        return value;
    }
    
    public function onUpdate(dc) {
        var width = dc.getWidth();
        var height= dc.getHeight();
        var align = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
        var bgColor = getBackgroundColor();
        dc.setColor(bgColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle (0, 0, width, height);
        dc.setColor((bgColor == Graphics.COLOR_BLACK) ? 
                        Graphics.COLOR_WHITE : Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        var fonts = [
                        Graphics.FONT_NUMBER_THAI_HOT,
                        Graphics.FONT_NUMBER_HOT, 
                        Graphics.FONT_NUMBER_MEDIUM,
                        Graphics.FONT_NUMBER_MILD,
                        Graphics.FONT_LARGE,
                        Graphics.FONT_MEDIUM,
                        Graphics.FONT_SMALL,
                        Graphics.FONT_TINY,
                    ];
        var i;
        for(i=0; i<fonts.size(); i++) {
            var dim = dc.getTextDimensions(value, fonts[i]);
            if(dim[0]<width && dim[1]<height) {
                break;
            }
        }
        dc.drawText(width/2, height/2, fonts[i], value, align);
    }
}
