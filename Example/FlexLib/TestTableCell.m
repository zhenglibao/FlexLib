//
//  TestTableCell.m
//  FlexLayout_Example
//
//  Created by zhenglibao on 2017/12/6.
//  Copyright © 2017年 798393829@qq.com. All rights reserved.
//

#import "TestTableCell.h"

@interface TestTableCell()
{
    UILabel* _name;
    UILabel* _model;
    UILabel* _sn;
    UILabel* _updatedBy;
    
    UIImageView* _return;
}
@end
@implementation TestTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
