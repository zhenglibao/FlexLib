/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */


#import <Foundation/Foundation.h>

@class FlexRootView;

void FlexSetViewAttr(UIView* view,
                     NSString* attrName,
                     NSString* attrValue);

@interface FlexNode : NSObject<NSCoding>

+(FlexNode*)loadNodeFile:(NSString*)nodePath;

-(instancetype)initWithCoder:(NSCoder *)coder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

-(UIView*)buildViewTree:(NSObject*)owner
               RootView:(FlexRootView*)rootView;

+(void)Test;

@end
