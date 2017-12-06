//
//  FlexStyleMgr.h
//  Expecta
//
//  Created by zhenglibao on 2017/12/5.
//

#import <Foundation/Foundation.h>

@interface FlexAttr : NSObject<NSCoding>
@property(nonatomic,strong) NSString* name ;
@property(nonatomic,strong) NSString* value ;

-(BOOL)isValid;

@end

@interface FlexStyleMgr : NSObject

-(NSArray<FlexAttr*>*)getStyle:(NSString*)fileName
                     StyleName:(NSString*)styleName;

-(NSArray<FlexAttr*>*)getStyleByRefPath:(NSString*)ref;

+(instancetype)instance;

@end
