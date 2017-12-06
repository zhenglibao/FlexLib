
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

@implementation UIView (Flex)

-(void)setBgColor:(NSString*)clrStr
{
    UIColor* clr = colorFromString(clrStr) ;
    if(clr!=nil){
        self.backgroundColor = clr ;
    }
}
-(void)setBorderRadius:(NSString*)radius
{
    CGFloat f = [radius floatValue] ;
    self.layer.cornerRadius = f ;
}

@end
