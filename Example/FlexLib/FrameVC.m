/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "FrameVC.h"

@interface FrameVC ()
@property(nonatomic,strong) FlexFrameView* frameView;
@end

@implementation FrameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FlexFrameView* view = [[FlexFrameView alloc]initWithFlex:@"FrameVC" Frame:CGRectZero Owner:self];
    self.frameView = view;
    self.view = view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}
- (void)dealloc
{
    NSLog(@"FrameVC dealloc");
}
@end
