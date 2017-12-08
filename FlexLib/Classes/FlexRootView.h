/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */


#import <UIKit/UIKit.h>


@interface FlexRootView : UIView

@property(nonatomic,assign) BOOL flexibleWidth;
@property(nonatomic,assign) BOOL flexibleHeight;

+(FlexRootView*)loadWithNodeFile:(NSString*)resName
                           Owner:(NSObject*)owner;

-(CGSize)calculateSize;

-(CGSize)calculateSize:(CGSize)szLimit;

-(void)registSubView:(UIView*)subView;

@end
