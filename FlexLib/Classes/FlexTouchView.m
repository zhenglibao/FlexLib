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

@interface FlexTouchView()
{
    CGFloat _activeOpacity;
    UIColor* _underlayColor;
    UIColor* _bgColor;
    
    CGFloat _oldAlpha;
}
@end

@implementation FlexTouchView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _activeOpacity = 1.0f;
        _underlayColor = nil;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setActiveStatus:YES];
//    UITouch *touch1 = [touches anyObject];
//    CGPoint touchLocation = [touch1 locationInView:self.finalScore];
//    CGRect startRect = [[[cup layer] presentationLayer] frame];
//    CGRectContainsPoint(startRect, touchLocation);

}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setActiveStatus:NO];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setActiveStatus:NO];
}

-(void)setActiveStatus:(BOOL)bActive
{
    [UIView animateWithDuration:0.2 animations:^{
        if (bActive) {
            _oldAlpha = self.alpha ;
            _bgColor = self.backgroundColor ;
            self.alpha = _activeOpacity;
            if(_underlayColor != nil)
                self.backgroundColor = _underlayColor ;
        } else {
            self.alpha = _oldAlpha;
            self.backgroundColor = _bgColor ;
        }
    }];
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
    _underlayColor = colorFromString(sValue);
}

@end
