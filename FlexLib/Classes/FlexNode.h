//
//  FlexNode.h
//  FlexLayout
//
//  Created by zhenglibao on 2017/11/28.
//  Copyright © 2017年 wbg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlexRootView;

@interface FlexNode : NSObject<NSCoding>

+(FlexNode*)loadNodeFile:(NSString*)nodePath;

-(instancetype)initWithCoder:(NSCoder *)coder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

-(UIView*)buildViewTree:(NSObject*)owner
               RootView:(FlexRootView*)rootView;

+(void)Test;

@end
