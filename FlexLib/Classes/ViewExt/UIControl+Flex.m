/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "UIControl+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"


static NameValue _vertAlign[] =
{
    {"center", UIControlContentVerticalAlignmentCenter},
    {"top", UIControlContentVerticalAlignmentTop},
    {"bottom", UIControlContentVerticalAlignmentBottom},
    {"fill", UIControlContentVerticalAlignmentFill},
};

static NameValue _horzAlign[] =
{
    {"center", UIControlContentHorizontalAlignmentCenter},
    {"left", UIControlContentHorizontalAlignmentLeft},
    {"right", UIControlContentHorizontalAlignmentRight},
    {"fill", UIControlContentHorizontalAlignmentFill},
    {"leading", 4/*UIControlContentHorizontalAlignmentLeading*/},
    {"trailing",5/* UIControlContentHorizontalAlignmentTrailing*/},
};

@implementation UIControl (Flex)

FLEXSET(enabled)
{
    self.enabled = String2BOOL(sValue);
}

FLEXSET(selected)
{
    self.selected = String2BOOL(sValue);
}

FLEXSET(highlighted)
{
    self.highlighted = String2BOOL(sValue);
}

FLEXSET(vertAlignment)
{
    UIControlContentVerticalAlignment align = NSString2Int(sValue,_vertAlign,sizeof(_vertAlign)/sizeof(NameValue));
    self.contentVerticalAlignment = align;
}

FLEXSET(horzAlignment)
{
    UIControlContentHorizontalAlignment align = NSString2Int(sValue,_horzAlign,sizeof(_horzAlign)/sizeof(NameValue));
    self.contentHorizontalAlignment = align;
}


@end
