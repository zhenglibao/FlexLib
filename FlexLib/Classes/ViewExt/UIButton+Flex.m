
#import "UIButton+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"


@implementation UIButton (Flex)

FLEXSET(title)
{
    [self setTitle:sValue forState:UIControlStateNormal];
}
FLEXSET(color)
{
    UIColor* clr = colorFromString(sValue);
    if(clr!=nil){
        [self setTitleColor:clr forState:UIControlStateNormal];
    }
}
@end
