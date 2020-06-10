/**
* Copyright (c) 2017-present, zhenglibao, Inc.
* email: 798393829@qq.com
* All rights reserved.
*
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*/

#import <Foundation/Foundation.h>
#import "FlexHttpVC.h"

NSBundle* FlexPreviewBundle(void)
{
    NSString* flexPath = [[NSBundle bundleForClass:[FlexHttpVC class]]resourcePath];
    flexPath = [flexPath stringByAppendingPathComponent:@"FlexLibPreview.bundle"];
    return [NSBundle bundleWithPath:flexPath];
}

