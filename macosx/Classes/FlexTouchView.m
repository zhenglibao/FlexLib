/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "FlexTouchView.h"
#import "FlexUtils.h"
#import "FlexTouchMaskView.h"

@interface FlexTouchView()
{
    FlexTouchMaskView* _maskView;
    CGFloat _activeOpacity;
    NSColor* _underlayColor;
    double _activeStartAt;
    
    NSColor* _bgColor;
    CGFloat _oldAlpha;
    BOOL _bActive;
}
@end

@implementation FlexTouchView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _activeOpacity = 1.0f;
        _underlayColor = nil;
        self.wantsLayer = YES;
    }
    return self;
}
-(FlexTouchMaskView*)findMaskView:(NSView*)parent
{
    for (NSView* sub in parent.subviews) {
        if( [sub isKindOfClass:[FlexTouchMaskView class]])
            return (FlexTouchMaskView*)sub;
        FlexTouchMaskView* mask = [self findMaskView:sub];
        if(mask != nil)
            return mask;
    }
    return nil;
}
-(void)postCreate
{
    _maskView = [self findMaskView:self];
}

#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(NSEvent *)event
{
    [self setActiveStatus:YES];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(NSEvent *)event
{
}
- (void)touchesEnded:(NSSet *)touches withEvent:(NSEvent *)event
{
    [self setActiveStatus:NO];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(NSEvent *)event
{
    [self setActiveStatus:NO];
}

-(void)setActiveStatus:(BOOL)bActive
{
    const double duration = 0.1 ;
    __weak FlexTouchView* weakSelf = self;
    
    if(bActive){
        if(_bActive)
            return;
        
        _bActive = YES;
        
        if(self.onTouch != nil){
            self.onTouch(YES);
        }
        
        if(_maskView != nil){
            CGSize szParent = _maskView.superview.frame.size;
            _maskView.frame = CGRectMake(0, 0, szParent.width, szParent.height);
        }
        _activeStartAt = GetAccurateSecondsSince1970();
        //[NSView animateWithDuration:duration animations:^{
            [weakSelf setAnimProperty:YES];
        //}];
    }else if(_bActive){
        _bActive = NO ;
        
        if(self.onTouch != nil){
            self.onTouch(NO);
        }
        
        double now = GetAccurateSecondsSince1970();
        double delay = duration - (now - _activeStartAt);
        if(delay<0) delay = 0;
        
        //[NSView animateWithDuration:duration delay:delay options:0 animations:^{
            [weakSelf setAnimProperty:NO];
        //}completion:nil];
    }
}

-(void)setAnimProperty:(BOOL)bActive
{
    if(bActive){
        _oldAlpha = self.alphaValue ;
        _bgColor = self.layer.backgroundColor ;
        self.alphaValue = _activeOpacity;
        if(_underlayColor != nil)
            self.layer.backgroundColor = [_underlayColor CGColor] ;
        if(_maskView != nil)
        {
            _maskView.hidden = NO ;
        }
    }else{
        self.alphaValue = _oldAlpha;
        self.layer.backgroundColor = [_bgColor CGColor] ;
        if(_maskView != nil)
            _maskView.hidden = YES;
    }
}

FLEXSET(activeOpacity)
{
    _activeOpacity = [sValue floatValue];
    if(_activeOpacity>1)
        _activeOpacity = 1;
    else if(_activeOpacity<0)
        _activeOpacity = 0;
}

FLEXSET(underlayColor)
{
    _underlayColor = colorFromString(sValue,owner);
}

@end
