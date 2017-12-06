
#import "UIButton+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"


@implementation UIButton (Flex)

-(void)setTitle:(NSString*)title
{
    [self setTitle:title forState:UIControlStateNormal];
}
-(void)setColor:(NSString*)s
{
    UIColor* clr = colorFromString(s);
    if(clr!=nil){
        [self setTitleColor:clr forState:UIControlStateNormal];
    }
}
@end
