/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


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

NSData* loadFromNetwork(NSString* resName,NSObject* owner);
NSData* loadFromFile(NSString* resName,NSObject* owner);
CGFloat scaleLinear(CGFloat f,const char* attrName);

// 全局变量
static FlexLoadFunc gLoadFunc = loadFromFile;
static float gfScaleFactor = 1.0f;
static float gfScaleOffset = 0;
static FlexScaleFunc gScaleFunc = scaleLinear ;

#ifdef DEBUG
static BOOL gbUserCache = NO;
#else
static BOOL gbUserCache = YES;
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
            f = gScaleFunc(f,[attrName cStringUsingEncoding:NSASCIIStringEncoding]);
            attrValue=[NSString stringWithFormat:@"%f",f];
        }
    }
    
    // localize value
    attrValue = FlexLocalizeValue(attrValue, owner);
    return attrValue;
}

void FlexSetViewAttr(UIView* view,
                     NSString* attrName,
                     NSString* attrValue,
                     NSObject* owner)
{
    NSString* methodDesc = [NSString stringWithFormat:@"setFlex%@:Owner:",attrName];
    
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
    
    attrValue = FlexProcessAttrValue(attrName,attrValue, owner);
    
    @try{
        
        NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig] ;
        [inv setTarget:view];
        [inv setSelector:sel];
        [inv setArgument:&attrValue atIndex:2];
        [inv setArgument:&owner atIndex:3];
        
        [inv invoke];
    }@catch(NSException* e){
        NSLog(@"Flexbox: **** exception occur in %@::%@ property *** \r\nReason - %@.\r\n This may cause memory leak.",[view class],attrName,[e reason]);
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
layout.item=String2YGValue(v,k);\
return;                         \
}                               \

#define SETNUMVALUE(item)       \
if(strcmp(k,#item)==0)          \
{                               \
layout.item=ScaleSize(v,k);     \
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

    SETNUMVALUE(flex);
    SETNUMVALUE(flexGrow);
    SETNUMVALUE(flexShrink);
    
    SETYGVALUE(flexBasis);
    
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
    
    [view configureLayoutWithBlock:^(YGLayout* layout){
        
        layout.isEnabled = YES;
        layout.isIncludedInLayout = YES;
        
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
+(FlexNode*)loadNodeFromRes:(NSString*)flexName
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
+(NSString*)getCacheDir
{
    static NSString* documentPath;
    if(documentPath == nil){
        NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentPath = documents[0];
        documentPath = [documentPath stringByAppendingPathComponent:@"flex"];
        
        // create run flag
        
        NSDictionary* info = [[NSBundle mainBundle] infoDictionary];
        NSString *buildNumber = info[@"CFBundleVersion"];
        if(buildNumber == nil)
            buildNumber = @"0";
        buildNumber = [@"flex_run_" stringByAppendingString:buildNumber];

        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL alreadRun = [userDefaults boolForKey:buildNumber];
       
         NSFileManager* manager=[NSFileManager defaultManager];
        if( !alreadRun ){
            
            // clear the cache by last version
            [manager removeItemAtPath:documentPath error:NULL
             ];
            [manager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
            [userDefaults setBool:YES forKey:buildNumber];
        }else{
            if(![manager fileExistsAtPath:documentPath])
                [manager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
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
    
    FlexNode* node ;
    
    @try{
        node = [NSKeyedUnarchiver unarchiveObjectWithFile:sFilePath];
        return node;
    }@catch(NSException* exception){
        NSLog(@"Flexbox: loadFromCache failed - %@",flexName);
    }
    return nil;
}
+(void)storeToCache:(NSString*)flexName
               Node:(FlexNode*)node
{
    NSString* sFilePath = [FlexNode getResCachePath:flexName];
    [NSKeyedArchiver archiveRootObject:node toFile:sFilePath];
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
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        return data;
    }else if(outError != NULL){
        *outError = error;
    }
    return nil;
}
NSData* FlexFetchLayoutFile(NSString* flexName,NSError** outError)
{
    if(gBaseUrl.length==0){
        NSLog(@"Flexbox: preview base url not set");
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
NSData* loadFromNetwork(NSString* resName,NSObject* owner)
{
    NSError* error = nil;
    NSData* flexData = FlexFetchLayoutFile(resName, &error);
    if(error != nil){
        NSLog(@"Flexbox: loadFromNetwork error: %@",error);
    }
    return flexData;
}


void FlexSetFlexIndex(NSDictionary* resIndex)
{
    if(resIndex != nil){
        gFlexIndex = [resIndex copy];
        
        NSString* sFilePath = [FlexNode getCacheDir];
        sFilePath = [sFilePath stringByAppendingPathComponent:FLEXINDEXNAME];
        [NSKeyedArchiver archiveRootObject:resIndex toFile:sFilePath];
    }
}
void FlexLoadFlexIndex(void)
{
    NSString* sFilePath = [FlexNode getCacheDir];
    sFilePath = [sFilePath stringByAppendingPathComponent:FLEXINDEXNAME];
    
    @try{
        NSDictionary* dic = [NSKeyedUnarchiver unarchiveObjectWithFile:sFilePath];
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
        gLoadFunc = loadFromNetwork ;
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
    if(gLoadFunc == loadFromNetwork)
        return flexFromNet;
    return flexCustomLoad;
}
void FlexEnableCache(BOOL bEnable)
{
    gbUserCache = bEnable;
}
BOOL FlexIsCacheEnabled(void)
{
    return gbUserCache;
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


