
#import "UILabel+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

static NameValue _align[] =
{
    {"left", NSTextAlignmentLeft},
    {"center", NSTextAlignmentCenter},
    {"right", NSTextAlignmentRight},
    {"justified", NSTextAlignmentJustified},
    {"natural", NSTextAlignmentNatural},
};


@implementation UILabel (Flex)

-(void)setFontSize:(NSString*)fontSize
{
    float nSize = [fontSize floatValue];
    if(nSize > 0){
        UIFont* font = [UIFont systemFontOfSize:nSize];
        self.font = font;
    }
}
-(void)setLinesNum:(NSString*)s
{
    int n = (int)[s integerValue];
    if(n>=0){
        self.numberOfLines = n;
    }
}
-(void)setColor:(NSString*)s
{
    UIColor* clr = colorFromString(s);
    if(clr!=nil){
        self.textColor = clr ;
    }
}
-(void)setTextAlign:(NSString*)s
{
    const char* c =  [s cStringUsingEncoding:NSASCIIStringEncoding];
    self.textAlignment = (NSTextAlignment)String2Int(c, _align, sizeof(_align)/sizeof(NameValue));
}
@end
