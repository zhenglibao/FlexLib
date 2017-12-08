/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */


#import "UITextView+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

static NameValue _align[] =
{
    {"left", NSTextAlignmentLeft},
    {"center", NSTextAlignmentCenter},
    {"right", NSTextAlignmentRight},
    {"justified", NSTextAlignmentJustified},
    {"natural", NSTextAlignmentNatural},
};

@implementation UITextView (Flex)

FLEXSET(text)
{
    self.text = sValue ;
}
FLEXSET(fontSize)
{
    float nSize = [sValue floatValue];
    if(nSize > 0){
        UIFont* font = [UIFont systemFontOfSize:nSize];
        self.font = font;
    }
}
FLEXSET(color)
{
    UIColor* clr = colorFromString(sValue);
    if(clr!=nil){
        self.textColor = clr ;
    }
}

FLEXSET(textAlign)
{
    self.textAlignment = (NSTextAlignment)NSString2Int(sValue, _align, sizeof(_align)/sizeof(NameValue));
}

FLEXSET(editable)
{
    self.editable = String2BOOL(sValue);
}
FLEXSET(selectable)
{
    self.selectable = String2BOOL(sValue);
}
@end
