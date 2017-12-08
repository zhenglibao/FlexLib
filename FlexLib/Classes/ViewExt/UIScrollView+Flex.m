/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */


#import "UIScrollView+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"


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
@end
