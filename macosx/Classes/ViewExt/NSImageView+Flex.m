/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "NSImageView+Flex.h"
#import "NSView+Flex.h"
#import "../FlexUtils.h"
#import "../FlexNode.h"
#import <objc/runtime.h>


static NameValue _align[] =
{
    {"center", NSImageAlignCenter},
    {"top", NSImageAlignTop},
    {"topLeft", NSImageAlignTopLeft},
    {"topRight", NSImageAlignTopRight},
    {"left", NSImageAlignLeft},
    {"bottom", NSImageAlignBottom},
    {"bottomLeft", NSImageAlignBottomLeft},
    {"bottomRight", NSImageAlignBottomRight},
    {"right", NSImageAlignRight},
};

static NameValue _scaling[] =
{
    {"proportDown", NSImageScaleProportionallyDown},
    {"axesIndepend", NSImageScaleAxesIndependently},
    {"none", NSImageScaleNone},
    {"proportUpDown", NSImageScaleProportionallyUpOrDown},
};

static NameValue _frameStyle[] =
{
    {"none", NSImageFrameNone},
    {"photo", NSImageFramePhoto},
    {"grayBezel", NSImageFrameGrayBezel},
    {"groove", NSImageFrameGroove},
    {"button", NSImageFrameButton},
};


@implementation NSImageView (Flex)

FLEXSET(source)
{
    self.image = FlexLoadImage(sValue, owner);
}

FLEXSETBOOL(editable)
FLEXSETBOOL(animates)
FLEXSETBOOL(allowsCutCopyPaste)

FLEXSET(imageAlignment)
{
    const char* c =  [sValue cStringUsingEncoding:NSASCIIStringEncoding];
    self.imageAlignment = (NSImageAlignment)String2Int(c, _align, sizeof(_align)/sizeof(NameValue));
}

FLEXSET(imageScaling)
{
    const char* c =  [sValue cStringUsingEncoding:NSASCIIStringEncoding];
    self.imageScaling = (NSImageScaling)String2Int(c, _scaling, sizeof(_scaling)/sizeof(NameValue));
}

FLEXSET(imageFrameStyle)
{
    const char* c =  [sValue cStringUsingEncoding:NSASCIIStringEncoding];
    self.imageFrameStyle = (NSImageFrameStyle)String2Int(c, _frameStyle, sizeof(_frameStyle)/sizeof(NameValue));
}

FLEXSET(contentTintColor)
{
    NSColor* clr = colorFromString(sValue,owner) ;
    if(clr!=nil){
        if (@available(macOS 10.14, *)) {
            self.contentTintColor = clr ;
        } else {
        }
    }
}

@end
