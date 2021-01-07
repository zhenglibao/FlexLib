/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "FlexStyleMgr.h"
#import "GDataXMLNode.h"
#import "FlexNode.h"


@implementation FlexAttr
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _name = [coder decodeObjectForKey:@"name"];
        _value = [coder decodeObjectForKey:@"value"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_value forKey:@"value"];
}
-(BOOL)isValid{
    return self.name.length>0 && self.value.length>0;
}
@end

/////////////////////////////

@interface FlexStyleGroup : NSObject<NSCoding>
{
    NSMutableDictionary<NSString*,NSArray<FlexAttr*>*>* _stylesByName;
}

-(BOOL)loadFromFile:(NSString*)stylePath;

+(FlexStyleGroup*)loadStyle:(NSString*)stylePath;

-(void)removeAll;

-(NSArray*)getStyleByName:(NSString*)styleName;

@end

@implementation FlexStyleGroup

-(instancetype)init
{
    self = [super init];
    if(self){
        _stylesByName = [NSMutableDictionary dictionary];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _stylesByName = [coder decodeObjectForKey:@"styles"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_stylesByName forKey:@"styles"];
}

-(NSArray<FlexAttr*>*)getStyleByName:(NSString*)styleName
{
    NSArray<FlexAttr*>* style = [_stylesByName valueForKey:styleName];

    if( style==nil ){
        style = [NSArray array];
    }
    return style ;
}
-(void)parseStyles:(GDataXMLElement*)rootElem
{
    NSArray* styles = [rootElem children];
    
    for (GDataXMLElement* style in styles)
    {
        if(![style isKindOfClass:[GDataXMLElement class]])
            continue;
        
        NSString* elemName = [style name];
        if([@"style" compare:elemName options:NSLiteralSearch]!=NSOrderedSame)
            continue;
        
        GDataXMLNode* styleNameNode = [style attributeForName:@"name"];
        NSString* styleName = [styleNameNode stringValue];
        if(styleName.length == 0)
            continue;
        
        NSMutableArray* flexAttrs = [NSMutableArray array];
        NSArray* attrs = [style children] ;
        for(GDataXMLElement* attr in attrs)
        {
            if(![attr isKindOfClass:[GDataXMLElement class]])
                continue;
            
            NSString* attrName = [attr name];
            if([@"attr" compare:attrName options:NSLiteralSearch]!=NSOrderedSame)
                continue;
            
            GDataXMLNode* name = [attr attributeForName:@"name"];
            
            FlexAttr* flexAttr = [[FlexAttr alloc]init];
            flexAttr.name = [name stringValue];
            flexAttr.value = [attr stringValue];
            
            if(flexAttr.name.length==0 || flexAttr.value.length==0)
            {
                continue;
            }
            [flexAttrs addObject:flexAttr];
        }
        if(flexAttrs.count>0){
            [_stylesByName setObject:[flexAttrs copy] forKey:styleName];
        }
    }
}

-(BOOL)loadFromFile:(NSString*)stylePath
{
    NSData *xmlData = [NSData dataWithContentsOfFile:stylePath];
    
    if(xmlData == nil){
        NSLog(@"Flexbox: style file %@ load failed.",stylePath);
        return NO;
    }
    
    NSError* error = nil;
    GDataXMLDocument* xmlDoc = [[GDataXMLDocument alloc]initWithData:xmlData options:0 error:&error];
    
    if(error){
        NSLog(@"Flexbox: xml parse failed: %@",error);
        return NO;
    }
    
    GDataXMLElement* root=[xmlDoc rootElement];
    if(root==nil){
        return NO;
    }
    [self parseStyles:root];
    return YES;
}
+(FlexStyleGroup*)loadStyle:(NSString*)stylePath
{
    if ([stylePath hasSuffix:@".style"]) {
        FlexStyleGroup* group = [[FlexStyleGroup alloc]init];
        [group loadFromFile:stylePath];
        return group;
    }else if([stylePath hasSuffix:@".bstyle"]){
        FlexStyleGroup* node;
        
        @try{
            node = [NSKeyedUnarchiver unarchiveObjectWithFile:stylePath];
            return node;
        }@catch(NSException* exception){
            NSLog(@"Flexbox: loadStyle style failed - %@",[stylePath lastPathComponent]);
        }
    }
    return nil;
}
-(void)removeAll
{
    [_stylesByName removeAllObjects];
}

+(NSString*)getStyleCachePath:(NSString*)styleName
{
    NSString* sFilePath = [FlexNode getCacheDir];
    sFilePath = [sFilePath stringByAppendingPathComponent:styleName];
    sFilePath = [sFilePath stringByAppendingString:@".bstyle"];
    return sFilePath;
}
+(void)storeToCache:(NSString*)styleName
              Style:(FlexStyleGroup*)styleGroup
{
    NSString* sFilePath = [FlexStyleGroup getStyleCachePath:styleName];
    [NSKeyedArchiver archiveRootObject:styleGroup toFile:sFilePath];
}
+(FlexStyleGroup*)loadFromCache:(NSString*)styleName
{
    NSString* sFilePath = [FlexStyleGroup getStyleCachePath:styleName];
    
    return [self loadStyle:sFilePath];
}

@end

/////////////////////////////

static FlexStyleMgr* _instance=nil;

@interface FlexStyleMgr()
{
    NSMutableDictionary<NSString*,FlexStyleGroup*>* _files;
    FlexStyleGroup* _globalClassStyle;      // 全局样式表
}
@end

@implementation FlexStyleMgr

-(instancetype)init
{
    self = [super init];
    if(self){
        _files = [NSMutableDictionary dictionary];
        _globalClassStyle = [[FlexStyleGroup alloc]init];
    }
    return self;
}

+(instancetype)instance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _instance = [[FlexStyleMgr alloc] init];
    });
    return _instance;
}

-(FlexStyleGroup*)getStyleGroup:(NSString*)fileName
{
    FlexStyleGroup* group = [_files objectForKey:fileName];

    if(group==nil)
    {
        if(FlexIsCacheEnabled()){
            group = [FlexStyleGroup loadFromCache:fileName];
            if(group != nil)
                return group;
        }
        
        NSString* filePath = [[NSBundle mainBundle]pathForResource:fileName ofType:@"bstyle"];
        if (filePath==nil) {
            filePath = [[NSBundle mainBundle]pathForResource:fileName ofType:@"style"];
        }
        if(filePath == nil)
        {
            NSLog(@"Flexbox: style %@ not found.",fileName);
            return nil;
        }
        group = [FlexStyleGroup loadStyle:filePath];
        if (group!=nil) {
            [_files setObject:group forKey:fileName];
            
            if(FlexIsCacheEnabled() && [filePath hasSuffix:@".style"]){
                dispatch_async(
                               dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                               ^{
                                   [FlexStyleGroup storeToCache:fileName Style:group];
                               });
            }
        }
    }
    return group;
}


-(NSArray<FlexAttr*>*)getStyle:(NSString*)fileName
                     StyleName:(NSString*)styleName
{
    NSString* resourceSuffix = FlexGetResourceSuffix();
    
    if(resourceSuffix.length>0){
        FlexStyleGroup* group = [self getStyleGroup:[fileName stringByAppendingString:resourceSuffix]];
        
        if (group!=nil) {
            return [group getStyleByName:styleName];
        }
    }
    FlexStyleGroup* group = [self getStyleGroup:fileName];
    
    return [group getStyleByName:styleName];
}
-(NSArray<FlexAttr*>*)getStyleByRefPath:(NSString*)ref
{
    NSArray* ary = [ref componentsSeparatedByString:@"/"];
    if(ary.count==2)
    {
        NSArray* result = [self getStyle:ary[0] StyleName:ary[1]];
        if(result!=nil){
            return result;
        }
    }
    return [NSArray array];
}

-(NSArray<FlexAttr*>*)getClassStyleByName:(NSString*)classStyleName
{
    return [_globalClassStyle getStyleByName:classStyleName];
}

-(NSArray<FlexAttr*>*)getClassStyles:(NSArray*)classStyleNames
{
    NSMutableArray* ary = [NSMutableArray array];
    
    for (NSString* styleName in classStyleNames)
    {
        [ary addObjectsFromArray:[self getClassStyleByName:styleName]];
    }
    return ary;
}

-(BOOL)loadClassStyle:(NSString*)classStyleFilePath
{
    return [_globalClassStyle loadFromFile:classStyleFilePath];
}
-(void)removeAllClassStyles
{
    [_globalClassStyle removeAll];
}
@end
