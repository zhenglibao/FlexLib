/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "FlexNode.h"
#import "UIView+Yoga.h"
#import "YGKLayout.h"
#import "GDataXMLNode.h"
#import "FlexStyleMgr.h"
#import "FlexUtils.h"
#import "FlexRootView.h"
#import "FlexModalView.h"
#import "FlexExpression.h"
#import "ViewExt/UIView+Flex.h"
#import "FlexEncode.h"

#define VIEWCLSNAME     @"viewClsName"
#define NAME            @"name"
#define ONPRESS         @"onPress"
#define CLASSNAMES      @"classNames"
#define LAYOUTPARAM     @"layoutParam"
#define VIEWATTRS       @"viewAttrs"
#define CHILDREN        @"children"

#pragma mark - Name values

NSData* loadFromWanglo(NSString* resName,NSObject* owner);
NSData* loadFromFile(NSString* resName,NSObject* owner);
FlexNode* loadBinaryFlex(NSString* resName,NSObject* owner);
CGFloat scaleLinear(CGFloat f,const char* attrName);

// 全局变量
static FlexLoadFunc gLoadFunc = loadFromFile;
static float gfScaleFactor = 1.0f;
static float gfScaleOffset = 0;
static FlexScaleFunc gScaleFunc = scaleLinear ;
static NSString* gResourceSuffix = nil;


#ifdef DEBUG
static BOOL gbUserCache = NO;
static BOOL gbMemoryCache = NO;
#else
static BOOL gbUserCache = YES;
static BOOL gbMemoryCache = YES;
#endif

// 布局文件索引，Flexname -> Http Url
static NSDictionary* gFlexIndex = nil;
static NSString* gBaseUrl = nil;

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
    {"space-evenly", YGJustifySpaceEvenly},
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

static CGFloat ScaleSize(const char* s,
                         const char* attrName)
{
    CGFloat f;
    if(s[0]=='*')
    {
        f = gScaleFunc(atof(s+1),attrName);
    }else{
        f = atof(s);
    }
    return f;
}

static YGValue String2YGValue(const char* s,
                              const char* attrName)
{
    if(strcmp(s, "none")==0)
    {
        return (YGValue) { .value = NAN, .unit = YGUnitUndefined };
        
    }else if(strcmp(s, "auto")==0){
        
        return (YGValue) { .value = NAN, .unit = YGUnitAuto };
        
    }
    
    int len = (int) strlen(s) ;
    if(len==0||len>100){
        NSLog(@"Flexbox: wrong number or pecentage value:%s",s);
        return YGPointValue(0);
    }
    if( s[len-1]=='%' ){
        char dest[100];
        strncpy(dest, s, len-1);
        dest[len-1]=0;
        return YGPercentValue(ScaleSize(dest,attrName));
    }
    return YGPointValue(ScaleSize(s,attrName));
}

NSString* FlexLocalizeValue(NSString* value,
                            NSObject* owner)
{
    if(value.length<2 || [value characterAtIndex:0]!='@')
        return value;
    
    NSString* key = [value substringFromIndex:1];
    if([key hasPrefix:@"@"])
        return key;
    
    NSBundle* bundle = [owner bundleForStrings];
    
    NSString* s = [bundle localizedStringForKey:key value:nil table:[owner tableForStrings]];
    
    if(s == nil){
        s = @"";
        NSLog(@"Flexbox: not found %@ in current Localizable.strings",key);
    }
    return s;
}

NSString* FlexProcessAttrValue(NSString* attrName,
                               NSString* attrValue,
                               NSObject* owner)
{
    // '*abc' means scale the value by the screen size,
    // '**abc' means '*abc'
    if(attrValue.length>=2 && [attrValue characterAtIndex:0]=='*')
    {
        NSString* v = [attrValue substringFromIndex:1];
        if([v hasPrefix:@"*"]){
            attrValue = v;
        }else{
            float f=[v floatValue];
            f = gScaleFunc(f,[attrName cStringUsingEncoding:NSUTF8StringEncoding]);
            attrValue=[NSString stringWithFormat:@"%f",f];
        }
    }
    
    // localize value
    attrValue = FlexLocalizeValue(attrValue, owner);
    return attrValue;
}

void FlexProcessExpression(NSString** key,NSString** value)
{
    if (![*key hasPrefix:@"$"]) {
        return;
    }
    
    *key = [*key substringFromIndex:1];
    *value = [NSString stringWithFormat:@"%f",FlexCalcExpression(*value)];
}

void FlexSetViewAttr(UIView* view,
                     NSString* attrName,
                     NSString* attrValue,
                     NSObject* owner)
{
    FlexProcessExpression(&attrName, &attrValue);
    
    NSString* methodDesc = [NSString stringWithFormat:@"setFlex%@:Owner:",attrName];
    
    SEL sel = NSSelectorFromString(methodDesc) ;
    if(sel == nil)
    {
        NSLog(@"Flexbox: %@ no method %@",[view class],methodDesc);
        return ;
    }
    
    attrValue = FlexProcessAttrValue(attrName,attrValue, owner);
    
    @try{
        
        IMP imp = [view methodForSelector:sel];
        
        if(imp!=NULL)
        {
            void (*func)(id,SEL,NSString*,NSObject*) = (void*)imp;
            
            func(view,sel,attrValue,owner);
        }
        
    }@catch(NSException* e){
        NSLog(@"Flexbox: **** exception occur in %@::%@ property *** \r\nReason - %@.\r\n This may cause memory leak.",[view class],attrName,[e reason]);
    }
}

BOOL FlexIsLayoutAttr(NSString* attrName)
{
    if ([attrName hasPrefix:@"$"]) {
        attrName = [attrName substringFromIndex:1];
    }
    
    static NSSet* layoutAttrs = nil;
    
    if (layoutAttrs == nil) {
        layoutAttrs = [NSSet setWithArray:@[
            @"direction",
            @"flexDirection",
            @"justifyContent",
            @"alignContent",
            @"alignItems",
            @"alignSelf",
            @"position",
            @"flexWrap",
            @"overflow",
            @"display",
            @"flex",
            @"flexGrow",
            @"flexShrink",
            @"flexBasis",
            @"left",
            @"top",
            @"right",
            @"bottom",
            @"start",
            @"end",
            @"marginLeft",
            @"marginTop",
            @"marginRight",
            @"marginBottom",
            @"marginStart",
            @"marginEnd",
            @"marginHorizontal",
            @"marginVertical",
            @"margin",
            @"paddingLeft",
            @"paddingTop",
            @"paddingRight",
            @"paddingBottom",
            @"paddingStart",
            @"paddingEnd",
            @"paddingHorizontal",
            @"paddingVertical",
            @"padding",
            @"width",
            @"height",
            @"minWidth",
            @"minHeight",
            @"maxWidth",
            @"maxHeight",
            @"aspectRatio",
        ]];
    }
    return [layoutAttrs containsObject:attrName];
}

static void initLayoutMap(NSMutableDictionary* dict)
{
#define BLK_ENUMVALUE(item,table,type)                       \
    dict[@#item] = ^(YGLayout* layout,const char* value)     \
    {                                                        \
        layout.item = (type)String2Int(value, table, sizeof(table)/sizeof(NameValue));  \
    }
    
#define BLK_YGVALUE(item)                                    \
    dict[@#item] = ^(YGLayout* layout,const char* value)     \
    {                                                        \
        layout.item = String2YGValue(value,#item);           \
    }
    
#define BLK_NUMVALUE(item)                                   \
    dict[@#item] = ^(YGLayout* layout,const char* value)     \
    {                                                        \
        layout.item=ScaleSize(value,#item);                  \
    }

    BLK_ENUMVALUE(direction,_direction,YGDirection);
    BLK_ENUMVALUE(flexDirection,_flexDirection,YGFlexDirection);
    BLK_ENUMVALUE(justifyContent,_justify,YGJustify);
    BLK_ENUMVALUE(alignContent,_align,YGAlign);
    BLK_ENUMVALUE(alignItems,_align,YGAlign);
    BLK_ENUMVALUE(alignSelf,_align,YGAlign);
    BLK_ENUMVALUE(position,_positionType,YGPositionType);
    BLK_ENUMVALUE(flexWrap,_wrap,YGWrap);
    BLK_ENUMVALUE(overflow,_overflow,YGOverflow);
    BLK_ENUMVALUE(display,_display,YGDisplay);
    
    BLK_NUMVALUE(flex);
    BLK_NUMVALUE(flexGrow);
    BLK_NUMVALUE(flexShrink);
    
    BLK_YGVALUE(flexBasis);
    
    BLK_YGVALUE(left);
    BLK_YGVALUE(top);
    BLK_YGVALUE(right);
    BLK_YGVALUE(bottom);
    BLK_YGVALUE(start);
    BLK_YGVALUE(end);

    BLK_YGVALUE(marginLeft);
    BLK_YGVALUE(marginTop);
    BLK_YGVALUE(marginRight);
    BLK_YGVALUE(marginBottom);
    BLK_YGVALUE(marginStart);
    BLK_YGVALUE(marginEnd);
    BLK_YGVALUE(marginHorizontal);
    BLK_YGVALUE(marginVertical);
    BLK_YGVALUE(margin);
    
    BLK_YGVALUE(paddingLeft);
    BLK_YGVALUE(paddingTop);
    BLK_YGVALUE(paddingRight);
    BLK_YGVALUE(paddingBottom);
    BLK_YGVALUE(paddingStart);
    BLK_YGVALUE(paddingEnd);
    BLK_YGVALUE(paddingHorizontal);
    BLK_YGVALUE(paddingVertical);
    BLK_YGVALUE(padding);
        
    BLK_YGVALUE(width);
    BLK_YGVALUE(height);
    BLK_YGVALUE(minWidth);
    BLK_YGVALUE(minHeight);
    BLK_YGVALUE(maxWidth);
    BLK_YGVALUE(maxHeight);
    
    BLK_NUMVALUE(aspectRatio);
}

static void ApplyLayoutParam(YGLayout* layout,
                             NSString* key,
                             NSString* value)
{
    FlexProcessExpression(&key, &value);
    
    static NSMutableDictionary* keyBlocks = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyBlocks = [NSMutableDictionary dictionaryWithCapacity:64];
        initLayoutMap(keyBlocks);
    });
    
    void (^b)(YGLayout* layout,const char* value) = [keyBlocks objectForKey:key];
    
    if(b!=nil)
    {
        b(layout,value.UTF8String);
    }else{
        NSLog(@"Flexbox: not supported layout attr - %@",key);
    }
}

//增加对单一flex属性的支持，相当于同时设置flexGrow和flexShrink
void FlexApplyLayoutParam(YGLayout* layout,
                          NSString* key,
                          NSString* value)
{
    if( [@"margin" compare:key options:NSLiteralSearch]==NSOrderedSame){
        
        NSArray* ary = [value componentsSeparatedByString:@"/"];
        if( ary.count==1 ){
            ApplyLayoutParam(layout, key, value);
        }else if(ary.count==4){
            ApplyLayoutParam(layout, @"marginLeft", ary[0]);
            ApplyLayoutParam(layout, @"marginTop", ary[1]);
            ApplyLayoutParam(layout, @"marginRight", ary[2]);
            ApplyLayoutParam(layout, @"marginBottom", ary[3]);
        }
        
    }else if( [@"padding" compare:key options:NSLiteralSearch]==NSOrderedSame){
        
        NSArray* ary = [value componentsSeparatedByString:@"/"];
        if( ary.count==1 ){
            ApplyLayoutParam(layout, key, value);
        }else if(ary.count==4){
            ApplyLayoutParam(layout, @"paddingLeft", ary[0]);
            ApplyLayoutParam(layout, @"paddingTop", ary[1]);
            ApplyLayoutParam(layout, @"paddingRight", ary[2]);
            ApplyLayoutParam(layout, @"paddingBottom", ary[3]);
        }
        
    }else{
        ApplyLayoutParam(layout, key, value);
    }
}

#pragma mark - FlexNode

@interface FlexNode()
@end

@implementation FlexNode

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _viewClassName = [coder decodeObjectForKey:VIEWCLSNAME];
        _name = [coder decodeObjectForKey:NAME];
        _onPress = [coder decodeObjectForKey:ONPRESS];
        _classNames = [coder decodeObjectForKey:CLASSNAMES];
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
    [aCoder encodeObject:_classNames forKey:CLASSNAMES];
    [aCoder encodeObject:_layoutParams forKey:LAYOUTPARAM];
    [aCoder encodeObject:_viewAttrs forKey:VIEWATTRS];
    [aCoder encodeObject:_children forKey:CHILDREN];
}

-(void)decodeFromData:(const uint8_t**)data
{
    [super decodeFromData:data];
    
    self.viewClassName = FlexDecodeString(data);
    self.name = FlexDecodeString(data);
    self.onPress = FlexDecodeString(data);
    
    uint64_t count = FlexDecodeUleb128(data);
    NSMutableArray<NSString*>* classNames = [NSMutableArray arrayWithCapacity:count];
    for(int i=0;i<count;i++)
    {
        [classNames addObject:FlexDecodeString(data)];
    }
    self.classNames = classNames;
    
    count = FlexDecodeUleb128(data);
    NSMutableArray<FlexAttr*>* layoutParams = [NSMutableArray arrayWithCapacity:count];
    for(int i=0;i<count;i++)
    {
        FlexAttr* attr = [[FlexAttr alloc]init];
        attr.name = FlexDecodeString(data);
        attr.value = FlexDecodeString(data);
        [layoutParams addObject:attr];
    }
    self.layoutParams = layoutParams;
    
    count = FlexDecodeUleb128(data);
    NSMutableArray<FlexAttr*>* viewAttrs = [NSMutableArray arrayWithCapacity:count];
    for(int i=0;i<count;i++)
    {
        FlexAttr* attr = [[FlexAttr alloc]init];
        attr.name = FlexDecodeString(data);
        attr.value = FlexDecodeString(data);
        [viewAttrs addObject:attr];
    }
    self.viewAttrs = viewAttrs;
    
    count = FlexDecodeUleb128(data);
    NSMutableArray<FlexNode*>* children = [NSMutableArray arrayWithCapacity:count];
    for(int i=0;i<count;i++)
    {
        FlexNode* node = [[FlexNode alloc]init];
        [node decodeFromData:data];
        [children addObject:node];
    }
    self.children = children;
}

-(void)encodeToData:(NSMutableData*)data
{
    [super encodeToData:data];
    
    FlexEncodeString(self.viewClassName, data);
    FlexEncodeString(self.name, data);
    FlexEncodeString(self.onPress, data);
    
    FlexEncodeUleb128((uint64_t)self.classNames.count, data);
    for(NSString* s in self.classNames)
    {
        FlexEncodeString(s, data);
    }
    
    FlexEncodeUleb128((uint64_t)self.layoutParams.count, data);
    for(FlexAttr* attr in self.layoutParams)
    {
        FlexEncodeString(attr.name, data);
        FlexEncodeString(attr.value, data);
    }
    
    FlexEncodeUleb128((uint64_t)self.viewAttrs.count, data);
    for(FlexAttr* attr in self.viewAttrs)
    {
        FlexEncodeString(attr.name, data);
        FlexEncodeString(attr.value, data);
    }
    
    FlexEncodeUleb128((uint64_t)self.children.count, data);
    for(FlexNode* node in self.children)
    {
        [node encodeToData:data];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"FlexNode: %@, %@, %@, %@, %@, %@", self.viewClassName, self.classNames, self.layoutParams, self.viewAttrs, self.children, self.onPress];
}

-(UIView*)buildViewTree:(NSObject*)owner
               RootView:(FlexRootView*)rootView
{
    if( self.viewClassName==nil){
        return nil;
    }
    Class cls = NSClassFromString(self.viewClassName) ;
    if(cls == nil){
        NSLog(@"Flexbox: class %@ not found.", self.viewClassName);
        return nil;
    }
    
    if(![cls isSubclassOfClass:[UIView class]]){
        NSLog(@"Flexbox: %@ is not child class of UIView.", self.viewClassName);
        return nil;
    }
    
    UIView* view = [owner createView:cls Name:self.name];
    if(view == nil)
    {
        @try{
            view = [[cls alloc]init];
            if(view == nil)
            {
                NSLog(@"Flexbox: Class %@ init return nil",cls);
                return nil;
            }
            [view afterInit:owner rootView:rootView];
        }@catch(NSException* exception){
             NSLog(@"Flexbox: Class %@ init failed - %@",cls,exception);
            return nil;
        }
    }
    
    if(self.name.length>0){
        @try{
            view.viewAttrs.name = self.name ;
            
            if([owner needBindVariable]){
                [owner setValue:view forKey:self.name];
            }
        }@catch(NSException* exception){
            NSLog(@"Flexbox: name %@ not found in owner %@",self.name,[owner class]);
        }@finally
        {
        }
    }
    
    if(self.onPress.length>0){
        SEL sel = NSSelectorFromString(self.onPress);
        if(sel!=nil){
            if([owner respondsToSelector:sel]){
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:owner action:sel];
                tap.cancelsTouchesInView = NO;
                tap.delaysTouchesBegan = NO;
                [view addGestureRecognizer:tap];
            }else{
                NSLog(@"Flexbox: owner %@ not respond %@", [owner class] , self.onPress);
            }
        }else{
            NSLog(@"Flexbox: wrong onPress name %@", self.onPress);
        }
    }
    
    //配置样式
    NSArray<FlexAttr*>* styles;
    {
        if (self.classNames!=nil && self.classNames.count>0) {
            styles  = [[FlexStyleMgr instance]getClassStyles:self.classNames];
        } else {
            styles  = [[FlexStyleMgr instance]getClassStyleByName:self.viewClassName];
        }
    }
    
    [view configureLayoutWithBlock:^(YGLayout* layout){
        
        layout.isEnabled = YES;
        layout.isIncludedInLayout = YES;
        
        [styles enumerateObjectsUsingBlock:^(FlexAttr * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (FlexIsLayoutAttr(obj.name)) {
                FlexApplyLayoutParam(layout, obj.name, obj.value);
            }
        }];
        
        NSArray<FlexAttr*>* layoutParam = self.layoutParams ;

        for (FlexAttr* attr in layoutParam) {
            if([attr.name compare:@"@" options:NSLiteralSearch]==NSOrderedSame){
                
                NSArray* ary = [[FlexStyleMgr instance]getStyleByRefPath:attr.value];
                for(FlexAttr* styleAttr in ary)
                {
                    FlexApplyLayoutParam(layout, styleAttr.name, styleAttr.value);
                }
                
            }else{
                FlexApplyLayoutParam(layout, attr.name, attr.value);
            }
        }
    }];
    
    [styles enumerateObjectsUsingBlock:^(FlexAttr * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!FlexIsLayoutAttr(obj.name)) {
            FlexSetViewAttr(view, obj.name, obj.value,owner);
        }
    }];
    
    
    if(self.viewAttrs.count > 0){
        NSArray<FlexAttr*>* attrParam = self.viewAttrs ;
        for (FlexAttr* attr in attrParam) {
            if([attr.name compare:@"@" options:NSLiteralSearch]==NSOrderedSame){
                
                NSArray* ary = [[FlexStyleMgr instance]getStyleByRefPath:attr.value];
                for(FlexAttr* styleAttr in ary)
                {
                    FlexSetViewAttr(view, styleAttr.name, styleAttr.value,owner);
                }
                
            }else{
                FlexSetViewAttr(view, attr.name, attr.value,owner);
            }
        }
    }
    
    if(self.children.count > 0 &&
       ![view buildChildElements:self.children Owner:owner RootView:rootView]){
        NSArray* children = self.children ;
        for(FlexNode* node in children){
            UIView* child = [node buildViewTree:owner RootView:rootView] ;
            if(child!=nil && ![child isKindOfClass:[FlexModalView class]])
            {
                [view addSubview:child];
            }
            
        }
    }
    
    if(![view isKindOfClass:[FlexModalView class]]){
        [rootView registSubView:view];
    }else{
        [(FlexModalView*)view setOwnerRootView:rootView];
    }
    
    [view postCreate];
    [owner postCreateView:view];
    if(view.isHidden){
        [view enableFlexLayout:NO];
    }
    
    return view;
}

#pragma mark - build / parse
//用逗号分隔
+(NSArray*)seperateByComma:(NSString*)str
{
    NSMutableArray* result = [NSMutableArray array];
    
    int s = 0;
    int e;
    
    while (s<str.length) {
        
        for(e=s;e<str.length;e++){
            unichar c = [str characterAtIndex:e];
            if(c==',')
                break;
            if(c=='\\')
               e++;
        }
        if(e>=str.length){
            [result addObject:[str substringFromIndex:s]];
            break;
        }
        if(e>s){
            NSRange range = NSMakeRange(s,e-s);
            [result addObject:[str substringWithRange:range]];
        }
        s=e+1;
    }
    return result;
}
//
+(unichar)transChar:(unichar)c
{
    static unichar transTable[]={
        '\\','\\',
        't','\t',
        'r','\r',
        'n','\n',
    };
    int count = sizeof(transTable)/sizeof(unichar);
    
    for (int i=0;i<count;i+=2) {
        if(transTable[i] == c)
            return transTable[i+1];
    }
    return c;
}
//处理转义字符
+(NSString*)transString:(NSString*)str
{
    if([str rangeOfString:@"\\"].length==0)
        return str;
    
    NSMutableString* s = [str mutableCopy];
    
    for(int i=0;i<s.length;i++){
        unichar c = [s characterAtIndex:i];
        if(c!='\\'||i+1==s.length)
            continue;
        unichar next = [s characterAtIndex:i+1];
        next = [FlexNode transChar:next];
        NSString* sc=[NSString stringWithFormat:@"%C",next];
        [s replaceCharactersInRange:NSMakeRange(i, 2) withString:sc];
    }
    return [s copy];
}
+(NSArray*)parseStringParams:(NSString*)param
{
    if( param.length==0 )
        return nil;
    
    NSMutableArray* result = [NSMutableArray array];
    
    NSArray* parts = [FlexNode seperateByComma:param];
    NSCharacterSet* whiteSet = [NSCharacterSet whitespaceAndNewlineCharacterSet] ;
    
    for (NSString* part in parts)
    {
        NSRange range = [part rangeOfString:@":"];
        if(range.length == 0)
            continue;
        
        NSString* s1 = [part substringToIndex:range.location];
        NSString* s2 = [part substringFromIndex:range.location+1];
        
        FlexAttr* attr = [[FlexAttr alloc]init];
        attr.name = [s1 stringByTrimmingCharactersInSet:whiteSet];
        attr.value = [s2 stringByTrimmingCharactersInSet:whiteSet];
        attr.value = [FlexNode transString:attr.value];
        
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
    
    // className
    GDataXMLNode* clssName = [element attributeForName:@"class"];
    if(clssName){
        NSString* cls = [clssName stringValue];
        if (cls!=nil && cls.length>0) {
            NSArray* classNames = [cls componentsSeparatedByString:@","];
            NSMutableArray* ary = [NSMutableArray array];
            NSCharacterSet* whiteSet = [NSCharacterSet whitespaceAndNewlineCharacterSet] ;
            for (NSString* name in classNames) {
                [ary addObject:[name stringByTrimmingCharactersInSet:whiteSet]];
            }
            node.classNames = ary;
        }
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
            if(![child isKindOfClass:[GDataXMLElement class]]){
                continue;
            }
            [childNodes addObject:[FlexNode buildNodeWithXml:child]];
        }
        node.children = [childNodes copy] ;
    }
    
    return node;
}
+(FlexNode*)loadNodeData:(NSData*)xmlData
{
    if(xmlData == nil){
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
+(FlexNode*)internalLoadRes:(NSString*)flexName
                      Owner:(NSObject*)owner
{
    FlexNode* node;
    BOOL isAbsoluteRes = [flexName hasPrefix:@"/"];
    
    if(gbUserCache && !isAbsoluteRes){
        node = [FlexNode loadFromCache:flexName];
        if(node != nil)
            return node;
    }
    
    NSData* xmlData = [owner loadXmlLayoutData:flexName];
    
    if(xmlData==nil){
        // 只有从本地加载的时候才支持从编译好的flex布局文件加载
        if(gLoadFunc==loadFromFile){
            node = loadBinaryFlex(flexName, owner);
            if (node!=nil) {
                return node;
            }
        }
        
        xmlData = isAbsoluteRes ? loadFromFile(flexName,owner) : gLoadFunc(flexName,owner) ;
        
        if(xmlData == nil){
            NSLog(@"Flexbox: flex res %@ load failed.",flexName);
            return nil;
        }
    }
    node = [FlexNode loadNodeData:xmlData];
    
    
    if(gbUserCache && !isAbsoluteRes){
        dispatch_async(
                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           [FlexNode storeToCache:flexName Node:node];
                       });
    }
    return node;
}
+(FlexNode*)loadNodeFromRes:(NSString*)flexName
                      Owner:(NSObject*)owner
{
    static NSCache* cache = nil;
    
    if(cache==nil){
        cache = [[NSCache alloc]init];
        cache.countLimit = 32;
        cache.evictsObjectsWithDiscardedContent = NO;
    }
    
    FlexNode* node;
    
    if(gbMemoryCache)
    {
        node = [cache objectForKey:flexName];
        
        if(node!=nil){
            return node;
        }
    }
    
    //支持资源后缀
    
    NSString* resName ;
    if (gResourceSuffix.length>0) {
        resName = [flexName stringByAppendingString:gResourceSuffix];
    }else{
        resName = flexName;
    }
    
    node = [self internalLoadRes:resName Owner:owner];
    if(node!=nil){
        if(gbMemoryCache){
            [cache setObject:node forKey:flexName];
        }
        return node;
    }
    
    if(gResourceSuffix.length==0){
        return nil;
    }
    
    // 如果带后缀的资源不存在，则使用原始资源
    node = [self internalLoadRes:flexName Owner:owner];
    
    if(node!=nil){
        if(gbMemoryCache){
            [cache setObject:node forKey:flexName];
        }
    }
    
    return node;
}
+(NSString*)getCacheDir
{
    static NSString* documentPath;
    if(documentPath == nil){
        
        NSString *buildNumber = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
        if(buildNumber.length==0)
            buildNumber = @"0";
        NSString* flexDirName = [NSString stringWithFormat:@"flex_%@",buildNumber];
        
        NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentPath = [documents[0]stringByAppendingPathComponent:flexDirName];
        
        // 创建目录
        NSFileManager* manager=[NSFileManager defaultManager];
        if(![manager fileExistsAtPath:documentPath]){
            
            [manager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        // 删除上次缓存目录
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSString* lastFolder = [userDefaults objectForKey:@"flex_cache_dir"] ?:@"flex";
        if (![flexDirName isEqualToString:lastFolder])
        {
            NSString* lastPath = [documents[0] stringByAppendingPathComponent:lastFolder];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [manager removeItemAtPath:lastPath error:NULL];
                [userDefaults setObject:flexDirName forKey:@"flex_cache_dir"];
            });
        }
        
    }
    return documentPath;
}
+(void)clearFlexCache
{
    NSString* sCacheDir = [FlexNode getCacheDir];
    
    NSFileManager* manager=[NSFileManager defaultManager];
    [manager removeItemAtPath:sCacheDir error:NULL
         ];
    [manager createDirectoryAtPath:sCacheDir withIntermediateDirectories:YES attributes:nil error:nil];
}
+(NSString*)getResCachePath:(NSString*)flexName
{
    NSString* sFilePath = [FlexNode getCacheDir];
    sFilePath = [sFilePath stringByAppendingPathComponent:flexName];
    sFilePath = [sFilePath stringByAppendingString:@".flex"];
    return sFilePath;
}

+(FlexNode*)loadFromCache:(NSString*)flexName
{
    NSString* sFilePath = [FlexNode getResCachePath:flexName];
    
    return FlexLoadNodeFromFile(sFilePath);
}

+(void)storeToCache:(NSString*)flexName
               Node:(FlexNode*)node
{
    NSString* sFilePath = [FlexNode getResCachePath:flexName];
    FlexSaveNodeToFile(node, sFilePath);
}
@end

#pragma mark - Global Functions

void FlexSetPreviewBaseUrl(NSString* filexName)
{
    gBaseUrl = [filexName copy];
}
NSString* FlexGetPreviewBaseUrl(void)
{
    return [gBaseUrl copy];
}
NSData* FlexFetchHttpRes(NSString* url,
                         NSError** outError)
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSData* result = nil;
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:url]
              completionHandler:^(NSData *data,
                                  NSURLResponse *response,
                                  NSError *error) 
      {
        if(error==nil){
            
            result = data;
        }
        dispatch_semaphore_signal(semaphore);

    }] resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return result;
}

NSData* FlexFetchLayoutFile(NSString* flexName,NSError** outError)
{
    if(gBaseUrl.length==0){
        NSLog(@"Flexbox: base url not set");
        return nil;
    }
    NSString* url ;
    
    if(gFlexIndex != nil){
        @synchronized(gFlexIndex){
            url = [gFlexIndex valueForKey:flexName];
        }
    }
    if(url == nil){
        url = [NSString stringWithFormat:@"%@%@.xml",gBaseUrl,flexName];
    }
    return FlexFetchHttpRes(url, outError);
}

FlexNode* loadBinaryFlex(NSString* resName,
                         NSObject* owner)
{
    NSString* path;
    
    if([resName hasPrefix:@"/"]){
        // it's absolute path
        path = resName ;
    }else{
        path = [[owner bundleForRes]pathForResource:resName ofType:@"flex"];
    }
    
    if(path==nil){
        return nil;
    }
    
    return FlexLoadNodeFromFile(path);
}

NSData* loadFromFile(NSString* resName,NSObject* owner)
{
    NSString* path;
    
    if([resName hasPrefix:@"/"]){
        // it's absolute path
        path = resName ;
    }else{
        path = [[owner bundleForRes]pathForResource:resName ofType:@"xml"];
    }
    
    if(path==nil){
        NSLog(@"Flexbox: resource %@ not found.",resName);
        return nil;
    }
    return [NSData dataWithContentsOfFile:path];
}
NSData* loadFromWanglo(NSString* resName,NSObject* owner)
{
    NSError* error = nil;
    NSData* flexData = FlexFetchLayoutFile(resName, &error);
    if(error != nil){
        NSLog(@"Flexbox: loadFromWanglo error: %@",error);
    }
    
    // check http result valid
    error = nil;
    GDataXMLDocument* xmlDoc = [[GDataXMLDocument alloc]initWithData:flexData options:0 error:&error];
    if (error!=nil) {
        NSLog(@"Flexbox: the data for %@ not valid, local xml resource used.(%lld)",resName,(SInt64)xmlDoc);
        
        flexData = loadFromFile(resName, owner);
    }
    return flexData;
}


void FlexSetFlexIndex(NSDictionary* resIndex)
{
    if(resIndex != nil){
        gFlexIndex = [resIndex copy];
        
        NSString* sFilePath = [FlexNode getCacheDir];
        sFilePath = [sFilePath stringByAppendingPathComponent:FLEXINDEXNAME];
        FlexArchiveObjToFile(resIndex, sFilePath);
    }
}
void FlexLoadFlexIndex(void)
{
    NSString* sFilePath = [FlexNode getCacheDir];
    sFilePath = [sFilePath stringByAppendingPathComponent:FLEXINDEXNAME];
    
    @try{
        NSDictionary* dic = FlexUnarchiveObjWithFile(sFilePath);
        if(dic!=nil){
            gFlexIndex = dic;
        }
    }@catch(NSException* exception){
    }
}

void FlexRestorePreviewSetting(void)
{
#ifdef DEBUG
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSString* baseurl = [defaults objectForKey:FLEXBASEURL];
    BOOL onlineLoad = [defaults boolForKey:FLEXONLINELOAD];
    
    FlexSetPreviewBaseUrl(baseurl);
    FlexSetLoadFunc(onlineLoad?flexFromNet:flexFromFile);
    FlexLoadFlexIndex();
#endif
}

void FlexSetLoadFunc(FlexLoadMethod loadFrom)
{
    if(loadFrom == flexFromFile){
        gLoadFunc = loadFromFile ;
    }else if(loadFrom == flexFromNet){
        gLoadFunc = loadFromWanglo ;
    }else{
        NSLog(@"Flexbox: please call FlexSetCustomLoadFunc");
    }
}
void FlexSetCustomLoadFunc(FlexLoadFunc func)
{
    gLoadFunc = func;
}
FlexLoadMethod FlexGetLoadMethod(void)
{
    if(gLoadFunc == loadFromFile)
        return flexFromFile;
    if(gLoadFunc == loadFromWanglo)
        return flexFromNet;
    return flexCustomLoad;
}
void FlexSetResourceSuffix(NSString* resourceSuffix)
{
    gResourceSuffix = resourceSuffix;
}
NSString* FlexGetResourceSuffix(void)
{
    return gResourceSuffix;
}
void FlexEnableCache(BOOL bEnable)
{
    gbUserCache = bEnable;
}
BOOL FlexIsCacheEnabled(void)
{
    return gbUserCache;
}

void FlexEnableMemoryCache(BOOL bEnable)
{
    gbMemoryCache = bEnable;
}
BOOL FlexIsMemoryCacheEnabled(void)
{
    return gbMemoryCache;
}
void FlexSetCustomScale(FlexScaleFunc scaleFunc)
{
    if(scaleFunc != NULL){
        gScaleFunc = scaleFunc ;
    }
}
void FlexSetScale(float fScaleFactor,
                  float fScaleOffset)
{
    gfScaleFactor = fScaleFactor;
    gfScaleOffset = fScaleOffset;
    gScaleFunc = scaleLinear ;
}
CGFloat scaleLinear(CGFloat f,const char* attrName)
{
    return f*gfScaleFactor+gfScaleOffset;
}
float FlexGetScaleFactor(void)
{
    return gfScaleFactor;
}

float FlexGetScaleOffset(void)
{
    return gfScaleOffset;
}

#pragma mark - Owner overridable functions

@implementation NSObject (Flex)

-(NSData*)loadXmlLayoutData:(NSString*)flexname
{
    return nil;
}

-(BOOL)needBindVariable
{
    return YES;
}
-(UIView*)createView:(Class)cls
                Name:(NSString*)name
{
    return nil;
}

-(void)postCreateView:(UIView*)view
{
    
}
-(NSBundle*)bundleForStrings
{
    return [NSBundle mainBundle];
}
-(NSString*)tableForStrings
{
    return nil;
}
-(NSBundle*)bundleForRes
{
    return [NSBundle mainBundle];
}
-(NSBundle*)bundleForImages
{
    return [self bundleForRes];
}
@end

#pragma mark - 创建AttributedString支持


static NameValue _underlineValue[] =
{
    {"none", NSUnderlineStyleNone},
    {"single", NSUnderlineStyleSingle},
    {"thick", NSUnderlineStyleThick},
    {"double", NSUnderlineStyleDouble},
    {"solid", NSUnderlinePatternSolid},
    {"dot", NSUnderlinePatternDot},
    {"dash", NSUnderlinePatternDash},
    {"dashdot", NSUnderlinePatternDashDot},
    {"dashdotdot", NSUnderlinePatternDashDotDot},
};

@implementation FlexClickRange
- (id)copyWithZone:(NSZone *)zone {
    FlexClickRange *model = [[FlexClickRange allocWithZone:zone] init];
    model.name = self.name;
    model.range = self.range;
    model.onPress = self.onPress;
    return model;
}
@end


static NSAttributedString* createAttributedText(FlexNode* node,
                                                NSObject* owner,
                                                UIFont* defaultFont,
                                                UIColor* defaultColor)
{
    NSString* text = @"";
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    for (FlexAttr* attr in node.viewAttrs) {
        
        attr.value = FlexProcessAttrValue(attr.name, attr.value, owner);
        
        if( [attr.name isEqualToString:@"text"] ){
            
            text = attr.value;
            
        }else if( [attr.name isEqualToString:@"font"]){
            
            UIFont* font = fontFromString(attr.value);
            [dict setObject:font forKey:NSFontAttributeName];
            
        }else if( [attr.name isEqualToString:@"fontSize"]){
            
            UIFont* font = [UIFont systemFontOfSize:[attr.value floatValue]];
            if(font!=nil){
                [dict setObject:font forKey:NSFontAttributeName];
            }
            
        }else if( [attr.name isEqualToString:@"color"]){
            
            UIColor* color = colorFromString(attr.value, owner);
            if( color!=nil){
                [dict setObject:color forKey:NSForegroundColorAttributeName];
            }
        }else if( [attr.name isEqualToString:@"bgColor"]){
            UIColor* color = colorFromString(attr.value, owner);
            if( color!=nil){
                [dict setObject:color forKey:NSBackgroundColorAttributeName];
            }
        }else if( [attr.name isEqualToString:@"strike"]){
            
            int underline = NSString2Int(attr.value, _underlineValue, sizeof(_underlineValue)/sizeof(NameValue));
            [dict setObject:@(underline) forKey:NSStrikethroughStyleAttributeName];
        }else if( [attr.name isEqualToString:@"underline"]){
            
            int underline = NSString2Int(attr.value, _underlineValue, sizeof(_underlineValue)/sizeof(NameValue));
            [dict setObject:@(underline) forKey:NSUnderlineStyleAttributeName];
        }else if( [attr.name isEqualToString:@"kern"]){
            
            int kern = [attr.value intValue];
            [dict setObject:@(kern) forKey:NSKernAttributeName];
        }
    }
    
    if( [dict objectForKey:NSFontAttributeName]==nil && defaultFont!=nil ){
        [dict setObject:defaultFont forKey:NSFontAttributeName];
    }
    if( [dict objectForKey:NSForegroundColorAttributeName]==nil && defaultColor!=nil ){
        [dict setObject:defaultColor forKey:NSForegroundColorAttributeName];
    }
    
    return [[NSAttributedString alloc]initWithString:text attributes:dict];
}
static NSAttributedString* createAttributedImage(FlexNode* node,NSObject* owner)
{
    NSTextAttachment* attach = [[NSTextAttachment alloc]init];
    
    for (FlexAttr* attr in node.viewAttrs) {
        
        attr.value = FlexProcessAttrValue(attr.name, attr.value, owner);
        
        if( [attr.name isEqualToString:@"source"] ){
            UIImage* img = [UIImage imageNamed:attr.value inBundle:[owner bundleForImages] compatibleWithTraitCollection:nil];
            attach.image = img ;
        }else if( [attr.name isEqualToString:@"bounds"] ){
            NSArray* ary = [attr.value componentsSeparatedByString:@"/"];
            if(ary.count>=4){
                CGFloat x = [ary[0]floatValue];
                CGFloat y = [ary[1]floatValue];
                CGFloat w = [ary[2]floatValue];
                CGFloat h = [ary[3]floatValue];
                attach.bounds = CGRectMake(x, y, w, h);
            }
        }else if( [attr.name isEqualToString:@"size"] ){
            NSArray* ary = [attr.value componentsSeparatedByString:@"/"];
            if(ary.count>=2){
                CGFloat w = [ary[0]floatValue];
                CGFloat h = [ary[1]floatValue];
                attach.bounds = CGRectMake(0, 0, w, h);
            }
        }
    }
    
    return [NSAttributedString attributedStringWithAttachment:attach];
}

NSMutableAttributedString* createAttributedString(NSArray<FlexNode*>* childElems,
                                                  NSObject* owner,
                                                  UIFont* defaultFont,
                                                  UIColor* defaultColor,
                                                  NSMutableArray<FlexClickRange*>* clicks)
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc]init];
    
    for (FlexNode* node in childElems) {
        
        NSUInteger oldLength = attrString.length;
        
        if( [node.viewClassName isEqualToString:@"Text"] ){
            
            [attrString appendAttributedString:createAttributedText(node,owner,defaultFont,defaultColor)];
            
        }else if( [node.viewClassName isEqualToString:@"Image"] ){
            
            [attrString appendAttributedString:createAttributedImage(node, owner)];
        }
        
        if( node.onPress.length>0 ){
            FlexClickRange* click = [[FlexClickRange alloc]init];
            click.name = node.name;
            click.onPress = node.onPress;
            click.range = NSMakeRange(oldLength, attrString.length-oldLength);
            [clicks addObject:click];
        }
    }
    return attrString;
}


