/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import <AppKit/AppKit.h>

@class FlexRootView;

@interface FlexBaseVC : NSViewController

@property(nonatomic,readonly) FlexRootView* rootView;

// call this to provide flex res name
-(instancetype)initWithFlexName:(NSString*)flexName;

// override this to provide flex res name
-(NSString*)getFlexName;

// find the view with viewName in xml layout
-(NSView*)findByName:(NSString*)viewName;

// 支持热更新
- (void)resetByFlexData:(NSData*)flexData;

// override this to do something when xml updated
-(void)onLayoutReload;

// override this to provide different safeArea
- (NSEdgeInsets)getSafeArea:(BOOL)portrait;

@end
