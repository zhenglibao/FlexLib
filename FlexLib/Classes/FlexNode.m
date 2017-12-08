//
//  FlexNode.m
//  FlexLayout
//
//  Created by zhenglibao on 2017/11/28.
//  Copyright © 2017年 wbg. All rights reserved.
//

#import "FlexNode.h"
#import "YogaKit/UIView+Yoga.h"
#import "YogaKit/YGLayout.h"
#import "GDataXMLNode.h"
#import "FlexStyleMgr.h"
#import "FlexUtils.h"
#import "FlexRootView.h"
#import "FlexModalView.h"
#import "ViewExt/UIView+Flex.h"

#define VIEWCLSNAME     @"viewClsName"
#define NAME            @"name"
#define ONPRESS         @"onPress"
#define LAYOUTPARAM     @"layoutParam"
#define VIEWATTRS       @"viewAttrs"
#define CHILDREN        @"children"

#pragma mark - Name values


static NameValue _direction[] =
{{"inherit", YGDirectionInherit},
 {"ltr", YGDirectionLTR},
 {"rtl", YGDirectionRTL},
};
static NameValue _flexDirection[] =
{   {"col", YGFlexDirectionColumn},
    {"col-reverse", YGFlexDirectionColumnReverse},
    {"row", YGFlexDirectionRow},
    {"row-reverse", YGFlexDirectionRowReverse},
};
static NameValue _justify[] =
{   {"flex-start", YGJustifyFlexStart},
    {"center", YGJustifyCenter},
    {"flex-end", YGJustifyFlexEnd},
    {"space-between", YGJustifySpaceBetween},
    {"space-around", YGJustifySpaceAround},
};
static NameValue _align[] =
{   {"auto", YGAlignAuto},
    {"flex-start", YGAlignFlexStart},
    {"center", YGAlignCenter},
    {"flex-end", YGAlignFlexEnd},
    {"stretch", YGAlignStretch},
    {"baseline", YGAlignBaseline},
    {"space-between", YGAlignSpaceBetween},
    {"space-around", YGAlignSpaceAround},
};
static NameValue _positionType[] =
{{"relative", YGPositionTypeRelative},
    {"absolute", YGPositionTypeAbsolute},
};

static NameValue _wrap[] =
{{"no-wrap", YGWrapNoWrap},
    {"wrap", YGWrapWrap},
    {"wrap-reverse", YGWrapWrapReverse},
};
static NameValue _overflow[] =
{{"visible", YGOverflowVisible},
    {"hidden", YGOverflowHidden},
    {"scroll", YGOverflowScroll},
};
static NameValue _display[] =
{{"flex", YGDisplayFlex},
    {"none", YGDisplayNone},
};


static YGValue String2YGValue(const char* s)
{
    int len = (int) strlen(s) ;
    if(len==0||len>100){
        return YGPointValue(0);
    }
    if( s[len-1]=='%' ){
        char dest[100];
        strncpy(dest, s, len-1);
        return YGPercentValue(atof(dest));
    }
    return YGPointValue(atof(s));
}

static void SetViewAttr(UIView* view,
                        NSString* attrName,
                        NSString* attrValue)
{
    NSString* methodDesc = [NSString stringWithFormat:@"setFlex%@:",attrName];
    
    SEL sel = NSSelectorFromString(methodDesc) ;
    if(sel == nil)
    {
        NSLog(@"Flexbox: %@ no method %@",[view class],methodDesc);
        return ;
    }
    
    // avoid performSelector, because maybe blocked by Apple.
    
    NSMethodSignature* sig = [[view class] instanceMethodSignatureForSelector:sel];
    if(sig == nil)
    {
        NSLog(@"Flexbox: %@ no method %@",[view class],methodDesc);
        return ;
    }
    
    @try{
        
        NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig] ;
        [inv setTarget:view];
        [inv setSelector:sel];
        [inv setArgument:&attrValue atIndex:2];
        
        [inv invoke];
    }@catch(NSException* e){
        NSLog(@"Flexbox: %@ called failed.",methodDesc);
    }
}

static void ApplyLayoutParam(YGLayout* layout,
                             NSString* key,
                             NSString* value)
{
    const char* k = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char* v = [value cStringUsingEncoding:NSASCIIStringEncoding];
 
#define SETENUMVALUE(item,table,type)      \
if(strcmp(k,#item)==0)                \
{                                        \
layout.item=(type)String2Int(v,table,sizeof(table)/sizeof(NameValue));                  \
return;                                  \
}                                        \

#define SETYGVALUE(item)       \
if(strcmp(k,#item)==0)          \
{                               \
layout.item=String2YGValue(v);  \
return;                         \
}                               \

#define SETNUMVALUE(item)       \
if(strcmp(k,#item)==0)          \
{                               \
layout.item=atof(v);            \
return;                         \
}

SETENUMVALUE(direction,_direction,YGDirection);
SETENUMVALUE(flexDirection,_flexDirection,YGFlexDirection);
SETENUMVALUE(justifyContent,_justify,YGJustify);
SETENUMVALUE(alignContent,_align,YGAlign);
SETENUMVALUE(alignItems,_align,YGAlign);
SETENUMVALUE(alignSelf,_align,YGAlign);
SETENUMVALUE(position,_positionType,YGPositionType);
SETENUMVALUE(flexWrap,_wrap,YGWrap);
SETENUMVALUE(overflow,_overflow,YGOverflow);
SETENUMVALUE(display,_display,YGDisplay);

    SETNUMVALUE(flexGrow);
    SETNUMVALUE(flexShrink);
    
    SETYGVALUE(left);
    SETYGVALUE(top);
    SETYGVALUE(right);
    SETYGVALUE(bottom);
    SETYGVALUE(start);
    SETYGVALUE(end);

    SETYGVALUE(marginLeft);
    SETYGVALUE(marginTop);
    SETYGVALUE(marginRight);
    SETYGVALUE(marginBottom);
    SETYGVALUE(marginStart);
    SETYGVALUE(marginEnd);
    SETYGVALUE(marginHorizontal);
    SETYGVALUE(marginVertical);
    SETYGVALUE(margin);
    
    SETYGVALUE(paddingLeft);
    SETYGVALUE(paddingTop);
    SETYGVALUE(paddingRight);
    SETYGVALUE(paddingBottom);
    SETYGVALUE(paddingStart);
    SETYGVALUE(paddingEnd);
    SETYGVALUE(paddingHorizontal);
    SETYGVALUE(paddingVertical);
    SETYGVALUE(padding);
    
    SETNUMVALUE(borderLeftWidth);
    SETNUMVALUE(borderTopWidth);
    SETNUMVALUE(borderRightWidth);
    SETNUMVALUE(borderBottomWidth);
    SETNUMVALUE(borderStartWidth);
    SETNUMVALUE(borderEndWidth);
    SETNUMVALUE(borderWidth);
    
    SETYGVALUE(width);
    SETYGVALUE(height);
    SETYGVALUE(minWidth);
    SETYGVALUE(minHeight);
    SETYGVALUE(maxWidth);
    SETYGVALUE(maxHeight);
    
    SETNUMVALUE(aspectRatio);
    
    NSLog(@"Flexbox: not supported layout attr - %@",key);
}

//增加对单一flex属性的支持，相当于同时设置flexGrow和flexShrink
static void ApplyLayoutWithFlex(YGLayout* layout,
                                NSString* key,
                                NSString* value)
{
    if( [key compare:@"flex" options:NSLiteralSearch]==NSOrderedSame)
    {
        ApplyLayoutParam(layout, @"flexShrink", value);
        ApplyLayoutParam(layout, @"flexGrow", value);
    }else{
        ApplyLayoutParam(layout, key, value);
    }
}
@interface FlexNode()

@property (nonatomic, strong) NSString* viewClassName;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* onPress;
@property (nonatomic, strong) NSArray<FlexAttr*>* layoutParams;
@property (nonatomic, strong) NSArray<FlexAttr*>* viewAttrs;
@property (nonatomic, strong) NSArray<FlexNode*>* children;

@end

@implementation FlexNode

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _viewClassName = [coder decodeObjectForKey:VIEWCLSNAME];
        _name = [coder decodeObjectForKey:NAME];
        _onPress = [coder decodeObjectForKey:ONPRESS];
        _layoutParams = [coder decodeObjectForKey:LAYOUTPARAM];
        _viewAttrs = [coder decodeObjectForKey:VIEWATTRS];
        _children = [coder decodeObjectForKey:CHILDREN];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_viewClassName forKey:VIEWCLSNAME];
    [aCoder encodeObject:_name forKey:NAME];
    [aCoder encodeObject:_onPress forKey:ONPRESS];
    [aCoder encodeObject:_layoutParams forKey:LAYOUTPARAM];
    [aCoder encodeObject:_viewAttrs forKey:VIEWATTRS];
    [aCoder encodeObject:_children forKey:CHILDREN];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"FlexNode: %@, %@, %@, %@, %@", self.viewClassName, self.layoutParams, self.viewAttrs, self.children, self.onPress];
}

-(UIView*)buildViewTree:(NSObject*)owner
               RootView:(FlexRootView*)rootView
{
    if( self.viewClassName==nil){
        return nil;
    }
    Class cls = NSClassFromString(self.viewClassName) ;
    UIView* view = [[cls alloc]init];
    if(![view isKindOfClass:[UIView class]]){
        NSLog(@"Flexbox: %@ is not child class of UIView.", self.viewClassName);
        return nil;
    }
    
    if(self.name != nil){
        @try{
            [owner setValue:view forKey:self.name];
        }@catch(NSException* exception){
            NSLog(@"Flexbox: name %@ not found in owner",self.name);
        }@finally
        {
        }
    }
    
    if(self.onPress != nil){
        SEL sel = NSSelectorFromString(self.onPress);
        if(sel!=nil){
            if([owner respondsToSelector:sel]){
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:owner action:sel];
                [view addGestureRecognizer:tap];
            }else{
                NSLog(@"Flexbox: owner %@ not respond %@", [owner class] , self.onPress);
            }
        }else{
            NSLog(@"Flexbox: wrong onPress name %@", self.onPress);
        }
    }
    
    [view configureLayoutWithBlock:^(YGLayout* layout){
        
        layout.isEnabled = YES;
        
        NSArray<FlexAttr*>* layoutParam = self.layoutParams ;

        for (FlexAttr* attr in layoutParam) {
            if([attr.name compare:@"@" options:NSLiteralSearch]==NSOrderedSame){
                
                NSArray* ary = [[FlexStyleMgr instance]getStyleByRefPath:attr.value];
                for(FlexAttr* styleAttr in ary)
                {
                    ApplyLayoutWithFlex(layout, styleAttr.name, styleAttr.value);
                }
                
            }else{
                ApplyLayoutWithFlex(layout, attr.name, attr.value);
            }
        }
    }];
    
    if(self.viewAttrs.count > 0){
        NSArray<FlexAttr*>* attrParam = self.viewAttrs ;
        for (FlexAttr* attr in attrParam) {
            if([attr.name compare:@"@" options:NSLiteralSearch]==NSOrderedSame){
                
                NSArray* ary = [[FlexStyleMgr instance]getStyleByRefPath:attr.value];
                for(FlexAttr* styleAttr in ary)
                {
                    SetViewAttr(view, styleAttr.name, styleAttr.value);
                }
                
            }else{
                SetViewAttr(view, attr.name, attr.value);
            }
        }
    }
    
    if(self.children.count > 0){
        NSArray* children = self.children ;
        for(FlexNode* node in children){
            UIView* child = [node buildViewTree:owner RootView:rootView] ;
            if(child!=nil && ![child isKindOfClass:[FlexModalView class]])
            {
                [view addSubview:child];
            }
        }
    }
    
    [rootView registSubView:view];
    [view postCreate];
    
    return view;
}

#pragma mark - build / parse

+(NSArray*)parseStringParams:(NSString*)param
{
    if( param.length==0 )
        return nil;
    
    NSMutableArray* result = [NSMutableArray array];
    
    NSArray* parts = [param componentsSeparatedByString:@","];
    NSCharacterSet* whiteSet = [NSCharacterSet whitespaceCharacterSet] ;
    
    for (NSString* part in parts)
    {
        NSArray* two = [part componentsSeparatedByString:@":"];
        if( two.count!=2 )
            continue;
        
        FlexAttr* attr = [[FlexAttr alloc]init];
        attr.name = [two[0] stringByTrimmingCharactersInSet:whiteSet];
        attr.value = [two[1] stringByTrimmingCharactersInSet:whiteSet];
        
        if(attr.isValid){
            [result addObject:attr];
        }
    }
    
    return [result copy];
}
+(FlexNode*)buildNodeWithXml:(GDataXMLElement*)element
{
    FlexNode* node = [[FlexNode alloc]init];
    node.viewClassName = [element name];
    
    // layout param
    GDataXMLNode* name = [element attributeForName:@"name"];
    if(name){
        node.name = [name stringValue];
    }
    
    // onPress
    GDataXMLNode* onpress = [element attributeForName:@"onPress"];
    if(onpress){
        node.onPress = [onpress stringValue];
    }
    
    // layout param
    GDataXMLNode* layout = [element attributeForName:@"layout"];
    if(layout){
        NSString* param = [layout stringValue];
        node.layoutParams = [FlexNode parseStringParams:param];
    }
    
    GDataXMLNode* attr = [element attributeForName:@"attr"];
    if(attr){
        NSString* param = [attr stringValue];
        node.viewAttrs = [FlexNode parseStringParams:param];
    }
    
    // children
    NSArray* children = [element children];
    if( children.count > 0 ){
        NSMutableArray* childNodes = [NSMutableArray array] ;
        
        for(GDataXMLElement* child in children){
            [childNodes addObject:[FlexNode buildNodeWithXml:child]];
        }
        node.children = [childNodes copy] ;
    }
    
    return node;
}
+(FlexNode*)loadNodeFile:(NSString*)nodePath
{
    NSData *xmlData = [NSData dataWithContentsOfFile:nodePath];
    
    if(xmlData == nil){
        NSLog(@"FlexNode file %@ load failed.",nodePath);
        return nil;
    }
    
    NSError* error = nil;
    GDataXMLDocument* xmlDoc = [[GDataXMLDocument alloc]initWithData:xmlData options:0 error:&error];
    
    if(error){
        NSLog(@"Flexbox: xml parse failed: %@",error);
        return nil;
    }
    
    GDataXMLElement* root=[xmlDoc rootElement];
    return [FlexNode buildNodeWithXml:root];
}

+(void)Test{
    NSString* path= [[NSBundle mainBundle]pathForResource:@"test" ofType:@"xml"];
    [FlexNode loadNodeFile:path];
}
@end
