
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

static NameValue _gcontentModes[] =
{
    {"scaleToFill",UIViewContentModeScaleToFill},
    {"scaleAspectFit",UIViewContentModeScaleAspectFit},
    {"scaleAspectFill",UIViewContentModeScaleAspectFill},
    {"redraw",UIViewContentModeRedraw},
    {"center",UIViewContentModeCenter},
    {"top",UIViewContentModeTop},
    {"bottom",UIViewContentModeBottom},
    {"left",UIViewContentModeLeft},
    {"right",UIViewContentModeRight},
    {"topLeft",UIViewContentModeTopLeft},
    {"topRight",UIViewContentModeTopRight},
    {"bottomLeft",UIViewContentModeBottomLeft},
    {"bottomRight",UIViewContentModeBottomRight},
};

@implementation UIView (Flex)

#pragma mark - override

-(void)subFrameChanged:(UIView*)subView
                  Rect:(CGRect)newFrame
{
}

-(void)superFrameChanged
{
}

-(void)postCreate
{
}

#pragma mark - attribute

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
FLEXSET(contentMode)
{
    UIViewContentMode mode = (UIViewContentMode) NSString2Int(sValue,_gcontentModes,sizeof(_gcontentModes)/sizeof(NameValue));
    self.contentMode = mode;
}
FLEXSET(alpha)
{
    CGFloat f = [sValue floatValue] ;
    self.alpha = f ;
}
FLEXSET(hidden)
{
    self.hidden = String2BOOL(sValue);
}
FLEXSET(tintColor)
{
    UIColor* clr = colorFromString(sValue) ;
    if(clr!=nil){
        self.tintColor = clr ;
    }
}
@end
