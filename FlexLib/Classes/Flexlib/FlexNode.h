/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import <UIKit/UIKit.h>


#define FLEXBASEURL     @"flexPreviewBaseUrl"
#define FLEXONLINELOAD  @"flexOnlineLoadRes"
#define FLEXINDEXNAME   @"_flexres.idx"


@class FlexRootView;
@class YGLayout;
@class FlexAttr;
@class FlexNode;

NS_ASSUME_NONNULL_BEGIN


typedef NSData* _Nullable (*FlexLoadFunc)(NSString* flexName,NSObject* _Nullable owner);
typedef CGFloat (*FlexScaleFunc)(CGFloat f,const char* attrName);
typedef void (*FlexMapColor)(int* _Nonnull r,int*  g,int* b,int* a);

typedef enum{
    flexFromFile = 0,
    flexFromNet = 1,
    flexCustomLoad = 2,
}FlexLoadMethod;

#pragma mark - global functions

// 注意: 下面这些设置的资源加载方式函数是同步调用
// 如果从网络获取资源可能会导致界面阻塞
// 设置资源加载方式：网络 or 本地文件
void FlexSetLoadFunc(FlexLoadMethod loadFrom);

// 设置自定义资源加载方式
void FlexSetCustomLoadFunc(FlexLoadFunc func);
FlexLoadMethod FlexGetLoadMethod(void);

// 设置资源后缀，用来支持多种模式，比如暗黑模式
void FlexSetResourceSuffix(NSString* resourceSuffix);
NSString* _Nullable FlexGetResourceSuffix(void);

// 恢复预览设置，仅在debug下生效
void FlexRestorePreviewSetting(void);

// 默认情况下，只在release模式下使用缓存，可以使用
// 该方法在debug模式下启用或者在release模式下关闭
// 缓存，如果启用缓存，将导致上述加载方法失效
void FlexEnableCache(BOOL bEnable);
BOOL FlexIsCacheEnabled(void);

// 默认情况下，只在release模式下开启内存缓存
void FlexEnableMemoryCache(BOOL bEnable);
BOOL FlexIsMemoryCacheEnabled(void);


// 设置视图属性
void FlexSetViewAttr(UIView* view,
                     NSString* attrName,
                     NSString* attrValue,
                     NSObject* _Nullable owner);

// 设置布局属性
void FlexApplyLayoutParam(YGLayout* layout,
                          NSString* key,
                          NSString* value);

// 判断标签是否是布局属性
BOOL FlexIsLayoutAttr(NSString* attrName);

///////////////////////////////////////
//预览设置
//设置baseUrl
void FlexSetPreviewBaseUrl(NSString* filexName);
NSString* FlexGetPreviewBaseUrl(void);

// 设置flex资源目录索引
void FlexSetFlexIndex(NSDictionary* resIndex);
void FlexLoadFlexIndex(void);

//通过http拉取布局文件
NSData* _Nullable FlexFetchLayoutFile(NSString* flexName,NSError** _Nullable outError);

//拉取http资源
NSData* _Nullable FlexFetchHttpRes(NSString* url,
                         NSError** _Nullable outError);

// 设置缩放因子,主要针对字体，但也可以用于其他
// 以*开头的数字a，最终值将为a*factor+offset
void FlexSetScale(float fScaleFactor,float fScaleOffset);
float FlexGetScaleFactor(void);
float FlexGetScaleOffset(void);
// 设置自定义scale
void FlexSetCustomScale(FlexScaleFunc scaleFunc);

// 设置颜色映射
void FlexSetMapColor(FlexMapColor mapFunc);
FlexMapColor FlexGetMapColor(void);

// 注册预定义颜色,color为#开头的十六进制颜色值
void FlexRegisterColor(NSString* clrName,UIColor* color);
void FlexUnregisterColor(NSString* clrName);

BOOL FlexArchiveObjToFile(id obj,NSString* filePath);
id _Nullable FlexUnarchiveObjWithFile(NSString* filePath);

BOOL FlexSaveNodeToFile(FlexNode* node,NSString* filePath);
FlexNode* _Nullable FlexLoadNodeFromFile(NSString* filePath);

@interface FlexNode : NSObject<NSCoding>

@property (nonatomic, strong) NSString* viewClassName;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* onPress;
@property (nonatomic, strong) NSArray<NSString*>* classNames;
@property (nonatomic, strong) NSArray<FlexAttr*>* layoutParams;
@property (nonatomic, strong) NSArray<FlexAttr*>* viewAttrs;
@property (nonatomic, strong) NSArray<FlexNode*>* children;


+(FlexNode*)loadNodeFromRes:(NSString*)flexName
                      Owner:(NSObject* _Nullable)owner;
+(FlexNode*)loadNodeData:(NSData*)data;
+(NSString*)getCacheDir;
+(void)clearFlexCache;

-(instancetype)initWithCoder:(NSCoder *)coder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

-(void)decodeFromData:(const uint8_t*_Nonnull*_Nonnull)data;
-(void)encodeToData:(NSMutableData*)data;

-(UIView*)buildViewTree:(NSObject*)owner
               RootView:(FlexRootView*)rootView;

@end

@interface NSObject (Flex)

//load xml layout data in owner
-(NSData* _Nullable)loadXmlLayoutData:(NSString*)flexname;

//bind variables with name ?
-(BOOL)needBindVariable;

// owner custom create view
-(UIView* _Nullable)createView:(Class)cls Name:(NSString* _Nullable)name;
-(void)postCreateView:(UIView*)view;

// multi-language support
-(NSBundle* _Nullable)bundleForStrings;
-(NSString* _Nullable)tableForStrings;

// xml文件所在bundle
-(NSBundle* _Nullable)bundleForRes;

// image所在bundle，默认使用bundleForRes的结果
-(NSBundle* _Nullable)bundleForImages;

@end


@interface FlexClickRange : NSObject<NSCopying>

@property (nonatomic,copy) NSString* name;
@property (nonatomic,assign) NSRange range;
@property (nonatomic,copy) NSString* onPress;

@end


// 创建AttributedString
NSMutableAttributedString* createAttributedString(NSArray<FlexNode*>* childElems,
                                                  NSObject* owner,
                                                  UIFont* defaultFont,
                                                  UIColor* defaultColor,
                                                  NSMutableArray<FlexClickRange*>* clicks);


NS_ASSUME_NONNULL_END

