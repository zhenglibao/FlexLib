/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "UIProgressView+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

static NameValue _gstyle[] =
{
    {"default", UIProgressViewStyleDefault},
    {"bar", UIProgressViewStyleBar},
};

@implementation UIProgressView (Flex)

FLEXSET(style)
{
    self.progressViewStyle = FLEXSTR2INT(_gstyle);
}

FLEXSET(progress)
{
    self.progress = [sValue floatValue];
}

FLEXSET(progressTintColor)
{
    self.progressTintColor = colorFromString(sValue,owner);
}

FLEXSET(trackTintColor)
{
    self.trackTintColor = colorFromString(sValue,owner);
}
@end
