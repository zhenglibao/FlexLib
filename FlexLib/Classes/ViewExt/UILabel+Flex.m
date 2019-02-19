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
#import "../FlexNode.h"
#import "../FlexStyleMgr.h"
#import "../FlexModalView.h"
#import "../FlexRootView.h"

static char *UILABELATTR = "uiLabelAttr";


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


@interface UILabelAttr : NSObject

@property(nonatomic,strong) NSArray<FlexNode*>* childElems;
@property(nonatomic,strong) NSArray<FlexClickRange*>* clickRanges;
@property(nonatomic,strong) NSMutableParagraphStyle* paraStyle;

@end

@implementation UILabelAttr
@end


@interface UILabel()

@property(nonatomic,readonly) UILabelAttr* labelAttr;

@end

@implementation UILabel (Flex)

- (UILabelAttr *)labelAttr
{
    UILabelAttr *attr = objc_getAssociatedObject(self, UILABELATTR);
    if (!attr) {
        attr = [[UILabelAttr alloc] init];
        objc_setAssociatedObject(self, UILABELATTR, attr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return attr;
}

- (NSUInteger)charIndexOfTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
    [layoutManager addTextContainer:textContainer];
    
    textContainer.lineFragmentPadding = 0;
    textContainer.maximumNumberOfLines = self.numberOfLines;
    textContainer.lineBreakMode = self.lineBreakMode;
    
    
    NSUInteger characterIndex = [layoutManager characterIndexForPoint:location
                                                      inTextContainer:textContainer
                             fractionOfDistanceBetweenInsertionPoints:NULL];
    
    return characterIndex;
}

-(void)onClickFlexLabel:(UITapGestureRecognizer*)tap
{
    NSArray *clickRanges = self.labelAttr.clickRanges;
    
    if(clickRanges==nil){
        return;
    }
    
    NSUInteger characterIndex = [self charIndexOfTap:tap];
    
    for (FlexClickRange* click in clickRanges) {
        
        if(click.onPress.length>0  &&
           NSLocationInRange(characterIndex, click.range) )
        {
            NSObject* owner = self.owner;
            if(owner!=nil){
                SEL sel = NSSelectorFromString(click.onPress);
                
                if(sel!=nil && [owner respondsToSelector:sel]){
                    IMP imp = [owner methodForSelector:sel];
                    if(imp!=NULL){
                        if([click.onPress rangeOfString:@":"].length>0){
                            void (*func)(id, SEL,id) = (void *)imp;
                            func(owner, sel,[click copy]);
                        }else{
                            void (*func)(id, SEL) = (void *)imp;
                            func(owner, sel);
                        }
                    }
                }else{
                    NSLog(@"Flexbox: wrong onPress parameter - %@",click.onPress);
                }
            }
            break;
        }
    }
}

-(void)setChildElems:(NSArray<FlexNode*>*)childElems
{
    self.labelAttr.childElems = childElems ;
    [self buildChildAttrStrings:self.owner];
}
-(FlexNode*)getFlexNode:(NSString*)childName
{
    for (FlexNode* node in self.labelAttr.childElems) {
        
        if([node.name isEqualToString:childName])
            return node;
    }
    return nil;
}
-(void)setFlexAttrString:(NSString*)text name:(NSString*)name
{
    if(self.labelAttr.childElems==nil){
        NSLog(@"Flexbox: UILabel has no child elements.");
        return;
    }
    if( text==nil ){
        text = @"";
    }
    
    for (FlexNode* node in self.labelAttr.childElems) {
        
        if( [node.name isEqualToString:name] &&
            [node.viewClassName isEqualToString:@"Text"] ){
            
            BOOL hasTextAttr = NO;
            for (FlexAttr* attr in node.viewAttrs) {
                
                if( [attr.name isEqualToString:@"text"] ){
                    attr.value = text ;
                    hasTextAttr = YES;
                }
            }
            if(!hasTextAttr){
                NSMutableArray* viewAttrs = (NSMutableArray*) node.viewAttrs;
                if(![viewAttrs isKindOfClass:[NSMutableArray class]]){
                    viewAttrs = [viewAttrs mutableCopy];
                    node.viewAttrs = viewAttrs ;
                }
                
                FlexAttr* attr = [[FlexAttr alloc]init];
                attr.name = @"text";
                attr.value = text;
                [viewAttrs addObject:attr];
            }
            
            return;
        }
    }
    NSLog(@"Flexbox: there is no attributed text - %@",name);
}

-(void)setFlexAttrImage:(NSString*)imageSource name:(NSString*)name
{
    if(self.labelAttr.childElems==nil){
        NSLog(@"Flexbox: UILabel has no child elements.");
        return;
    }
    if( imageSource.length==0 )
        return;
    
    for (FlexNode* node in self.labelAttr.childElems) {
        
        if( [node.name isEqualToString:name] &&
            [node.viewClassName isEqualToString:@"Image"] ){
            
            BOOL hasSourceAttr = NO;
            for (FlexAttr* attr in node.viewAttrs) {
                
                if( [attr.name isEqualToString:@"source"] ){
                    attr.value = imageSource ;
                    hasSourceAttr = YES;
                }
            }
            if(!hasSourceAttr){
                NSMutableArray* viewAttrs = (NSMutableArray*) node.viewAttrs;
                if(![viewAttrs isKindOfClass:[NSMutableArray class]]){
                    viewAttrs = [viewAttrs mutableCopy];
                    node.viewAttrs = viewAttrs ;
                }
                
                FlexAttr* attr = [[FlexAttr alloc]init];
                attr.name = @"source";
                attr.value = imageSource;
                [viewAttrs addObject:attr];
            }
            
            return;
        }
    }
    NSLog(@"Flexbox: there is no attributed text - %@",name);
}

-(void)buildChildAttrStrings:(NSObject*)owner
{
    NSArray* childElems = self.labelAttr.childElems;
    if(childElems==nil){
        return;
    }
    
    NSMutableArray* aryClickRange = [NSMutableArray array];
    NSMutableAttributedString* string = createAttributedString(childElems,
                                                               owner,
                                                               self.font,
                                                               self.textColor,
                                                               aryClickRange);
    if( string.length>0 ){
        NSMutableParagraphStyle * style = [self paraStyle];
        [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,string.length)];
        
        self.attributedText = string;
        
        // 添加点击手势
        if( aryClickRange.count>0 ){
            self.labelAttr.clickRanges = aryClickRange;
            
            for (UIGestureRecognizer* gesture in self.gestureRecognizers) {
                if([gesture isKindOfClass:[UITapGestureRecognizer class]]){
                    [self removeGestureRecognizer:gesture];
                }
            }
            
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickFlexLabel:)];
            tap.cancelsTouchesInView = NO;
            tap.delaysTouchesBegan = NO;
            [self addGestureRecognizer:tap];
            self.userInteractionEnabled = YES;
        }
    }
}

/*
 * 该方法用来实现富文本支持
 */

-(BOOL)buildChildElements:(NSArray<FlexNode*>*)childElems
                    Owner:(NSObject*)owner
                 RootView:(FlexRootView*)rootView
{
    self.labelAttr.childElems = childElems;
    
    [self buildChildAttrStrings:owner];
    
    
    for (FlexNode* node in childElems) {
        
        if([node.viewClassName isEqualToString:@"Text"] ||
           [node.viewClassName isEqualToString:@"Image"])
        {
            continue;
        }
        
        UIView* view = [node buildViewTree:owner RootView:rootView];
        if(view!=nil){
            if(![view isKindOfClass:[FlexModalView class]]){
                [self addSubview:view];
            }else {
                NSLog(@"Flexbox: FlexModalView can not be used as UILabel child view.");
            }
        }
        
    }
    return YES;
}

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
    UILabelAttr* attr = self.labelAttr;
    if(attr.paraStyle==nil){
        attr.paraStyle = [[NSMutableParagraphStyle alloc] init];
    }
    return attr.paraStyle;
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
    if(self.labelAttr.childElems==nil){
        
        NSString* text = self.text ;
        if(text==nil)
            text=@"";
        
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle * style = [self paraStyle];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,text.length)];
        [self setAttributedText:attributedString1];
    
    }else{
        [self buildChildAttrStrings:self.owner];
    }
}
@end
