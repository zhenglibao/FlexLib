/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "TestCollectionCell.h"

@interface TestCollectionCell()

@property(nonatomic,strong) UILabel* label;
@property(nonatomic,strong) UIImageView* image;

@end

@implementation TestCollectionCell

-(void)setText:(NSString*)text
{
    self.label.text = text;
}
@end
