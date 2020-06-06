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
#import "ViewExt/UIView+Flex.h"
#import "YogaKit/UIView+Yoga.h"
#import "FlexUtils.h"
#import "FlexTouchView.h"

@interface FlexScrollView()
{
    FlexRootView* _contentView;
}
@end


@implementation FlexScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 构造view tree
        __weak FlexScrollView* weakSelf = self;
        
        _contentView = [[FlexRootView alloc]init];
        _contentView.onWillLayout = ^{
            [weakSelf onContentViewWillLayout];
        };
        _contentView.onDidLayout = ^{
            [weakSelf onContentViewDidLayout];
        };
        [super addSubview:_contentView];
    }
    return self;
}

- (void)dealloc
{
}
-(FlexRootView*)contentView
{
    return _contentView;
}
-(void)onContentViewWillLayout
{

}

-(void)onContentViewDidLayout
{
    self.contentSize = _contentView.frame.size;
}

- (void)setFrame:(CGRect)frame
{
    CGSize oldSize = self.frame.size;
    
    [super setFrame:frame];
    
    if(!CGSizeEqualToSize(oldSize, frame.size)){
        CGRect rc = _contentView.frame;
        if(!self.vertical)
            rc.size.height = CGRectGetHeight(frame);
        if(!self.horizontal)
            rc.size.width = CGRectGetWidth(frame);
        if(!CGSizeEqualToSize(rc.size,_contentView.frame.size)){
            _contentView.frame = rc;
        }
    }
}

-(void)postCreate
{
    // let child has chance to process touch event
    self.canCancelContentTouches = YES;
    self.delaysContentTouches = NO;
    if (@available(iOS 11.0, *))
    {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever ;
    }
    
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
    to.alignContent = from.alignContent;
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
}
-(void)addSubview:(UIView *)view
{
    [_contentView addSubview:view];
    [_contentView registSubView:view];
}
-(void)removeSubView:(UIView*)view
{
    [view removeFromSuperview];
    [_contentView removeWatchView:view];
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
