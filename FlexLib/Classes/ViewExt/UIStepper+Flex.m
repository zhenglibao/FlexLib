/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "UIStepper+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

@implementation UIStepper (Flex)


FLEXSET(value)
{
    self.value = [sValue doubleValue];
}

FLEXSET(minValue)
{
    self.minimumValue = [sValue doubleValue];
}

FLEXSET(maxValue)
{
    self.maximumValue = [sValue doubleValue];
}

FLEXSET(stepValue)
{
    self.stepValue = [sValue doubleValue];
}

FLEXSET(continuous)
{
    self.continuous = String2BOOL(sValue);
}

FLEXSET(autorepeat)
{
    self.autorepeat = String2BOOL(sValue);
}

FLEXSET(wraps)
{
    self.wraps = String2BOOL(sValue);
}

FLEXSET(tintColor)
{
    self.tintColor = colorFromString(sValue,owner);
}

@end
