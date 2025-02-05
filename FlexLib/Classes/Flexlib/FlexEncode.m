/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "FlexEncode.h"

#pragma mark - 编解码数据

void FlexEncodeUleb128(uint64_t value, NSMutableData* result)
{
    
    uint8_t buffer[10];
    size_t index = 0;

    do {
        uint8_t byte = value & 0x7f;
        value >>= 7;

        if (value != 0) {
            byte |= 0x80;
        }

        buffer[index++] = byte;
    } while (value != 0);

    [result appendBytes:buffer length:index];
}

uint64_t FlexDecodeUleb128(const uint8_t** buf) {
    const uint8_t* p = *buf;
    
    uint64_t result = 0;
    int         bit = 0;
    do {
        uint64_t slice = *p & 0x7f;

        if (bit >= 64 || slice << bit >> bit != slice)
            abort(); // "uleb128 too big for 64-bits";
        else {
            result |= (slice << bit);
            bit += 7;
        }
    }
    while (*p++ & 0x80);
    
    *buf = p;
    
    return result;
}

void FlexEncodeString(NSString* str,NSMutableData* result)
{
    if(str==nil)
    {
        unsigned char c = 0xff;
        [result appendBytes:&c length:1];
    }else
    {
        const char* utf8 = str.UTF8String;
        uint64_t len = strlen(utf8);
        [result appendBytes:utf8 length:len+1];
    }
}

NSString* FlexDecodeString(const uint8_t** p)
{
    const char* buf = (const char*) (*p);
    
    if(**p==0xff)
    {
        *p += 1;
        return nil;
    }
    NSString* s = [NSString stringWithUTF8String:buf];
    *p = (const uint8_t*) buf + strlen(buf) + 1;
    return s;
}

void FlexEncodeObject(id obj,NSMutableData* data)
{
    if(obj==nil)
    {
        char c = 0;
        [data appendBytes:&c length:1];
    }else{
        const char* clsName = NSStringFromClass([obj class]).UTF8String;
        [data appendBytes:clsName length:strlen(clsName)+1];
        
        [obj encodeToData:data];
    }
}
id FlexDecodeObject(const uint8_t** p)
{
    const char* buf = (const char*) (*p);
    
    if(*buf == 0)
    {
        *p += 1;
        return nil;
    }
    
    Class cls = NSClassFromString([NSString stringWithUTF8String:buf]);
    *p = (const uint8_t*) buf + strlen(buf) + 1;
    
    if(cls==nil){
        return nil;
    }
    
    id obj = [[cls alloc]init];
    [obj decodeFromData:p];
    return obj;
}

void FlexEncodeArray(NSArray* ary,NSMutableData* _Nonnull data)
{
    if(ary==nil)
    {
        char c = 0;
        [data appendBytes:&c length:1];
        return;
    }
    
    char flag = 1;
    [data appendBytes:&flag length:1];
    
    FlexEncodeUleb128(ary.count, data);
    
    for (id item in ary) {
        FlexEncodeObject(item, data);
    }
}
NSArray* FlexDecodeArray(const uint8_t*_Nonnull*_Nonnull p)
{
    if(*p == 0){
        *p += 1;
        return nil;
    }
        
    *p += 1;
    uint64_t count = FlexDecodeUleb128(p);
    
    NSMutableArray* ary = [NSMutableArray arrayWithCapacity:count];
    for (uint64_t i=0; i<count; i++) {
        id item = FlexDecodeObject(p);
        if(item)
        {
            [ary addObject:item];
        }
    }
    return ary;
}

@implementation NSObject(FlexEncode)

- (void)decodeFromData:(const uint8_t * _Nonnull *)data
{
}
- (void)encodeToData:(NSMutableData *)data
{
}

@end

