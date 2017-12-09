/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */


#import "FlexModalView.h"
#import "FlexRootView.h"
#import "YogaKit/UIView+Yoga.h"

@interface FlexModalView()
{
    FlexRootView* _root;
    FlexRootView* _ownerRootView;
}
@end

@implementation FlexModalView
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)setOwnerRootView:(FlexRootView*)rootView
{
    _ownerRootView = rootView;
}
-(void)showModalInView:(UIView*)view
{
    if(_root==nil){
        _root = [[FlexRootView alloc]init];
        _root.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _root.portraitSafeArea = _ownerRootView.portraitSafeArea;
        _root.landscapeSafeArea = _ownerRootView.landscapeSafeArea;
        [_root addSubview:self];
    }
    
    [self hideModal];
    [view addSubview:_root];
}
-(void)hideModal
{
    if(_root==nil||_root.superview==nil)
        return;
    [_root removeFromSuperview];
}
@end
