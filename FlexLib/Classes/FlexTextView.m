/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "FlexTextView.h"

@implementation FlexTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self updateLayout];
}

- (CGSize)intrinsicContentSize
{
    CGRect textRect = [self.layoutManager usedRectForTextContainer:self.textContainer];
    CGFloat height = textRect.size.height + self.textContainerInset.top + self.textContainerInset.bottom;
    return CGSizeMake(UIViewNoIntrinsicMetric, height);
}

- (void)textDidChange:(NSNotification *)notification
{
    [self updateLayout];
}

- (void)updateLayout
{
    [self invalidateIntrinsicContentSize];
    [self layoutIfNeeded];
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
    [self updateLayout];
    [super scrollRectToVisible:rect animated:animated];
}
@end
