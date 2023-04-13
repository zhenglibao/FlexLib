/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import <UIKit/UIKit.h>

@class FlexRootView;

@interface FlexScrollView : UIScrollView

@property(nonatomic,readonly) FlexRootView* contentView;

@property(nonatomic,assign) BOOL horizontal;
@property(nonatomic,assign) BOOL vertical;

// 移除subview，主要目的是解除事件通知
-(void)removeSubView:(UIView*)view;

@end
