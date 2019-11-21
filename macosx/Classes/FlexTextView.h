/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <AppKit/AppKit.h>

@class UILabel;

//
@interface FlexTextView : NSTextView

@property(nonatomic,readonly) UILabel *placeholdLabel;
@property(nonatomic,strong) NSString *placeholder;
@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) NSColor *placeholderColor;
@property(nonatomic,nonnull,strong)  NSAttributedString *attributePlaceholder;
@property(nonatomic,assign) CGPoint location;

- (void)updatePlaceholder;

@end
