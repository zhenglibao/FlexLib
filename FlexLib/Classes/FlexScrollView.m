/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "FlexScrollView.h"
#import "FlexRootView.h"
#import "FlexParentView.h"
#import "ViewExt/UIView+Flex.h"
#import "YogaKit/UIView+Yoga.h"
#import "FlexUtils.h"

@interface FlexScrollView()
{
    FlexParentView* _subview;
    FlexRootView* _contentView;
    UIView* _holder;
}
@end


@implementation FlexScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 占位的view
        _holder = [[UIView alloc]init];
        _holder.yoga.isEnabled = YES;
        [super addSubview:_holder];
        
        // 构造view tree
        __weak FlexScrollView* weakSelf = self;
        _subview = [[FlexParentView alloc]init];
        _subview.onFrameChange = ^(CGRect rc){
            weakSelf.contentSize = rc.size ;
        };
        
        _contentView = [[FlexRootView alloc]init];
        _contentView.onLayoutDone = ^{
            [weakSelf onContentViewLayoutDone];
        };
        [_subview addSubview:_contentView];
        [super addSubview:_subview];
        
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
}

-(void)onContentViewLayoutDone
{
    
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView*)object change:(NSDictionary *)change context:(void *)context
{
    CGRect rcNew = [[change objectForKey:@"new"]CGRectValue];
    
    rcNew.origin = _subview.frame.origin;
    _subview.frame = rcNew;
    [_contentView setNeedsLayout];
}

-(void)postCreate
{
#define COPYYGVALUE(prop)           \
if(from.prop.unit==YGUnitPoint||    \
    from.prop.unit==YGUnitPercent)  \
{                                   \
    to.prop = from.prop;            \
}                                   \
    
    //同步yoga属性
    YGLayout* from = self.yoga ;
    YGLayout* to = _contentView.yoga ;
    
    to.direction = from.direction ;
    to.flexDirection = from.flexDirection;
    to.justifyContent = from.justifyContent;
    to.alignItems = from.alignItems;
    to.alignSelf = from.alignSelf;
    to.flexWrap = from.flexWrap;
    to.overflow = from.overflow;
    to.display = from.display;
    
    COPYYGVALUE(paddingLeft)
    COPYYGVALUE(paddingTop)
    COPYYGVALUE(paddingRight)
    COPYYGVALUE(paddingBottom)
    COPYYGVALUE(paddingStart)
    COPYYGVALUE(paddingEnd)
    COPYYGVALUE(paddingHorizontal)
    COPYYGVALUE(paddingVertical)
    COPYYGVALUE(padding)
    
    to.aspectRatio = from.aspectRatio;
}
-(void)addSubview:(UIView *)view
{
    [_contentView addSubview:view];
    [_contentView registSubView:view];
}

FLEXSET(horzScroll)
{
    BOOL b = String2BOOL(sValue) ;
    self.horizontal = b ;
    
    _contentView.flexibleWidth = b;
}
FLEXSET(vertScroll)
{
    BOOL b = String2BOOL(sValue) ;
    self.vertical = b ;
    
    _contentView.flexibleHeight = b;
}
@end
