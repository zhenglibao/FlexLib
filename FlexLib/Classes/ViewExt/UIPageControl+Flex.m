/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "UIPageControl+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"


@implementation UIPageControl (Flex)

FLEXSET(numberOfPages)
{
    self.numberOfPages = [sValue integerValue];
}

FLEXSET(currentPage)
{
    self.currentPage = [sValue integerValue];
}

FLEXSET(hidesForSinglePage)
{
    self.hidesForSinglePage = String2BOOL(sValue);
}

FLEXSET(pageTintColor)
{
    self.pageIndicatorTintColor = colorFromString(sValue,owner);
}

FLEXSET(curPageTintColor)
{
    self.currentPageIndicatorTintColor = colorFromString(sValue,owner);
}
@end
