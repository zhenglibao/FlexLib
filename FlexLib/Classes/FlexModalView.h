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

-(void)showModalInView:(UIView*)view;
-(void)showModalInView:(UIView*)view Position:(CGPoint)topLeft;
-(void)hideModal;

@end
