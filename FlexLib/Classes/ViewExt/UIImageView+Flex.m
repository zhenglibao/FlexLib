
#import "UIImageView+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>


@implementation UIImageView (Flex)

FLEXSET(source)
{
    UIImage* img = [UIImage imageNamed:sValue];
    self.image = img ;
}
@end
