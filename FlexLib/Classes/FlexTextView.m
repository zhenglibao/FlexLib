/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "FlexTextView.h"
#import "FlexRootView.h"
#import "YogaKit/UIView+Yoga.h"

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

- (void)textDidChange:(NSNotification *)notification
{
    CGRect rcSelf = self.frame;
    CGSize szLimit = CGSizeMake(rcSelf.size.width, FLT_MAX);
    CGSize sz = [self sizeThatFits:szLimit];
    
    CGFloat diff = ceil(sz.height)-rcSelf.size.height;
    
    if(diff>1){
        YGValue maxHeight = self.yoga.maxHeight;
        if(maxHeight.unit == YGUnitPoint &&
           rcSelf.size.height+0.5f >= maxHeight.value){
        }else{
            [self markDirty];
        }
    }else if(diff<-1){
        YGValue minHeight = self.yoga.minHeight;
        if(minHeight.unit == YGUnitPoint &&
           rcSelf.size.height<= minHeight.value+0.5f){
        }else{
            [self markDirty];
        }
    }
}
@end
