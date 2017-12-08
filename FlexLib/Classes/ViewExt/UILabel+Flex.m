
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

FLEXSET(text)
{
    self.text = sValue ;
}
FLEXSET(fontSize)
{
    float nSize = [sValue floatValue];
    if(nSize > 0){
        UIFont* font = [UIFont systemFontOfSize:nSize];
        self.font = font;
    }
}
FLEXSET(linesNum)
{
    int n = (int)[sValue integerValue];
    if(n>=0){
        self.numberOfLines = n;
    }
}
FLEXSET(color)
{
    UIColor* clr = colorFromString(sValue);
    if(clr!=nil){
        self.textColor = clr ;
    }
}
FLEXSET(textAlign)
{
    const char* c =  [sValue cStringUsingEncoding:NSASCIIStringEncoding];
    self.textAlignment = (NSTextAlignment)String2Int(c, _align, sizeof(_align)/sizeof(NameValue));
}
@end
