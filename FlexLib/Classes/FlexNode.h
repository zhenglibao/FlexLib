/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import <Foundation/Foundation.h>

@class FlexRootView;
@class YGLayout;

typedef NSData* (*FlexLoadFunc)(NSString* flexName);

// 设置资源加载方式：网络 or 本地文件
// 仅在debug模式下生效，release下自动从本地文件加载
void FlexSetLoadFunc(BOOL bFromNet);

// 设置自定义资源加载方式，任何方式都可生效
void FlexSetCustomLoadFunc(FlexLoadFunc func);

// 设置视图属性
void FlexSetViewAttr(UIView* view,
                     NSString* attrName,
                     NSString* attrValue);

// 设置布局属性
void FlexApplyLayoutParam(YGLayout* layout,
                          NSString* key,
                          NSString* value);

@interface FlexNode : NSObject<NSCoding>

+(FlexNode*)loadNodeFromRes:(NSString*)flexName;
+(FlexNode*)loadNodeData:(NSData*)data;

-(instancetype)initWithCoder:(NSCoder *)coder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

-(UIView*)buildViewTree:(NSObject*)owner
               RootView:(FlexRootView*)rootView;

@end
