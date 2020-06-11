/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "NSSlider+Flex.h"
#import "NSView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"


static NameValue _sliderType[] =
{
    {"linear",NSSliderTypeLinear},
    {"circular",NSSliderTypeCircular},
};

static NameValue _markPosition[] =
{
    {"below",NSTickMarkPositionBelow},
    {"above",NSTickMarkPositionAbove},
    {"leading",NSTickMarkPositionLeading},
    {"trailing",NSTickMarkPositionTrailing},
};


@implementation NSSlider (Flex)

FLEXSET(value)
{
    self.doubleValue = [sValue doubleValue];
}

FLEXSET(minValue)
{
    self.minValue = [sValue doubleValue];
}

FLEXSET(maxValue)
{
    self.maxValue = [sValue doubleValue];
}
FLEXSETDBL(altIncrementValue)

FLEXSET(trackFillColor)
{
    NSColor* clr = colorFromString(sValue, owner);
    
    if (clr) {
        if (@available(macOS 10.12.2, *)) {
            self.trackFillColor = clr;
        } else {
            // Fallback on earlier versions
        }
    }
}
FLEXSETINT(numberOfTickMarks)

FLEXSETBOOL(allowsTickMarkValuesOnly)

FLEXSETENUM(tickMarkPosition, _markPosition)

FLEXSETENUM(sliderType, _sliderType)

@end
