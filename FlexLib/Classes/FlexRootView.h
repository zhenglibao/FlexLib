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

@end

@interface FlexRootView : UIView

@property(nonatomic,assign) BOOL flexibleWidth;
@property(nonatomic,assign) BOOL flexibleHeight;
@property(nonatomic,assign) UIEdgeInsets portraitSafeArea;
@property(nonatomic,assign) UIEdgeInsets landscapeSafeArea;
@property(nonatomic,readonly) UIView* topSubView;

-(void)markChildDirty:(UIView*)child;

+(FlexRootView*)loadWithNodeFile:(NSString*)resName
                           Owner:(NSObject*)owner;

-(CGSize)calculateSize;

-(CGSize)calculateSize:(CGSize)szLimit;

-(void)registSubView:(UIView*)subView;

@end
