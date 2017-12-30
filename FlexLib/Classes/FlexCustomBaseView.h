/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

/**
 * This class is designed for custom view class which
 * will be inflated from xml layout file.
 * There two ways to create FlexCustomBaseView decendent:
 * 1. Declare it in xml layout file.
 * 2. Call initWithFrame in traditional way.
 */

@interface FlexCustomBaseView : UIView

//宽和高是否可变？缺省值均为NO
@property(nonatomic,assign) BOOL flexibleWidth;
@property(nonatomic,assign) BOOL flexibleHeight;

// override this to provide custom flex name
-(NSString*)getFlexName;

// override this to do aditional initialize
-(void)onInit;

@end
