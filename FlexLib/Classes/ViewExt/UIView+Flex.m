/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"
#import "../YogaKit/UIView+Yoga.h"
#import "../FlexRootView.h"

static NameValue _gcontentModes[] =
{
    {"scaleToFill",UIViewContentModeScaleToFill},
    {"scaleAspectFit",UIViewContentModeScaleAspectFit},
    {"scaleAspectFill",UIViewContentModeScaleAspectFill},
    {"redraw",UIViewContentModeRedraw},
    {"center",UIViewContentModeCenter},
    {"top",UIViewContentModeTop},
    {"bottom",UIViewContentModeBottom},
    {"left",UIViewContentModeLeft},
    {"right",UIViewContentModeRight},
    {"topLeft",UIViewContentModeTopLeft},
    {"topRight",UIViewContentModeTopRight},
    {"bottomLeft",UIViewContentModeBottomLeft},
    {"bottomRight",UIViewContentModeBottomRight},
};

@implementation UIView (Flex)

#pragma mark - override

-(void)subFrameChanged:(UIView*)subView
                  Rect:(CGRect)newFrame
{
}

-(void)superFrameChanged
{
}

-(void)postCreate
{
}

#pragma mark - attribute

FLEXSET(bgColor)
{
    UIColor* clr = colorFromString(sValue) ;
    if(clr!=nil){
        self.backgroundColor = clr ;
    }
}

FLEXSET(borderWidth)
{
    CGFloat f = [sValue floatValue] ;
    self.layer.borderWidth = f ;
}
FLEXSET(borderColor)
{
    self.layer.borderColor = colorFromString(sValue).CGColor ;
}
FLEXSET(borderRadius)
{
    CGFloat f = [sValue floatValue] ;
    self.layer.cornerRadius = f ;
}
FLEXSET(shadowOffset)
{
    NSArray* ary = [sValue componentsSeparatedByString:@"/"];
    if(ary.count==2){
        CGFloat f1 = [ary[0] floatValue] ;
        CGFloat f2 = [ary[1] floatValue] ;
        self.layer.shadowOffset = CGSizeMake(f1, f2) ;
    }
}
FLEXSET(shadowRadius)
{
    CGFloat f = [sValue floatValue] ;
    self.layer.shadowRadius = f ;
}
FLEXSET(shadowColor)
{
    self.layer.shadowColor = colorFromString(sValue).CGColor ;
}
FLEXSET(contentMode)
{
    UIViewContentMode mode = (UIViewContentMode) NSString2Int(sValue,_gcontentModes,sizeof(_gcontentModes)/sizeof(NameValue));
    self.contentMode = mode;
}
FLEXSET(alpha)
{
    CGFloat f = [sValue floatValue] ;
    self.alpha = f ;
}
FLEXSET(hidden)
{
    self.hidden = String2BOOL(sValue);
}
FLEXSET(tintColor)
{
    UIColor* clr = colorFromString(sValue) ;
    if(clr!=nil){
        self.tintColor = clr ;
    }
}
@end
