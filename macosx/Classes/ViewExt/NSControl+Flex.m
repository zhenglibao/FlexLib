/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "NSControl+Flex.h"
#import "NSView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

static NameValue _align[] =
{
    {"left", NSTextAlignmentLeft},
    {"center", NSTextAlignmentCenter},
    {"right", NSTextAlignmentRight},
    {"justified", NSTextAlignmentJustified},
    {"natural", NSTextAlignmentNatural},
};

static NameValue _breakMode[] =
{
    {"wordWrapping", NSLineBreakByWordWrapping},
    {"charWrapping", NSLineBreakByCharWrapping},
    {"clipping", NSLineBreakByClipping},
    {"truncatingHead", NSLineBreakByTruncatingHead},
    {"truncatingTail", NSLineBreakByTruncatingTail},
    {"truncatingMiddle", NSLineBreakByTruncatingMiddle},
};
static NameValue _controlSize[] =
{
    {"regular", NSControlSizeRegular},
    {"small", NSControlSizeSmall},
    {"mini", NSControlSizeMini},
};

static NameValue _writingDirection[] =
{
    {"natural", NSWritingDirectionNatural},
    {"leftToRight", NSWritingDirectionLeftToRight},
    {"rightToLeft", NSWritingDirectionRightToLeft},
};


@implementation NSControl (Flex)

FLEXSET(enabled)
{
    self.enabled = String2BOOL(sValue);
}

FLEXSETBOOL(continuous)
FLEXSETBOOL(ignoresMultiClick)
FLEXSETINT(tag)
FLEXSETBOOL(highlighted)
FLEXSETBOOL(refusesFirstResponder)

FLEXSET(lineBreakMode)
{
    NSInteger n = NSString2Int(sValue,
                               _breakMode,
                               sizeof(_breakMode)/sizeof(NameValue));
    self.lineBreakMode = n;
}
FLEXSET(textAlign)
{
    const char* c =  [sValue cStringUsingEncoding:NSASCIIStringEncoding];
    self.alignment = (NSTextAlignment)String2Int(c, _align, sizeof(_align)/sizeof(NameValue));
}

FLEXSET(controlSize)
{
    const char* c =  [sValue cStringUsingEncoding:NSASCIIStringEncoding];
    self.controlSize = (NSControlSize)String2Int(c, _controlSize, sizeof(_controlSize)/sizeof(NameValue));
}

FLEXSETBOOL(usesSingleLineMode)

FLEXSET(baseWritingDirection)
{
    const char* c =  [sValue cStringUsingEncoding:NSASCIIStringEncoding];
    self.baseWritingDirection = (NSWritingDirection)String2Int(c, _writingDirection, sizeof(_writingDirection)/sizeof(NameValue));
}

FLEXSETBOOL(allowsExpansionToolTips)

@end
