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

// 额外的view属性存储
@interface FlexViewAttrs : NSObject

@property(nonatomic,copy) NSString* name;
@property(nonatomic,assign) BOOL stickTop;

// 缓存数据
@property(nonatomic,assign) CGFloat originY;
@property(nonatomic,assign) CGPoint originInRoot;

@end


@interface UIView (Flex)

/**
 *The ViewAttrs that is attached to this view. It is lazily created.
 */
@property (nonatomic, readonly, strong) FlexViewAttrs* viewAttrs;

//子类可以在调用完init方法后做额外的初始化,内部框架使用
-(void)afterInit:(NSObject*)owner rootView:(FlexRootView*)rootView;

//子类可以重载做些加载后的处理
-(void)postCreate;

//子view的frame发生了改变
-(void)subFrameChanged:(UIView*)subView
                  Rect:(CGRect)newFrame;

//父view的frame发生了改变
-(void)superFrameChanged;

@end

