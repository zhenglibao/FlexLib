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

@interface FlexBaseVC : UIViewController

// call this to provide flex res name
-(instancetype)initWithFlexName:(NSString*)flexName;

// override this to provide flex res name
-(NSString*)getFlexName;

// override this to provide different safeArea
- (UIEdgeInsets)getSafeArea:(BOOL)portrait;

// get root flex view
-(UIView*)rootView;

@end
