/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "NSDatePicker+Flex.h"
#import "NSView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

static NameValue _pickStyle[] =
{
    {"textFieldAndStepper",NSDatePickerStyleTextFieldAndStepper},
    {"clockAndCalendar",NSDatePickerStyleClockAndCalendar},
    {"textField",NSDatePickerStyleTextField},
};

static NameValue _pickMode[] =
{
    {"single",NSDatePickerModeSingle},
    {"range",NSDatePickerModeRange},
};

static NameValue _pickFlag[] =
{
    {"hourMinute",NSDatePickerElementFlagHourMinute},
    {"hourMinuteSecond",NSDatePickerElementFlagHourMinuteSecond},
    {"timeZone",NSDatePickerElementFlagTimeZone},
    {"yearMonth",NSDatePickerElementFlagYearMonth},
    {"yearMonthDay",NSDatePickerElementFlagYearMonthDay},
    {"era",NSDatePickerElementFlagEra},
};


@implementation NSDatePicker (Flex)

FLEXSETENUM(datePickerStyle, _pickStyle)

FLEXSETBOOL(bezeled)

FLEXSETBOOL(bordered)

FLEXSETBOOL(drawsBackground)

FLEXSET(bgColor)
{
    NSColor* clr = colorFromString(sValue, owner);
    if (clr) {
        self.backgroundColor = clr;
    }
}

FLEXSETCLR(textColor)

FLEXSETENUM(datePickerMode, _pickMode)

FLEXSETENUM(datePickerElements, _pickFlag)

FLEXSETDBL(timeInterval)

@end
