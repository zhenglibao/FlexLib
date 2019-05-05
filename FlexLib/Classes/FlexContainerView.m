/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "FlexContainerView.h"
#import "FlexRootView.h"

@implementation FlexContainerView

-(CGSize)sizeThatFits:(CGSize)size
{
    for (UIView* subview in self.subviews) {
        if(!subview.hidden &&
           [subview isFlexLayoutEnable])
        {
            return [super sizeThatFits:size];
        }
    }
    
    return CGSizeZero;
}

@end
