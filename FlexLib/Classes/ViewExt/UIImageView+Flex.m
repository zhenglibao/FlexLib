
#import "UIImageView+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>


@implementation UIImageView (Flex)

-(void)setSource:(NSString*)src
{
    UIImage* img = [UIImage imageNamed:src];
    self.image = img ;
}
@end
