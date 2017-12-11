/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#define FLEXSET(propName)               \
-(void)setFlex##propName:(NSString*)sValue

//下面宏属性名称与UIView的属性名称保持一致
// 声明颜色属性
#define FLEXSETCLR(propName)              \
FLEXSET(propName)                         \
{                                         \
self.propName = colorFromString(sValue);  \
}

// 声明浮点型属性
#define FLEXSETFLT(propName)              \
FLEXSET(propName)                         \
{                                         \
self.propName = [sValue floatValue];      \
}

// 声明整形属性
#define FLEXSETINT(propName)              \
FLEXSET(propName)                         \
{                                         \
self.propName = [sValue integerValue];    \
}

// 声明bool属性
#define FLEXSETBOOL(propName)             \
FLEXSET(propName)                         \
{                                         \
self.propName = String2BOOL(sValue);      \
}

// 声明double属性
#define FLEXSETDBL(propName)              \
FLEXSET(propName)                         \
{                                         \
self.propName = [sValue doubleValue];     \
}
// 声明字符串型属性
#define FLEXSETSTR(propName)              \
FLEXSET(propName)                         \
{                                         \
self.propName = sValue;                   \
}

// 声明枚举属性
#define FLEXSETENUM(propName,table)       \
FLEXSET(propName)                         \
{                                         \
NSInteger n=NSString2Int(sValue,          \
table,sizeof(table)/sizeof(NameValue));   \
self.propName = n;                        \
}

// 额外的view属性存储
@interface FlexViewAttrs : NSObject
@property(nonatomic,assign) BOOL stickTop;
@end


@interface UIView (Flex)

/**
 *The ViewAttrs that is attached to this view. It is lazily created.
 */
@property (nonatomic, readonly, strong) FlexViewAttrs* viewAttrs;

//子类可以重载做些加载后的处理
-(void)postCreate;

//子view的frame发生了改变
-(void)subFrameChanged:(UIView*)subView
                  Rect:(CGRect)newFrame;

//父view的frame发生了改变
-(void)superFrameChanged;

@end

