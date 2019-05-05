/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "FlexFrameView.h"
#import "FlexRootView.h"
#import "YogaKit/UIView+Yoga.h"

static void* gObserverFrame = &gObserverFrame;

@interface FlexFrameView()
{
    FlexRootView* _flexRootView;
    BOOL _bObserved;
}
@end

@implementation FlexFrameView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
-(instancetype)initWithFlex:(NSString*)flexname
                      Frame:(CGRect)frame
                      Owner:(NSObject*)owner
{
    self = [self initWithFrame:frame];
    
    if(self){        
        if(owner == nil)
            owner = self;
        
        _flexRootView = [FlexRootView loadWithNodeFile:flexname Owner:owner];
        [self addSubview:_flexRootView];
        
        if(!_bObserved){
            [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:gObserverFrame];
            _bObserved = YES;
        }
    }
    return self;
}
- (void)dealloc
{
    if(_bObserved){
        [self removeObserver:self forKeyPath:@"frame"];
    }
}
-(FlexRootView*)rootView
{
    return _flexRootView;
}
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView*)object change:(NSDictionary *)change context:(void *)context
{
    if(context == gObserverFrame){
        
        CGSize szNew = [[change objectForKey:@"new"]CGRectValue].size;
        CGSize szOld = [[change objectForKey:@"old"]CGRectValue].size;
        if(!CGSizeEqualToSize(szNew, szOld))
            [_flexRootView setNeedsLayout];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void)layoutSubviews
{
    [_flexRootView layoutIfNeeded];
}
-(void)subFrameChanged:(UIView*)subView
                  Rect:(CGRect)newFrame
{
    if(!(self.flexibleWidth||self.flexibleHeight)){
        return;
    }
    
    CGRect rc = self.frame ;
    UIEdgeInsets safeArea = _flexRootView.safeArea;
    if(self.flexibleWidth){
        rc.size.width = CGRectGetWidth(newFrame) + safeArea.left + safeArea.right ;
    }
    if(self.flexibleHeight){
        rc.size.height = CGRectGetHeight(newFrame) + safeArea.top + safeArea.bottom;
    }
    
    if(!CGSizeEqualToSize(rc.size,self.frame.size))
    {
        self.frame = rc ;
        if(self.onFrameChange != nil)
        {
            self.onFrameChange(rc);
        }
    }
}
-(void)setFlexibleWidth:(BOOL)flexibleWidth
{
    _flexRootView.flexibleWidth = flexibleWidth ;
}
-(BOOL)flexibleWidth
{
    return _flexRootView.flexibleWidth;
}
-(void)setFlexibleHeight:(BOOL)flexibleHeight
{
    _flexRootView.flexibleHeight = flexibleHeight ;
}
-(BOOL)flexibleHeight
{
    return _flexRootView.flexibleHeight;
}
- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize
{
    return [_flexRootView calculateSize:targetSize];
}
- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority
{
    return [_flexRootView calculateSize:targetSize];
}
@end
