/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


/*
 这个例子演示了以下几种情况：
 1. 使用FlexTextView设置最大高度和最小高度，然后该输入框会根据输入内容自动调整高度
 2. 在FlexBaseVC的派生类中调用prepareInputs，然后自动设置键盘工具条，可以用来
    切换输入框等
 3. 通过程序往xml布局中动态添加、删除控件
 */

@interface TextViewVC : FlexBaseVC

@end
