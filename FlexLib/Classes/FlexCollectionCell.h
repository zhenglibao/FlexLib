/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

@interface FlexCollectionCell : UICollectionViewCell

// 事件通知，content大小发生了变化
@property(nonatomic,copy) void (^ _Nullable onContentSizeChanged)(CGSize newSize);


-(CGSize)calculateSize:(CGSize)szLimit;

// override this to do aditional initialize
-(void)onInit;


@end
