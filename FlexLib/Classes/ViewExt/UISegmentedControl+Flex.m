/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "UISegmentedControl+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"


@implementation UISegmentedControl (Flex)


FLEXSET(selectedIndex)
{
    self.selectedSegmentIndex = [sValue integerValue];
}
FLEXSET(tintColor)
{
    self.tintColor = colorFromString(sValue,owner);
}

@end
