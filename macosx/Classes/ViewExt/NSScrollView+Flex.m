/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "NSScrollView+Flex.h"
#import "NSView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"


@implementation NSScrollView (Flex)

FLEXSET(horzIndicator)
{
    self.hasHorizontalScroller = String2BOOL(sValue);
}
FLEXSET(vertIndicator)
{
    self.hasVerticalScroller = String2BOOL(sValue);
}
//FLEXSET(pageEnabled)
//{
//    self.pag = String2BOOL(sValue);
//}
//FLEXSET(scrollEnabled)
//{
//    self.scrollEnabled = String2BOOL(sValue);
//}
//FLEXSET(bounces)
//{
//    self.bounces = String2BOOL(sValue);
//}
//
//FLEXSET(indicatorStyle)
//{
//    self.indicatorStyle = FLEXSTR2INT(_gstyle);
//}
//
//FLEXSET(alwaysBounceVertical)
//{
//    self.alwaysBounceVertical = String2BOOL(sValue);
//}
//FLEXSET(alwaysBounceHorizontal)
//{
//    self.alwaysBounceHorizontal = String2BOOL(sValue);
//}

@end
