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

@interface FlexModalView : UIView

-(void)setOwnerRootView:(FlexRootView*)rootView;

// 在底部、中心、顶部显示
-(void)showModalInView:(UIView*)view Anim:(BOOL)anim;

//在绝对位置显示
-(void)showModalInView:(UIView*)view Position:(CGPoint)topLeft Anim:(BOOL)anim;

//隐藏
-(void)hideModal:(BOOL)anim;

@end
