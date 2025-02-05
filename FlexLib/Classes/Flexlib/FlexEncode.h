/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 编解码 uint64
void FlexEncodeUleb128(uint64_t value, NSMutableData* _Nonnull result);
uint64_t FlexDecodeUleb128(const uint8_t*_Nonnull*_Nonnull buf);

// 编解码 字符串
void FlexEncodeString(NSString* str,NSMutableData* _Nonnull result);
NSString* FlexDecodeString(const uint8_t*_Nonnull*_Nonnull p);

// 编解码 对象
void FlexEncodeObject(id obj,NSMutableData* _Nonnull data);
id FlexDecodeObject(const uint8_t*_Nonnull*_Nonnull p);

// 编解码 数组
void FlexEncodeArray(NSArray* ary,NSMutableData* _Nonnull data);
NSArray* FlexDecodeArray(const uint8_t*_Nonnull*_Nonnull p);

//
@interface NSObject (FlexEncode)

-(void)decodeFromData:(const uint8_t*_Nonnull*_Nonnull)data;
-(void)encodeToData:(NSMutableData*)data;

@end


NS_ASSUME_NONNULL_END

