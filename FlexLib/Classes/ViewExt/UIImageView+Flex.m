
#import "UIImageView+Flex.h"
#import "UIView+Flex.h"
#import "../FlexUtils.h"
#import <objc/runtime.h>


@implementation UIImageView (Flex)

FLEXSET(source)
{
    UIImage* img = [UIImage imageNamed:sValue];
    self.image = img ;
}
FLEXSET(highlightSource)
{
    UIImage* img = [UIImage imageNamed:sValue];
    self.highlightedImage = img ;
}
FLEXSET(interactEnable)
{
    self.userInteractionEnabled = String2BOOL(sValue);
}
@end
