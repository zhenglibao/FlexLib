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
#import "ViewExt/NSView+Flex.h"
#import "YogaKit/NSView+Yoga.h"
#import "FlexUtils.h"
#import "FlexTouchView.h"

@interface FlexScrollView()
{
    FlexRootView* _flexRootView;
}
@end


@implementation FlexScrollView

- (BOOL)isFlipped
{
    return YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 构造view tree
        __weak FlexScrollView* weakSelf = self;
        
        _flexRootView = [[FlexRootView alloc]init];
        _flexRootView.onWillLayout = ^{
            [weakSelf onContentViewWillLayout];
        };
        _flexRootView.onDidLayout = ^{
            [weakSelf onContentViewDidLayout];
        };
        _flexRootView.wantsLayer = YES;
        _flexRootView.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.verticalLineScroll = 10;
        self.horizontalLineScroll = 10;
        self.verticalPageScroll = 50;
        self.horizontalPageScroll = 50;
        self.hasVerticalScroller = YES;
        
        [self.contentView setPostsFrameChangedNotifications:YES];
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        self.documentView = _flexRootView;
    }
    return self;
}

- (void)scrollWheel:(NSEvent *)event
{
    NSLog(@"scrollWheel");
    //[super scrollWheel:event];
}

- (void)dealloc
{
    
}
-(FlexRootView*)flexRootView
{
    return _flexRootView;
}
-(void)onContentViewWillLayout
{
}

-(void)onContentViewDidLayout
{
    
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
    YGLayout* to = _flexRootView.yoga ;
    
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
-(void)addSubview:(NSView *)view
{
    if ([view isKindOfClass:[NSClipView class]]) {
        [super addSubview:view];
    } else {
        [_flexRootView addSubview:view];
        [_flexRootView registSubView:view];
    }
}

FLEXSET(horzScroll)
{
    BOOL b = String2BOOL(sValue) ;
    self.horizontal = b ;
    
    _flexRootView.flexibleWidth = b;
    [self setHasHorizontalRuler:b];
}
FLEXSET(vertScroll)
{
    BOOL b = String2BOOL(sValue) ;
    self.vertical = b ;
    
    _flexRootView.flexibleHeight = b;
    [self setHasVerticalRuler:b];}
@end
