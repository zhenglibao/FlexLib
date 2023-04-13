/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "UISearchBar+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"


static NameValue _gstyle[] =
{
    {"default", UIBarStyleDefault},
    {"black", UIBarStyleBlack},
    {"opaque", UIBarStyleBlackOpaque},
    {"translucent", UIBarStyleBlackTranslucent},
};

@implementation UISearchBar (Flex)

FLEXSET(barStyle)
{
    self.barStyle = FLEXSTR2INT(_gstyle);
}

FLEXSET(text)
{
    self.text = sValue ;
}

FLEXSET(prompt)
{
    self.prompt = sValue ;
}

FLEXSET(placeholder)
{
    self.placeholder = sValue ;
}

FLEXSET(bookMarkBtn)
{
    self.showsBookmarkButton = String2BOOL(sValue) ;
}

FLEXSET(cancelBtn)
{
    self.showsCancelButton = String2BOOL(sValue) ;
}

FLEXSET(resultBtn)
{
    self.showsSearchResultsButton = String2BOOL(sValue) ;
}

FLEXSET(resultBtnSelected)
{
    self.searchResultsButtonSelected = String2BOOL(sValue) ;
}
@end
