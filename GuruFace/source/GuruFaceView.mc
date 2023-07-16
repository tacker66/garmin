//
// Based on ./samples/Analog from the Garmin Connect IQ SDK
//
// Copyright 2023 Thomas Ackermann
//

import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;
import Toybox.Application.Storage;

class GuruFaceView extends WatchUi.WatchFace {

    private var _font as FontResource?;
    private var _isAwake as Boolean?;
    private var _offscreenBuffer as BufferedBitmap?;
    private var _screenCenterPoint as Array<Float>?;
    private var _fullScreenRefresh as Boolean;
    private var _partialUpdatesAllowed as Boolean;
    private var _showSeconds as Boolean;
    private var _showBattery as Boolean;
    private var _showDate as Boolean;
    private var _showInverted as Boolean;
    private var _foregroundColor;
    private var _backgroundColor;

    public function initialize() {
        WatchFace.initialize();
        _fullScreenRefresh = true;
        _partialUpdatesAllowed = (WatchUi.WatchFace has :onPartialUpdate);
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
            Storage.setValue(4, false);
        }
        _showSeconds  = Storage.getValue(1);
        _showBattery  = Storage.getValue(2);
        _showDate     = Storage.getValue(3);
        _showInverted = Storage.getValue(4);
        if(_showInverted) {
            _foregroundColor = Graphics.COLOR_WHITE;
            _backgroundColor = Graphics.COLOR_BLACK;
        } else {
            _foregroundColor = Graphics.COLOR_BLACK;
            _backgroundColor = Graphics.COLOR_WHITE;
        }
        _isAwake = true;
    }

    public function onLayout(dc as Dc) as Void {
        _font = WatchUi.loadResource($.Rez.Fonts.id_font_battery) as FontResource;
        if (Graphics has :BufferedBitmap) {
            _offscreenBuffer = new Graphics.BufferedBitmap({
                :width=>dc.getWidth(),
                :height=>dc.getHeight(),
                :palette=> [_foregroundColor, _backgroundColor] as Array<ColorValue>
            });
        } else {
            _offscreenBuffer = null;
        }
        _screenCenterPoint = [dc.getWidth() / 2.0, dc.getHeight() / 2.0] as Array<Float>;
    }

    private function generateHandCoordinates(centerPoint as Array<Float>, angle as Float, handLength as Number, tailLength as Number, width as Number) as Array<Array<Float>> {
        var w = width.toFloat();
        var t = tailLength.toFloat();
        var h = handLength.toFloat();
        var coords = [[-(w/2.0), t] as Array<Float>, [-(w/2.0), -h] as Array<Float>, [w/2.0, -h] as Array<Float>, [w/2.0, t] as Array<Float>] as Array<Array<Float>>;
        var result = new Array<Array<Float>>[4];
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);
        for (var i = 0; i < 4; i++) {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin);
            var y = (coords[i][0] * sin) + (coords[i][1] * cos);
            result[i] = [(centerPoint[0] + x + 0.5).toFloat(), (centerPoint[1] + y + 0.5).toFloat()] as Array<Float>;
        }
        return result;
    }

    private function generateSecondHandCoordinates(centerPoint as Array<Float>) as Array< Array<Float> > {
        var clockTime = System.getClockTime();
        var secondHand = (clockTime.sec / 60.0) * Math.PI * 2.0;
        return generateHandCoordinates(centerPoint, secondHand, 78, 14, 0);
    }

    private function drawHashMarks(dc as Dc) as Void {
        dc.setPenWidth(1);
        var width = dc.getWidth();
        var outerRad = width / 2.0;
        var innerRad1 = outerRad - 16.0;
        var innerRad2 = outerRad - 8.0;
        var innerRad;
        var inc = Math.PI / 30.0;
        for (var i=0, ang=0.0; i<60; i++) {
            innerRad = (i%5==0)?innerRad1:innerRad2;
            var sX = outerRad + innerRad * Math.cos(ang) + 0.5;
            var sY = outerRad + innerRad * Math.sin(ang) + 0.5;
            var eX = outerRad + outerRad * Math.cos(ang) + 0.5;
            var eY = outerRad + outerRad * Math.sin(ang) + 0.5;
            if(i==45) {
                dc.setPenWidth(4);
            }
            dc.drawLine(sX, sY, eX, eY);
            if(i==45) {
                dc.setPenWidth(1);
            }
            ang += inc;
        }
    }

    public function onUpdate(dc as Dc) as Void {
        var clockTime = System.getClockTime();
        var targetDc = null;
        _fullScreenRefresh = true;
        if (null != _offscreenBuffer) {
            targetDc = _offscreenBuffer.getDc();
            dc.clearClip();
        } else {
            targetDc = dc;
        }
        var width = targetDc.getWidth();
        var height = targetDc.getHeight();

        targetDc.setColor(_foregroundColor, _backgroundColor);

        targetDc.clear();

        var font = _font;
        if(font == null) {
            font = Graphics.FONT_XTINY;
        }

        if(_showBattery) {
            var dataString = (System.getSystemStats().battery + 0.5).toNumber().toString() + "%";
            targetDc.drawText(width * 4 / 12, height * 7 / 12, font, dataString, Graphics.TEXT_JUSTIFY_CENTER);
        }

        if(_showDate) {
            var info = Gregorian.info(Time.now(), Time.FORMAT_LONG);
            var dateStr = Lang.format("$1$.", [info.day]);
            targetDc.drawText(width * 8 / 12, height * 7 / 12, font, dateStr, Graphics.TEXT_JUSTIFY_CENTER);
        }

        targetDc.setColor(_foregroundColor, Graphics.COLOR_TRANSPARENT);

        drawHashMarks(targetDc);

        var hourHandAngle = (((clockTime.hour % 12) * 60.0) + clockTime.min);
        hourHandAngle = hourHandAngle / (12.0 * 60.0);
        hourHandAngle = hourHandAngle * Math.PI * 2.0;
        targetDc.fillPolygon(generateHandCoordinates(_screenCenterPoint, hourHandAngle, 48, 0, 4));

        var minuteHandAngle = (clockTime.min / 60.0) * Math.PI * 2.0;
        targetDc.fillPolygon(generateHandCoordinates(_screenCenterPoint, minuteHandAngle, 68, 0, 2));

        targetDc.fillCircle(width / 2.0, height / 2.0, 5);

        drawBackground(dc);

        dc.setColor(_foregroundColor, Graphics.COLOR_TRANSPARENT);

        if (_partialUpdatesAllowed) {
            onPartialUpdate(dc);
        } else if (_showSeconds && _isAwake) {
            dc.fillPolygon(generateSecondHandCoordinates(_screenCenterPoint));
        }
        
        _fullScreenRefresh = false;
    }

    // looks like this is done only every other second ...
    public function onPartialUpdate(dc as Dc) as Void {
        if(!_showSeconds) {
            return;
        }
        if (!_fullScreenRefresh) {
            drawBackground(dc);
        }
        var secondHandPoints = generateSecondHandCoordinates(_screenCenterPoint);
        var curClip = getBoundingBox(secondHandPoints);
        var bBoxWidth = curClip[1][0] - curClip[0][0] + 1;
        var bBoxHeight = curClip[1][1] - curClip[0][1] + 1;
        dc.setClip(curClip[0][0], curClip[0][1], bBoxWidth, bBoxHeight);
        dc.fillPolygon(secondHandPoints);
    }

    private function getBoundingBox(points as Array< Array<Float> >) as Array< Array<Float> > {
        var min = [9999.0, 9999.0] as Array<Float>;
        var max = [0.0, 0.0] as Array<Float>;
        for (var i = 0; i < points.size(); ++i) {
            if (points[i][0] < min[0]) {
                min[0] = points[i][0] - 0.5;
            }
            if (points[i][1] < min[1]) {
                min[1] = points[i][1] - 0.5;
            }
            if (points[i][0] > max[0]) {
                max[0] = points[i][0] + 0.5;
            }
            if (points[i][1] > max[1]) {
                max[1] = points[i][1] + 0.5;
            }
        }
        return [min, max] as Array< Array<Float> >;
    }

    private function drawBackground(dc as Dc) as Void {
        if (null != _offscreenBuffer) {
            dc.drawBitmap(0, 0, _offscreenBuffer);
        }
    }

    public function onEnterSleep() as Void {
        _isAwake = false;
        WatchUi.requestUpdate();
    }

    public function onExitSleep() as Void {
        _isAwake = true;
    }

    public function turnPartialUpdatesOff() as Void {
        _partialUpdatesAllowed = false;
    }
}

class GuruFaceDelegate extends WatchUi.WatchFaceDelegate {

    private var _view as GuruFaceView;

    public function initialize(view as GuruFaceView) {
        WatchFaceDelegate.initialize();
        _view = view;
    }

    public function onPowerBudgetExceeded(powerInfo as WatchFacePowerInfo) as Void {
        System.println("Average execution time: " + powerInfo.executionTimeAverage);
        System.println("Allowed execution time: " + powerInfo.executionTimeLimit);
        _view.turnPartialUpdatesOff();
    }
}
