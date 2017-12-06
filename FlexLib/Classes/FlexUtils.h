//
//  FlexUtils.h
//  Expecta
//
//  Created by zhenglibao on 2017/12/5.
//

#import <Foundation/Foundation.h>

typedef struct {
    const char* name;
    int   value;
} NameValue;

// 在表中查询s字符串，将其转换成int值
int String2Int(const char* s,
               NameValue table[],
               int total);

int NSString2Int(NSString* s,
                 NameValue table[],
                 int total);

// 字符串转换成颜色值，格式：black or #rrggbb or #aarrggbb
UIColor* colorFromString(NSString* clr);

