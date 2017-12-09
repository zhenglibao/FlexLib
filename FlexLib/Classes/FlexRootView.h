/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import <UIKit/UIKit.h>

@interface UIView(FlexPublic)

// 外部可以主动调用此函数让布局得到刷新
-(void)markDirty;

// 开启关闭布局
-(void)enableFlexLayout:(BOOL)enable;

//
-(BOOL)isFlexLayoutEnable;

@end

@interface FlexRootView : UIView

@property(nonatomic,assign) BOOL flexibleWidth;
@property(nonatomic,assign) BOOL flexibleHeight;
@property(nonatomic,assign) UIEdgeInsets portraitSafeArea;
@property(nonatomic,assign) UIEdgeInsets landscapeSafeArea;
@property(nonatomic,readonly) UIView* topSubView;

@property(nonatomic,copy) void (^beginLayout)(void);
@property(nonatomic,copy) void (^endLayout)(void);


-(void)markChildDirty:(UIView*)child;

+(FlexRootView*)loadWithNodeFile:(NSString*)resName
                           Owner:(NSObject*)owner;

-(CGSize)calculateSize;

-(CGSize)calculateSize:(CGSize)szLimit;

-(void)registSubView:(UIView*)subView;

-(void)layoutAnimation:(NSTimeInterval)duration;

@end
