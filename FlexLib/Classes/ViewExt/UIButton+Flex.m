/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */


#import "UIButton+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"


@implementation UIButton (Flex)

FLEXSET(title)
{
    [self setTitle:sValue forState:UIControlStateNormal];
}
FLEXSET(color)
{
    UIColor* clr = colorFromString(sValue);
    if(clr!=nil){
        [self setTitleColor:clr forState:UIControlStateNormal];
    }
}
@end
