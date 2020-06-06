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
 * AttachmentView演示了如何将xml布局封装成一个控件，然后在
 * 另外的xml中使用这个控件。FlexCustomBaseView的两个关键属性是
 * flexibleWidth和flexibleHeight,默认值为NO，表示在使用该控件
 * 的时候必须设置宽和高，如果设置为YES，表示宽或者高由内容自身决定，
 * 则无需设置宽和高
 */

@interface AttachmentView : FlexCustomBaseView

@end
