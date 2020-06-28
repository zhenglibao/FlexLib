/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "NSTextView+Flex.h"
#import "NSView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"


@implementation NSTextView (Flex)

FLEXSET(text)
{
    self.string = sValue ;
}
FLEXSET(fontSize)
{
    float nSize = [sValue floatValue];
    if(nSize > 0){
        NSFont* font = [NSFont systemFontOfSize:nSize];
        self.font = font;
    }
}
FLEXSET(color)
{
    NSColor* clr = colorFromString(sValue,owner);
    if(clr!=nil){
        self.textColor = clr ;
    }
}

FLEXSET(textAlign)
{
//    self.textAlignment = (NSTextAlignment)NSString2Int(sValue, _align, sizeof(_align)/sizeof(NameValue));
}

FLEXSET(editable)
{
    self.editable = String2BOOL(sValue);
}
FLEXSET(selectable)
{
    self.selectable = String2BOOL(sValue);
}

FLEXSET(value)
{
    self.string = sValue;
}
FLEXSETBOOL(richText)
FLEXSETBOOL(importsGraphics)
FLEXSETBOOL(drawsBackground)
FLEXSETBOOL(fieldEditor)
FLEXSETBOOL(rulerVisible)
FLEXSETBOOL(smartInsertDeleteEnabled)
FLEXSETBOOL(allowsUndo)
FLEXSETBOOL(allowsDocumentBackgroundColorChange)
FLEXSETBOOL(usesRuler)
FLEXSETBOOL(usesInspectorBar)
FLEXSETBOOL(displaysLinkToolTips)

@end

#pragma clang diagnostic pop
