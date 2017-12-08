
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

@implementation UIView (Flex)

-(void)subFrameChanged:(UIView*)subView
                  Rect:(CGRect)newFrame
{
    
}

-(void)superFrameChanged
{
    
}

FLEXSET(bgColor)
{
    UIColor* clr = colorFromString(sValue) ;
    if(clr!=nil){
        self.backgroundColor = clr ;
    }
}
FLEXSET(borderRadius)
{
    CGFloat f = [sValue floatValue] ;
    self.layer.cornerRadius = f ;
}
-(void)postCreate
{
    
}
@end
