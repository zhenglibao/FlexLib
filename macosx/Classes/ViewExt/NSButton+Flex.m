/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "NSButton+Flex.h"
#import "NSView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

static NameValue _bezelStyle[] =
{
    {"rounded",NSBezelStyleRounded},
    {"regularSquare",NSBezelStyleRegularSquare},
    {"disclosure",NSBezelStyleDisclosure},
    {"shadowlessSquare",NSBezelStyleShadowlessSquare},
    {"circular",NSBezelStyleCircular},
    {"texturedSquare",NSBezelStyleTexturedSquare},
    {"helpButton",NSBezelStyleHelpButton},
    {"smallSquare",NSBezelStyleSmallSquare},
    {"texturedRounded",NSBezelStyleTexturedRounded},
    {"roundRect",NSBezelStyleRoundRect},
    {"recessed",NSBezelStyleRecessed},
    {"disclosure",NSBezelStyleRoundedDisclosure},
    {"inline",NSBezelStyleInline},
};

static NameValue _cellImagePosition[] =
{
    {"noImage",NSNoImage},
    {"imageOnly",NSImageOnly},
    {"imageLeft",NSImageLeft},
    {"imageRight",NSImageRight},
    {"imageBelow",NSImageBelow},
    {"imageAbove",NSImageAbove},
    {"imageOverlaps",NSImageOverlaps},
    {"imageLeading",NSImageLeading},
    {"imageTrailing",NSImageTrailing},
};

static NameValue _scaling[] =
{
    {"proportDown", NSImageScaleProportionallyDown},
    {"axesIndepend", NSImageScaleAxesIndependently},
    {"none", NSImageScaleNone},
    {"proportUpDown", NSImageScaleProportionallyUpOrDown},
};


static NameValue _state[] =
{
    {"mixed", NSControlStateValueMixed},
    {"off", NSControlStateValueOff},
    {"on", NSControlStateValueOn},
};

static NameValue _modifiedFlag[] =
{
    {"capslock", NSEventModifierFlagCapsLock},
    {"shift", NSEventModifierFlagShift},
    {"control", NSEventModifierFlagControl},
    {"option", NSEventModifierFlagOption},
    {"command", NSEventModifierFlagCommand},
    {"numericPad", NSEventModifierFlagNumericPad},
    {"help", NSEventModifierFlagHelp},
    {"function", NSEventModifierFlagFunction},
    {"deviceIndependent", NSEventModifierFlagDeviceIndependentFlagsMask},
};


@implementation NSButton (Flex)

FLEXSET(title)
{
    self.title = sValue;
}
FLEXSET(alternateTitle)
{
    self.alternateTitle = sValue;
}

FLEXSETBOOL(springLoaded)

FLEXSETINT(maxAcceleratorLevel)

FLEXSETENUM(bezelStyle, _bezelStyle)

FLEXSETBOOL(bordered)

FLEXSETBOOL(transparent)

FLEXSETBOOL(showsBorderOnlyWhileMouseInside)

FLEXSETENUM(imagePosition, _cellImagePosition)

FLEXSET(imageScaling)
{
    const char* c =  [sValue cStringUsingEncoding:NSASCIIStringEncoding];
    self.imageScaling = (NSImageScaling)String2Int(c, _scaling, sizeof(_scaling)/sizeof(NameValue));
}

FLEXSETBOOL(imageHugsTitle)

FLEXSETCLR(bezelColor)

FLEXSET(contentTintColor)
{
    NSColor* clr = colorFromString(sValue, owner);
    if (clr) {
        if (@available(macOS 10.14, *)) {
            self.contentTintColor = clr;
        } else {
            // Fallback on earlier versions
        }
    }
}

FLEXSETENUM(state, _state)

FLEXSETBOOL(allowsMixedState)

FLEXSETSTR(keyEquivalent)

FLEXSETENUM(keyEquivalentModifierMask, _modifiedFlag)


@end
