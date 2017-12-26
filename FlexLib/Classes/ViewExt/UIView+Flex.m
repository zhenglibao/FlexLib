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

static const void *kFlexViewAttrAssociatedKey = &kFlexViewAttrAssociatedKey;

@implementation FlexViewAttrs

@end

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

- (FlexViewAttrs *)viewAttrs
{
    FlexViewAttrs *attrs = objc_getAssociatedObject(self, kFlexViewAttrAssociatedKey);
    if (!attrs) {
        attrs = [[FlexViewAttrs alloc] init];
        objc_setAssociatedObject(self, kFlexViewAttrAssociatedKey, attrs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return attrs;
}

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
    UIColor* clr = colorFromString(sValue,owner) ;
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
    self.layer.borderColor = colorFromString(sValue,owner).CGColor ;
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
    self.layer.shadowColor = colorFromString(sValue,owner).CGColor ;
}
FLEXSETENUM(contentMode, _gcontentModes)
FLEXSETFLT(alpha)
FLEXSETBOOL(hidden)
FLEXSETBOOL(clipsToBounds)
FLEXSETCLR(tintColor)
FLEXSETINT(tag)

FLEXSET(stickTop){
    self.viewAttrs.stickTop = String2BOOL(sValue);
}
@end
