/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import <UIKit/UIKit.h>

@class FlexRootView;

@interface FlexBaseVC : UIViewController

//自动躲避键盘
@property(nonatomic,assign) BOOL avoidKeyboard;

// call this to provide flex res name
-(instancetype)initWithFlexName:(NSString*)flexName;

// override this to provide flex res name
-(NSString*)getFlexName;

// 支持热更新
- (void)resetByFlexData:(NSData*)flexData;

// override this to do something when xml updated
-(void)onLayoutReload;

// override this to provide different safeArea
- (UIEdgeInsets)getSafeArea:(BOOL)portrait;

// get root flex view
-(FlexRootView*)rootView;

-(void)layoutFlexRootViews;

//scroll滚动到可见区域,该view必须位于UIScrollView上
-(void)scrollViewToVisible:(UIView*)view
                  animated:(BOOL)bAnim;

// derived class call this to prepare inputs
-(void)prepareInputs;

// override to submit form
-(void)submitForm;

@end
