/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "UIScrollView+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

static NameValue _gstyle[] =
{
    {"default", UIScrollViewIndicatorStyleDefault},
    {"black", UIScrollViewIndicatorStyleBlack},
    {"white", UIScrollViewIndicatorStyleWhite},
};


@implementation UIScrollView (Flex)

FLEXSET(horzIndicator)
{
    self.showsHorizontalScrollIndicator = String2BOOL(sValue);
}
FLEXSET(vertIndicator)
{
    self.showsVerticalScrollIndicator = String2BOOL(sValue);
}
FLEXSET(pageEnabled)
{
    self.pagingEnabled = String2BOOL(sValue);
}
FLEXSET(scrollEnabled)
{
    self.scrollEnabled = String2BOOL(sValue);
}
FLEXSET(bounces)
{
    self.bounces = String2BOOL(sValue);
}

FLEXSET(indicatorStyle)
{
    self.indicatorStyle = FLEXSTR2INT(_gstyle);
}

FLEXSET(alwaysBounceVertical)
{
    self.alwaysBounceVertical = String2BOOL(sValue);
}
FLEXSET(alwaysBounceHorizontal)
{
    self.alwaysBounceHorizontal = String2BOOL(sValue);
}

@end
