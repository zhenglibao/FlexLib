//
//  FlexStyleMgr.m
//  Expecta
//
//  Created by zhenglibao on 2017/12/5.
//

#import "FlexStyleMgr.h"
#import "GDataXMLNode.h"


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
        GDataXMLNode* styleNameNode = [style attributeForName:@"name"];
        NSString* styleName = [styleNameNode stringValue];
        if(styleName.length == 0)
            continue;
        
        NSMutableArray* flexAttrs = [NSMutableArray array];
        NSArray* attrs = [style children] ;
        for(GDataXMLElement* attr in attrs)
        {
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
@end

/////////////////////////////

static FlexStyleMgr* _instance=nil;

@interface FlexStyleMgr()
{
    NSMutableDictionary<NSString*,FlexStyleGroup*>* _files;
}
@end

@implementation FlexStyleMgr

-(instancetype)init
{
    self = [super init];
    if(self){
        _files = [NSMutableDictionary dictionary];
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
        group = [[FlexStyleGroup alloc]init];
        
        NSString* filePath = [[NSBundle mainBundle]pathForResource:fileName ofType:@"style"];
        [group loadFromFile:filePath];
        [_files setObject:group forKey:fileName];
    }
    return group;
}
-(NSArray<FlexAttr*>*)getStyle:(NSString*)fileName
                     StyleName:(NSString*)styleName
{
    FlexStyleGroup* group = [self getStyleGroup:fileName];
    
    return [group getStyleByName:styleName];
}
-(NSArray<FlexAttr*>*)getStyleByRefPath:(NSString*)ref
{
    NSArray* ary = [ref componentsSeparatedByString:@"/"];
    if(ary.count==2)
    {
        return [self getStyle:ary[0] StyleName:ary[1]];
    }
    return [NSArray array];
}
@end
