/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "UISlider+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"


@implementation UISlider (Flex)

FLEXSET(value)
{
    self.value = [sValue floatValue];
}

FLEXSET(minValue)
{
    self.minimumValue = [sValue floatValue];
}

FLEXSET(maxValue)
{
    self.maximumValue = [sValue floatValue];
}

FLEXSET(continuous)
{
    self.continuous = String2BOOL(sValue);
}

FLEXSET(minTintColor)
{
    self.minimumTrackTintColor = colorFromString(sValue,owner);
}

FLEXSET(maxTintColor)
{
    self.maximumTrackTintColor = colorFromString(sValue,owner);
}

FLEXSET(thumbTintColor)
{
    self.thumbTintColor = colorFromString(sValue,owner);
}

@end
