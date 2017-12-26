/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "UITextField+Flex.h"
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
static NameValue _gBorderStyle[] =
{
    {"none", UITextBorderStyleNone},
    {"line", UITextBorderStyleLine},
    {"bezel", UITextBorderStyleBezel},
    {"roundRect", UITextBorderStyleRoundedRect},
};

@implementation UITextField (Flex)

FLEXSET(text)
{
    self.text = sValue ;
}
FLEXSET(placeHolder)
{
    self.placeholder = sValue ;
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
    UIColor* clr = colorFromString(sValue,owner);
    if(clr!=nil){
        self.textColor = clr ;
    }
}

FLEXSET(textAlign)
{
    self.textAlignment = (NSTextAlignment)NSString2Int(sValue, _align, sizeof(_align)/sizeof(NameValue));
}
FLEXSET(boderStyle)
{
    self.borderStyle = (UITextBorderStyle)NSString2Int(sValue, _gBorderStyle, sizeof(_gBorderStyle)/sizeof(NameValue));
}
FLEXSET(interactEnable)
{
    self.userInteractionEnabled = String2BOOL(sValue);
}

FLEXSET(adjustFontSize)
{
    self.adjustsFontSizeToFitWidth = String2BOOL(sValue);
}
@end
