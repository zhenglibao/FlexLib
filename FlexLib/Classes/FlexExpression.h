/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import <UIKit/UIKit.h>

typedef double (^FlexMacro)(void);

/**
 * 设置自定义宏，宏可以用在表达式里面，如果宏名称和已有的重名，将会覆盖掉原来的宏
 */
void FlexRegisterMacro(NSString* macroName,FlexMacro value);

/**
 * 获取宏的值
 */
double FlexGetMacroValue(NSString* macro);

/**
 * 计算表达式的值，比如 ScreenWidth / 3 + 20
 */
double FlexCalcExpression(NSString* expression);


