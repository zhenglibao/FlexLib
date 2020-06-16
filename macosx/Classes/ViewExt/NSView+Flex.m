/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "NSView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"
#import "../YogaKit/NSView+Yoga.h"
#import "../FlexRootView.h"

static const void *kFlexViewAttrAssociatedKey = &kFlexViewAttrAssociatedKey;

@implementation FlexViewAttrs

@end



@implementation NSView (Flex)

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

-(void)subFrameChanged:(NSView*)subView
                  Rect:(CGRect)newFrame
{
}

-(void)superFrameChanged
{
}

-(void)postCreate
{
}

-(void)afterInit:(NSObject*)owner
        rootView:(FlexRootView*)rootView
{
}

-(void)addSubviewFromXml:(NSView*)view
{
    [self addSubview:view];
}

#pragma mark - attribute

FLEXSET(bgColor)
{
    NSColor* clr = colorFromString(sValue,owner) ;
    if(clr!=nil){
        self.wantsLayer = YES;
        self.layer.backgroundColor = [clr CGColor] ;
    }
}

FLEXSET(font)
{
    SEL sel = @selector(setFont:);
    NSMethodSignature* sig = [self.class instanceMethodSignatureForSelector:sel];
    if(sig == nil)
    {
        NSLog(@"Flexbox: no setFont: in class %@",[self class]);
        return ;
    }
    
    NSFont* font = fontFromString(sValue);
    if(font==nil){
        return;
    }
    
    @try{
        
        NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig] ;
        [inv setTarget:self];
        [inv setSelector:sel];
        [inv setArgument:&font atIndex:2];
        
        [inv invoke];
    }@catch(NSException* e){
        NSLog(@"Flexbox: setFont: called failed.");
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
FLEXSET(shadowOpacity)
{
    CGFloat f = [sValue floatValue] ;
    self.layer.shadowOpacity = f ;
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


FLEXSET(stickTop){
    self.viewAttrs.stickTop = String2BOOL(sValue);
}
FLEXSET(layerBounds)
{
    NSArray* ary = [sValue componentsSeparatedByString:@"/"];
    if(ary.count==4){
        CGFloat f1 = [ary[0] floatValue] ;
        CGFloat f2 = [ary[1] floatValue] ;
        CGFloat f3 = [ary[3] floatValue] ;
        CGFloat f4 = [ary[4] floatValue] ;
        self.layer.bounds = CGRectMake(f1, f2, f3, f4);
    }
}
FLEXSET(layerPosition)
{
    NSArray* ary = [sValue componentsSeparatedByString:@"/"];
    if(ary.count==2){
        CGFloat f1 = [ary[0] floatValue] ;
        CGFloat f2 = [ary[1] floatValue] ;
        self.layer.position = CGPointMake(f1, f2);
    }
}
FLEXSET(layerZPosition)
{
    CGFloat f = [sValue floatValue];
    self.layer.zPosition = f;
}
FLEXSET(layerAnchorPoint)
{
    NSArray* ary = [sValue componentsSeparatedByString:@"/"];
    if(ary.count==2){
        CGFloat f1 = [ary[0] floatValue] ;
        CGFloat f2 = [ary[1] floatValue] ;
        self.layer.anchorPoint = CGPointMake(f1, f2);
    }
}
FLEXSET(layerAnchorPointZ)
{
    self.layer.anchorPointZ = [sValue floatValue];
}
FLEXSET(layerFrame)
{
    NSArray* ary = [sValue componentsSeparatedByString:@"/"];
    if(ary.count==4){
        CGFloat f1 = [ary[0] floatValue] ;
        CGFloat f2 = [ary[1] floatValue] ;
        CGFloat f3 = [ary[3] floatValue] ;
        CGFloat f4 = [ary[4] floatValue] ;
        self.layer.frame = CGRectMake(f1, f2, f3, f4);
    }
}
FLEXSET(layerHidden)
{
    self.layer.hidden = String2BOOL(sValue);
}
FLEXSET(layerDoubleSided)
{
    self.layer.doubleSided = String2BOOL(sValue);
}
FLEXSET(layerGeometryFlipped)
{
    self.layer.geometryFlipped = String2BOOL(sValue);
}
FLEXSET(layerMasksToBounds)
{
    self.layer.masksToBounds = String2BOOL(sValue);
}
FLEXSET(masksToBounds)
{
    self.layer.masksToBounds = String2BOOL(sValue);
}
FLEXSET(layerContentsRect)
{
    NSArray* ary = [sValue componentsSeparatedByString:@"/"];
    if(ary.count==4){
        CGFloat f1 = [ary[0] floatValue] ;
        CGFloat f2 = [ary[1] floatValue] ;
        CGFloat f3 = [ary[3] floatValue] ;
        CGFloat f4 = [ary[4] floatValue] ;
        self.layer.contentsRect = CGRectMake(f1, f2, f3, f4);
    }
}
FLEXSET(layerContentsGravity)
{
    self.layer.contentsGravity = sValue;
}
FLEXSET(layerContentsScale)
{
    self.layer.contentsScale = [sValue floatValue];
}
FLEXSET(layerContentsCenter)
{
    NSArray* ary = [sValue componentsSeparatedByString:@"/"];
    if(ary.count==4){
        CGFloat f1 = [ary[0] floatValue] ;
        CGFloat f2 = [ary[1] floatValue] ;
        CGFloat f3 = [ary[3] floatValue] ;
        CGFloat f4 = [ary[4] floatValue] ;
        self.layer.contentsCenter = CGRectMake(f1, f2, f3, f4);
    }
}
FLEXSET(layerContentsFormat)
{
    if (@available(macOS 10.12, *)) {
        self.layer.contentsFormat = sValue;
    } else {
        // Fallback on earlier versions
    }
}
FLEXSET(layerMinificationFilter)
{
    self.layer.minificationFilter = sValue;
}
FLEXSET(layerMagnificationFiltery)
{
    self.layer.magnificationFilter = sValue;
}
FLEXSET(layerMinificationFilterBias)
{
    self.layer.minificationFilterBias = [sValue floatValue];
}
FLEXSET(layerOpaque)
{
    self.layer.opaque = String2BOOL(sValue);
}
FLEXSET(layerNeedsDisplayOnBoundsChange)
{
    self.layer.needsDisplayOnBoundsChange = String2BOOL(sValue);
}
FLEXSET(layerDrawsAsynchronously)
{
    self.layer.drawsAsynchronously = String2BOOL(sValue);
}
FLEXSET(layerAllowsEdgeAntialiasing)
{
    self.layer.allowsEdgeAntialiasing = String2BOOL(sValue);
}
FLEXSET(layerBackgroundColor)
{
    self.layer.backgroundColor = colorFromString(sValue, owner).CGColor;
}
FLEXSET(layerCornerRadius)
{
    self.layer.cornerRadius = [sValue floatValue];
}
FLEXSET(layerOpacity)
{
    self.layer.opacity = [sValue floatValue];
}
FLEXSET(allowsGroupOpacity)
{
    self.layer.allowsGroupOpacity = String2BOOL(sValue);
}
FLEXSET(shouldRasterize)
{
    self.layer.shouldRasterize = String2BOOL(sValue);
}
FLEXSET(rasterizationScale)
{
    self.layer.rasterizationScale = [sValue floatValue];
}
FLEXSET(layerName)
{
    self.layer.name = sValue;
}

FLEXSET(value)
{
    NSLog(@"%@ not implement value property, NSView.value should not be called.",self.class);
}

@end
