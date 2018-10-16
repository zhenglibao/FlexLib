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

@interface FlexBaseTableCell : UITableViewCell

// 获取所关联的tableview
@property(nonatomic,readonly) UITableView* _Nullable tableView;

//
@property(nonatomic,readonly) FlexRootView* _Nullable rootView;

// 事件通知，content大小发生了变化
@property(nonatomic,copy) void (^ _Nullable onContentSizeChanged)(CGSize newSize);

// 如果flexName为nil，则使用与同类名的资源文件
-(instancetype _Nullable)initWithFlex:(nullable NSString*)flexName
            reuseIdentifier:(nullable NSString *)reuseIdentifier;

//使用contentView的宽度计算对应高度
-(CGFloat)heightForWidth;

//计算高度
-(CGFloat)heightForWidth:(CGFloat)width;

-(CGSize)calculateSize:(CGSize)szLimit;

// override this to do aditional initialize
-(void)onInit;

@end
