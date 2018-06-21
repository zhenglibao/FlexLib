/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "UILabel+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

static char *PARASTYLEKEY = "paraStyleKey";

static NameValue _align[] =
{
    {"left", NSTextAlignmentLeft},
    {"center", NSTextAlignmentCenter},
    {"right", NSTextAlignmentRight},
    {"justified", NSTextAlignmentJustified},
    {"natural", NSTextAlignmentNatural},
};
static NameValue _breakMode[] =
{
    {"wordWrapping", NSLineBreakByWordWrapping},
    {"charWrapping", NSLineBreakByCharWrapping},
    {"clipping", NSLineBreakByClipping},
    {"truncatingHead", NSLineBreakByTruncatingHead},
    {"truncatingTail", NSLineBreakByTruncatingTail},
    {"truncatingMiddle", NSLineBreakByTruncatingMiddle},
};


@implementation UILabel (Flex)

FLEXSET(text)
{
    self.text = sValue;
    [self updateAttributeText];
}
FLEXSET(fontSize)
{
    float nSize = [sValue floatValue];
    if(nSize > 0){
        UIFont* font = [UIFont systemFontOfSize:nSize];
        self.font = font;
    }
}
FLEXSET(lineBreakMode)
{
    NSInteger n = NSString2Int(sValue,
                               _breakMode,
                               sizeof(_breakMode)/sizeof(NameValue));
    self.lineBreakMode = n;
    
    NSMutableParagraphStyle* style=[self paraStyle];
    style.lineBreakMode = n;
    [self updateAttributeText];
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
    UIColor* clr = colorFromString(sValue,owner);
    if(clr!=nil){
        self.textColor = clr ;
    }
}
FLEXSET(shadowColor)
{
    UIColor* clr = colorFromString(sValue,owner);
    if(clr!=nil){
        self.shadowColor = clr ;
    }
}
FLEXSET(highlightTextColor)
{
    UIColor* clr = colorFromString(sValue,owner);
    if(clr!=nil){
        self.highlightedTextColor = clr ;
    }
}
FLEXSET(textAlign)
{
    const char* c =  [sValue cStringUsingEncoding:NSASCIIStringEncoding];
    self.textAlignment = (NSTextAlignment)String2Int(c, _align, sizeof(_align)/sizeof(NameValue));
    
    NSMutableParagraphStyle* style=[self paraStyle];
    style.alignment = self.textAlignment;
    [self updateAttributeText];
}
FLEXSET(interactEnable)
{
    self.userInteractionEnabled = String2BOOL(sValue);
}
FLEXSETBOOL(enabled)
FLEXSET(adjustFontSize)
{
    self.adjustsFontSizeToFitWidth = String2BOOL(sValue);
}

FLEXSET(value)
{
    self.text = sValue;
    [self updateAttributeText];
}

-(NSMutableParagraphStyle*)paraStyle
{
    NSMutableParagraphStyle *style = objc_getAssociatedObject(self, PARASTYLEKEY);
    if (!style) {
        style = [[NSMutableParagraphStyle alloc] init];
        
        objc_setAssociatedObject(self, PARASTYLEKEY, style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return style;
}

FLEXSET(lineSpacing)
{
    NSMutableParagraphStyle* style=[self paraStyle];
    style.lineSpacing = [sValue floatValue];
    if(self.text){
        [self updateAttributeText];
    }
}
FLEXSET(paragraphSpacing)
{
    NSMutableParagraphStyle* style=[self paraStyle];
    style.paragraphSpacing = [sValue floatValue];
    if(self.text){
        [self updateAttributeText];
    }
}
FLEXSET(firstLineHeadIndent)
{
    NSMutableParagraphStyle* style=[self paraStyle];
    style.firstLineHeadIndent = [sValue floatValue];
    if(self.text){
        [self updateAttributeText];
    }
}
FLEXSET(headIndent)
{
    NSMutableParagraphStyle* style=[self paraStyle];
    style.headIndent = [sValue floatValue];
    if(self.text){
        [self updateAttributeText];
    }
}
FLEXSET(tailIndent)
{
    NSMutableParagraphStyle* style=[self paraStyle];
    style.tailIndent = [sValue floatValue];
    if(self.text){
        [self updateAttributeText];
    }
}
-(void)updateAttributeText
{
    NSString* text = self.text ;
    if(text==nil)
        text=@"";
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * style = [self paraStyle];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,text.length)];
    [self setAttributedText:attributedString1];
}
@end
