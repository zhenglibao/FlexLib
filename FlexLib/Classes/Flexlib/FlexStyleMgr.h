/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import <UIKit/UIKit.h>

@interface FlexAttr : NSObject<NSCoding>
@property(nonatomic,strong) NSString* name ;
@property(nonatomic,strong) NSString* value ;

-(BOOL)isValid;

@end

@interface FlexStyleMgr : NSObject

-(NSArray<FlexAttr*>*)getStyle:(NSString*)fileName
                     StyleName:(NSString*)styleName;

-(NSArray<FlexAttr*>*)getStyleByRefPath:(NSString*)ref;

// 获取样式
-(NSArray<FlexAttr*>*)getClassStyleByName:(NSString*)classStyleName;
-(NSArray<FlexAttr*>*)getClassStyles:(NSArray*)classStyleNames;

// 加载全局样式表，可以在class标签中使用样式表里面的样式
-(BOOL)loadClassStyle:(NSString*)classStyleFilePath;
// 清空全局样式表
-(void)removeAllClassStyles;

+(instancetype)instance;

@end
