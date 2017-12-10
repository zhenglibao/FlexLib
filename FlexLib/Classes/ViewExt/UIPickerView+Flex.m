/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "UIPickerView+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"


@implementation UIPickerView (Flex)

FLEXSET(showSelIndicator)
{
    self.showsSelectionIndicator = String2BOOL(sValue);
}

@end
