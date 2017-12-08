/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */


#import <UIKit/UIKit.h>

#define FLEXSET(propName)               \
-(void)setFlex##propName:(NSString*)sValue

@interface UIView (Flex)

//子类可以重载做些加载后的处理
-(void)postCreate;

//子view的frame发生了改变
-(void)subFrameChanged:(UIView*)subView
                  Rect:(CGRect)newFrame;

//父view的frame发生了改变
-(void)superFrameChanged;

@end

