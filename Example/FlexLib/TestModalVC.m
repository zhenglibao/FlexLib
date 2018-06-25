/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "TestModalVC.h"

@interface TestModalVC ()
{
    FlexModalView* modal;
}

@end

@implementation TestModalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Modal Demo";
}

- (void)dealloc
{
    NSLog(@"TestModalVC dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapCloseAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tapModalTop
{
    [modal setViewAttr:@"position" Value:@"top"];
    [modal showModalInView:self.view Anim:YES];
}
-(void)tapModalCenter
{
    [modal setViewAttr:@"position" Value:@"center"];
    [modal showModalInView:self.view Anim:YES];
}
-(void)tapModalBottom
{
    [modal setViewAttr:@"position" Value:@"bottom"];
    [modal showModalInView:self.view Anim:YES];
}
-(void)closeModal
{
    [modal hideModal:YES];
}
@end
