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

@interface FlexCollectionCell : UICollectionViewCell

@property(nonatomic,readonly) FlexRootView* rootview;

// 事件通知，content大小发生了变化
@property(nonatomic,copy) void (^ _Nullable onContentSizeChanged)(CGSize newSize);


/*
 * 计算cell大小，使用该方法之前需要在onInit方法中设置rootview的宽度和高度是否可变
 * 只有高度或者宽度可变才有必要调用该方法计算匹配的大小
 */
-(CGSize)calculateSize:(CGSize)szLimit;

// override this to do aditional initialize
-(void)onInit;


@end
