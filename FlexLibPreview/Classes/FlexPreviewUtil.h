/**
* Copyright (c) 2017-present, zhenglibao, Inc.
* email: 798393829@qq.com
* All rights reserved.
*
* This source code is licensed under the MIT-style license found in the
* LICENSE file in the root directory of this source tree.
*/

#ifndef FlexPreviewUtil_h
#define FlexPreviewUtil_h

#define FlexPreviewLocalizeString(key)   \
[FlexPreviewBundle() localizedStringForKey:key value:@"" table:nil]


NSBundle* FlexPreviewBundle(void);

#endif /* FlexPreviewUtil_h */
