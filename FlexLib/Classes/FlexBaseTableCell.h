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

@interface FlexBaseTableCell : UITableViewCell

// 如果flexName为nil，则使用与同类名的资源文件
-(instancetype _Nullable)initWithFlex:(nullable NSString*)flexName
            reuseIdentifier:(nullable NSString *)reuseIdentifier;

//使用contentView的宽度计算对应高度
-(CGFloat)heightForWidth;

//计算高度
-(CGFloat)heightForWidth:(CGFloat)width;

-(CGSize)calculateSize:(CGSize)szLimit;

@end
