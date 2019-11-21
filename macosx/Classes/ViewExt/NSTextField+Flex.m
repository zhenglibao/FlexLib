/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "NSTextField+Flex.h"
#import "NSView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"

static NameValue _gBorderStyle[] =
{
    {"squareBezel", NSTextFieldSquareBezel},
    {"roundedBezel", NSTextFieldRoundedBezel},
};

@implementation NSTextField (Flex)


FLEXSET(text)
{
    self.stringValue = sValue ;
}

FLEXSET(placeholder)
{
    self.placeholderString = sValue ;
}

FLEXSET(bgColor)
{
    NSColor* clr = colorFromString(sValue,owner) ;
    if(clr!=nil){
        self.backgroundColor = clr;
    }
}
FLEXSETBOOL(drawsBackground)

FLEXSET(fontSize)
{
    float nSize = [sValue floatValue];
    if(nSize > 0){
        NSFont* font = [NSFont systemFontOfSize:nSize];
        self.font = font;
    }
}
FLEXSETCLR(textColor)

FLEXSETBOOL(bordered)

FLEXSETBOOL(bezeled)

FLEXSETBOOL(editable)

FLEXSETBOOL(selectable)

FLEXSET(bezelStyle)
{
    self.bezelStyle = (NSTextFieldBezelStyle)NSString2Int(sValue, _gBorderStyle, sizeof(_gBorderStyle)/sizeof(NameValue));
}
FLEXSETFLT(preferredMaxLayoutWidth)

FLEXSETINT(maximumNumberOfLines)

FLEXSETBOOL(allowsDefaultTighteningForTruncation)

FLEXSET(allowsCharacterPickerTouchBarItem)
{
    self.allowsCharacterPickerTouchBarItem = String2BOOL(sValue);
}
FLEXSET(automaticTextCompletionEnabled)
{
    self.automaticTextCompletionEnabled = String2BOOL(sValue);
}

FLEXSETBOOL(allowsEditingTextAttributes)

FLEXSETBOOL(importsGraphics)


@end

#pragma clang diagnostic pop
