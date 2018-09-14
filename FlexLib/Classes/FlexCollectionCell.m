/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "FlexCollectionCell.h"
#import "FlexRootView.h"

static void* gObserverFrame         = &gObserverFrame;

@interface FlexCollectionCell()
{
    FlexRootView* _flexRootView ;
    BOOL _bObserved;
}
@end

@implementation FlexCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInit:nil];
    }
    return self;
}

-(void)internalInit:(NSString*)flexName
{
    if(_flexRootView!=nil)
        return;
    
    __weak FlexCollectionCell* weakSelf = self;
    
    _flexRootView = [FlexRootView loadWithNodeFile:flexName Owner:self];
    _flexRootView.onDidLayout = ^{
        [weakSelf onRootViewDidLayout];
    };
    [self.contentView addSubview:_flexRootView];
    
    if(!_bObserved){
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:gObserverFrame];
        _bObserved = YES;
    }
    
    [self onInit];
}
- (void)dealloc
{
    if(_bObserved){
        [self removeObserver:self forKeyPath:@"frame"];
    }
}

-(void)onInit{
    
}
-(FlexRootView*)rootview
{
    return _flexRootView;
}
- (void)onRootViewDidLayout
{
    CGRect rcRootView = _flexRootView.frame ;
    if(!CGSizeEqualToSize(self.frame.size,rcRootView.size))
    {
        if(self.onContentSizeChanged != nil){
            self.onContentSizeChanged(rcRootView.size);
        }
    }
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

-(CGSize)calculateSize:(CGSize)szLimit
{
    return [_flexRootView calculateSize:szLimit];
}

@end
