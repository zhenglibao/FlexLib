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
#import "UIView+Flex.h"
#import "UIView+Yoga.h"
#import "FlexUtils.h"
#import "FlexTouchView.h"
#import "FlexLayout.h"

@interface FlexScrollView()
{
    FlexRootView* _contentView;
    CGSize  _fitContentSize;
}
@end


@implementation FlexScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 构造view tree
        __weak FlexScrollView* weakSelf = self;
        
        _fitContentSize = CGSizeMake(0, 0);
        
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
    
    if(_fitContentSize.height>0){
        
        CGFloat finalHeight = self.contentSize.height < _fitContentSize.height ? self.contentSize.height : _fitContentSize.height;
        
        self.flexLayout.height(finalHeight);
        
        [self markDirty];
    }
    
    if(_fitContentSize.width>0){
        
        CGFloat finalWidth = self.contentSize.width < _fitContentSize.width ? self.contentSize.width : _fitContentSize.width;
        
        self.flexLayout.height(finalWidth);
        [self markDirty];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    CGRect rc = _contentView.frame;
    if(!self.vertical)
        rc.size.height = CGRectGetHeight(frame);
    if(!self.horizontal)
        rc.size.width = CGRectGetWidth(frame);
    if(!CGSizeEqualToSize(rc.size,_contentView.frame.size)){
        _contentView.frame = rc;
    }
}

-(void)postCreate
{
    // let child has chance to process touch event
    self.canCancelContentTouches = YES;
    self.delaysContentTouches = NO;
    self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever ;
    
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

FLEXSET(widthFitContent)
{
    _fitContentSize.width = [sValue doubleValue] ;
}

FLEXSET(heightFitContent)
{
    _fitContentSize.height = [sValue doubleValue] ;
}

@end
