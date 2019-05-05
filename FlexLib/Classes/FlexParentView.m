/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "FlexParentView.h"
#import "ViewExt/UIView+Flex.h"
#import "YogaKit/UIView+Yoga.h"

@implementation FlexParentView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)layoutSubviews
{
    
}
-(void)subFrameChanged:(UIView*)subView
                  Rect:(CGRect)newFrame
{
    if(!CGSizeEqualToSize(newFrame.size,self.frame.size))
    {
        CGRect rc = self.frame ;
        rc.size = newFrame.size ;
        self.frame = rc ;
        if(self.onFrameChange != nil)
        {
            self.onFrameChange(rc);
        }
    }
}

@end
