/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "UITabBar+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"


static NameValue _gPosition[] =
{
    {"auto",UITabBarItemPositioningAutomatic},
    {"fill",UITabBarItemPositioningFill},
    {"center",UITabBarItemPositioningCentered},
};

static NameValue _gStyle[] =
{
    {"default",UIBarStyleDefault},
    {"black",UIBarStyleBlack},
    {"opaque",UIBarStyleBlackOpaque},
    {"translucent",UIBarStyleBlackTranslucent},
};


@implementation UITabBar (Flex)

FLEXSET(tintColor)
{
    self.tintColor = colorFromString(sValue,owner);
}

FLEXSET(barTintColor)
{
    self.barTintColor = colorFromString(sValue,owner);
}

FLEXSET(unSelTintColor)
{
    if (@available(iOS 10.0, *)) {
        self.unselectedItemTintColor = colorFromString(sValue,owner);
    } else {
        // Fallback on earlier versions
    }
}

FLEXSET(itemPosition)
{
    self.itemPositioning = FLEXSTR2INT(_gPosition);
}

FLEXSET(itemSpacing)
{
    self.itemSpacing =  [sValue floatValue];
}

FLEXSET(itemWidth)
{
    self.itemWidth = [sValue floatValue];
}

FLEXSET(barStyle)
{
    self.barStyle = FLEXSTR2INT(_gStyle);
}

FLEXSET(translucent)
{
    self.translucent = String2BOOL(sValue);
}

@end
