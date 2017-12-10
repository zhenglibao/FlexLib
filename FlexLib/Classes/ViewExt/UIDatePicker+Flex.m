/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "UIDatePicker+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

static NameValue _gPickerMode[] =
{
    {"time", UIDatePickerModeTime},
    {"date", UIDatePickerModeDate},
    {"dateTime", UIDatePickerModeDateAndTime},
    {"countDownTimer", UIDatePickerModeCountDownTimer},
};

@implementation UIDatePicker (Flex)

FLEXSET(pickerMode)
{
    self.datePickerMode = NSString2Int(sValue, _gPickerMode, sizeof(_gPickerMode)/sizeof(NameValue));
}

@end
