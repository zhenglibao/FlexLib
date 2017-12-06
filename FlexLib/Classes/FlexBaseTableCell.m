//
//  FlexBaseTableCell.m
//  Expecta
//
//  Created by zhenglibao on 2017/12/5.
//

#import "FlexBaseTableCell.h"
#import "FlexRootView.h"

@interface FlexBaseTableCell()
{
    FlexRootView* _flexRootView ;
}
@end

@implementation FlexBaseTableCell

-(instancetype)initWithFlex:(NSString*)flexName
            reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if( self != nil){
        _flexRootView = [FlexRootView loadWithNodeFile:flexName Owner:self];
        _flexRootView.flexOption = FlexibleHeight ;
        [self.contentView addSubview:_flexRootView];
    }
    return self ;
}

-(CGFloat)heightForWidth:(CGFloat)width
{
    CGSize szLimit = CGSizeMake(width, FLT_MAX);
    return [_flexRootView calculateSize:szLimit].height;
}
-(CGFloat)heightForWidth
{
    return [self heightForWidth:self.contentView.frame.size.width];
}
-(CGSize)calculateSize:(CGSize)szLimit
{
    return [_flexRootView calculateSize:szLimit];
}
@end
