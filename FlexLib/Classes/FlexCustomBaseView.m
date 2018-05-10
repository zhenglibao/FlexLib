/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "FlexCustomBaseView.h"
#import "FlexNode.h"
#import "FlexFrameView.h"
#import "FlexRootView.h"
#import "FlexUtils.h"

static void* gObserverFrame = &gObserverFrame;

@interface FlexCustomBaseView()
{
    FlexFrameView* _frameView;
    BOOL _bObserved;
}
@end

@implementation FlexCustomBaseView

-(instancetype)init
{
    self = [super init];
    if(self){
        [self inflateFromLayout:CGRectZero];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self inflateFromLayout:frame];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self inflateFromLayout:CGRectZero];
    }
    return self;
}
- (void)dealloc
{
    if(_bObserved){
        [self removeObserver:self forKeyPath:@"frame"];
    }
}
-(NSString*)getFlexName
{
    return NSStringFromClass([self class]);
}
-(void)onInit
{
}
-(void)inflateFromLayout:(CGRect)frame
{
    if(_frameView == nil){
        __weak FlexCustomBaseView* weakSelf = self;
        
        CGRect rcFrameView = frame;
        rcFrameView.origin = CGPointZero;
        
        _frameView = [[FlexFrameView alloc]initWithFlex:[self getFlexName] Frame:rcFrameView Owner:self];
        _frameView.onFrameChange = ^(CGRect rc){
            if(!CGSizeEqualToSize(rc.size, weakSelf.frame.size)){
                [weakSelf markDirty];
            }
        };
        [self addSubview:_frameView];
        
        if(!_bObserved){
            [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:gObserverFrame];
            _bObserved = YES;
        }
        
        [self onInit];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView*)object change:(NSDictionary *)change context:(void *)context
{
    if(context == gObserverFrame){
        
        CGSize szNew = [[change objectForKey:@"new"]CGRectValue].size;
        if(!CGSizeEqualToSize(szNew, _frameView.frame.size))
        {
            CGRect rc = _frameView.frame;
            rc.size = szNew;
            _frameView.frame = rc;
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(CGSize)sizeThatFits:(CGSize)size
{
    CGSize sz=[_frameView.rootView calculateSize:size];
    return sz;
}
-(void)setFlexibleWidth:(BOOL)flexibleWidth
{
    _frameView.flexibleWidth = flexibleWidth ;
}
-(BOOL)flexibleWidth
{
    return _frameView.flexibleWidth;
}
-(void)setFlexibleHeight:(BOOL)flexibleHeight
{
    _frameView.flexibleHeight = flexibleHeight ;
}
-(BOOL)flexibleHeight
{
    return _frameView.flexibleHeight;
}

FLEXSET(flexibleWidth)
{
    self.flexibleWidth = String2BOOL(sValue);
}
FLEXSET(flexibleHeight)
{
    self.flexibleHeight = String2BOOL(sValue);
}
@end
