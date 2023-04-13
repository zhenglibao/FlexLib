/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "UIActivityIndicatorView+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

static NameValue _gstyle[] =
{
    {"whiteLarge", UIActivityIndicatorViewStyleWhiteLarge},
    {"white", UIActivityIndicatorViewStyleWhite},
    {"gray", UIActivityIndicatorViewStyleGray},
};

@implementation UIActivityIndicatorView (Flex)

FLEXSET(style)
{
    self.activityIndicatorViewStyle = NSString2Int(sValue, _gstyle, sizeof(_gstyle)/sizeof(NameValue)) ;
}
FLEXSET(color)
{
    UIColor* clr = colorFromString(sValue,owner);
    if(clr!=nil){
        self.color = clr;
    }
}
@end
