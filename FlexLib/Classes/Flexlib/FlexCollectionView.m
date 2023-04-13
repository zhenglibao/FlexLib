/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "FlexCollectionView.h"

@implementation FlexCollectionView

- (instancetype)init
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    return [super initWithFrame:CGRectZero collectionViewLayout: layout];
}

@end
