/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import <FlexLib/FlexLib.h>

/*
 这个例子演示了各种系统控件的创建方法，注意ControlsVC中重写了
 -(UIView*)createView:(Class)cls Name:(NSString*)name
 这个方法用于控件不支持通过init方法创建时，使用该重载方法来自定义创建控件
 */

@interface ControlsVC : FlexBaseVC

@end
