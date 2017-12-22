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

@interface FlexBaseVC : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,readonly) FlexRootView* rootView;
//自动躲避键盘
@property(nonatomic,assign) BOOL avoidKeyboard;
@property(nonatomic,readonly) float keyboardHeight;

// call this to provide flex res name
-(instancetype)initWithFlexName:(NSString*)flexName;

// override this to provide flex res name
-(NSString*)getFlexName;

// find the view with viewName in xml layout
-(UIView*)findByName:(NSString*)viewName;

// 支持热更新
- (void)resetByFlexData:(NSData*)flexData;

// override this to do something when xml updated
-(void)onLayoutReload;

// override this to provide status bar height
-(CGFloat)getStatusBarHeight:(BOOL)portrait;

// override this to provide different safeArea
- (UIEdgeInsets)getSafeArea:(BOOL)portrait;


-(void)layoutFlexRootViews;

// 查找view所在的最近一层的scrollview
-(UIScrollView*)scrollViewOfControl:(UIView*)view;

//scroll滚动到可见区域,该view必须位于UIScrollView上
-(void)scrollViewToVisible:(UIView*)view
                  animated:(BOOL)bAnim;

// derived class call this to prepare inputs
-(void)prepareInputs;

// override to submit form
-(void)submitForm;

@end
