/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "NSStepper+Flex.h"
#import "NSView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

@implementation NSStepper (Flex)


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

FLEXSET(stepValue)
{
    self.increment = [sValue doubleValue];
}

FLEXSET(autorepeat)
{
    self.autorepeat = String2BOOL(sValue);
}

FLEXSET(wraps)
{
    self.valueWraps = String2BOOL(sValue);
}

@end
