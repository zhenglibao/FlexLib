/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import <Foundation/Foundation.h>

typedef struct {
    const char* name;
    int   value;
} NameValue;

#define FLEXSTR2INT(kvTable)    \
NSString2Int(sValue,kvTable,sizeof(kvTable)/sizeof(NameValue))

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


// 在表中查询s字符串，将其转换成int值
int String2Int(const char* s,
               NameValue table[],
               int total);

int NSString2Int(NSString* s,
                 NameValue table[],
                 int total);

// 字符串转换成颜色值，格式：black or #rrggbb or #aarrggbb
UIColor* colorFromString(NSString* clr);

// eg: white/black/....
UIColor* systemColor(NSString* clr);

// 字符串转换BOOL
BOOL String2BOOL(NSString* s);

BOOL IsIphoneX(void);

BOOL IsPortrait(void);

