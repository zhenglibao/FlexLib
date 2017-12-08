/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */


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
        _flexRootView.flexibleHeight = YES ;
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
