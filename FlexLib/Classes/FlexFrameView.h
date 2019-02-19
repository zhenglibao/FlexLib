/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

typedef void (^FrameChanged)(CGRect);

@class FlexRootView;

// This view not use flexlbox layout
// just set frame or make flexible width
// or height
// 该类也支持继承并创建组件

@interface FlexFrameView : UIView

@property(nonatomic,readonly) FlexRootView* _Nullable rootView;

//宽和高是否可变？缺省值均为NO
@property(nonatomic,assign) BOOL flexibleWidth;
@property(nonatomic,assign) BOOL flexibleHeight;

//当某个子控件大小变化导致自己的frame发生变化时调用
//如果外部直接设置其frame，将不会调用
@property(nonatomic,copy) FrameChanged _Nullable onFrameChange;

//如果用来制作组件的时候，调用initWithFlex初始化的时候一定要给owner传递nil
-(instancetype _Nullable )initWithFlex:(nullable NSString*)flexname
                                 Frame:(CGRect)frame
                                 Owner:(nullable NSObject*)owner;

@end
