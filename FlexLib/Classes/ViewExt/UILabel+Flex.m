/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */


#import "UILabel+Flex.h"
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
static NameValue _breakMode[] =
{
    {"wordWrapping", NSLineBreakByWordWrapping},
    {"charWrapping", NSLineBreakByCharWrapping},
    {"clipping", NSLineBreakByClipping},
    {"truncatingHead", NSLineBreakByTruncatingHead},
    {"truncatingTail", NSLineBreakByTruncatingTail},
    {"truncatingMiddle", NSLineBreakByTruncatingMiddle},
};


@implementation UILabel (Flex)

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
FLEXSET(lineBreakMode)
{
    NSLineBreakMode mode = (NSLineBreakMode) NSString2Int(sValue,_breakMode,sizeof(_breakMode)/sizeof(NameValue));
    self.lineBreakMode = mode;
}
FLEXSET(linesNum)
{
    int n = (int)[sValue integerValue];
    if(n>=0){
        self.numberOfLines = n;
    }
}
FLEXSET(color)
{
    UIColor* clr = colorFromString(sValue);
    if(clr!=nil){
        self.textColor = clr ;
    }
}
FLEXSET(shadowColor)
{
    UIColor* clr = colorFromString(sValue);
    if(clr!=nil){
        self.shadowColor = clr ;
    }
}
FLEXSET(highlightTextColor)
{
    UIColor* clr = colorFromString(sValue);
    if(clr!=nil){
        self.highlightedTextColor = clr ;
    }
}
FLEXSET(textAlign)
{
    const char* c =  [sValue cStringUsingEncoding:NSASCIIStringEncoding];
    self.textAlignment = (NSTextAlignment)String2Int(c, _align, sizeof(_align)/sizeof(NameValue));
}
FLEXSET(interactEnable)
{
    self.userInteractionEnabled = String2BOOL(sValue);
}
FLEXSET(enabled)
{
    self.enabled = String2BOOL(sValue);
}
FLEXSET(adjustFontSize)
{
    self.adjustsFontSizeToFitWidth = String2BOOL(sValue);
}
@end
