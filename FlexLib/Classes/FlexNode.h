/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import <Foundation/Foundation.h>

#define FLEXBASEURL     @"flexPreviewBaseUrl"
#define FLEXONLINELOAD  @"flexOnlineLoadRes"

@class FlexRootView;
@class YGLayout;

typedef NSData* (*FlexLoadFunc)(NSString* flexName);

typedef enum{
    flexFromFile = 0,
    flexFromNet = 1,
    flexCustomLoad = 2,
}FlexLoadMethod;


// 注意: 下面这些设置的资源加载方式函数是同步调用
// 如果从网络获取资源可能会导致界面阻塞
// 设置资源加载方式：网络 or 本地文件
// 仅在debug模式下生效，release下自动从本地文件加载
void FlexSetLoadFunc(FlexLoadMethod loadFrom);

// 设置自定义资源加载方式，任何方式都可生效
void FlexSetCustomLoadFunc(FlexLoadFunc func);

FlexLoadMethod FlexGetLoadMethod(void);

// 恢复预览设置，仅在debug下生效
void FlexRestorePreviewSetting(void);

// 默认情况下，只在release模式下使用缓存，可以使用
// 该方法在debug模式下启用或者在release模式下关闭
// 缓存，如果启用缓存，将导致上述加载方法失效
void FlexEnableCache(BOOL bEnable);

BOOL FlexIsCacheEnabled(void);

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
+(NSString*)getCacheDir;
+(void)clearFlexCache;

-(instancetype)initWithCoder:(NSCoder *)coder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

-(UIView*)buildViewTree:(NSObject*)owner
               RootView:(FlexRootView*)rootView;

@end
