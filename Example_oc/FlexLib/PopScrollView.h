/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <FlexLib/FlexLib.h>

/*
 * PopScrollView演示了FlexScrollView的用法，当FlexScrollView的contentSize小于一定
 * 高度的时候其高度与contentSize的高度一致，不可滚动，当超过这个值的时候，FlexScrollView的
 * 高度为固定值，内容可滚动
 */

@interface PopScrollView : FlexCustomBaseView

@end
