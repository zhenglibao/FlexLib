//
//  FlexBaseTableCell.h
//  Expecta
//
//  Created by zhenglibao on 2017/12/5.
//

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
