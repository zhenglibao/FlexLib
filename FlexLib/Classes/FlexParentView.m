//
//  FlexParentView.m
//  Expecta
//
//  Created by zhenglibao on 2017/12/8.
//

#import "FlexParentView.h"
#import "ViewExt/UIView+Flex.h"
#import "YogaKit/UIView+Yoga.h"

@implementation FlexParentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.yoga.isIncludedInLayout=NO;
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
