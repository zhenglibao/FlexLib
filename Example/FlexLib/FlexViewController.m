/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "FlexViewController.h"
#import "TestVC.h"
#import "TestTableVC.h"
#import "TestScrollVC.h"
#import "TestModalVC.h"
#import "TestLoginVC.h"

@interface FlexViewController ()
{
    FlexScrollView* _scroll;
    UILabel* _label;
}
@end
@implementation FlexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"FlexLib Demo";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onTest:(id)sender {
    TestVC* vc=[[TestVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)onTestTable:(id)sender {
    TestTableVC* vc=[[TestTableVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)onTestScrollView:(id)sender {
    TestScrollVC* vc=[[TestScrollVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)onTestModalView:(id)sender {
    TestModalVC* vc=[[TestModalVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)onTestLoginView:(id)sender {
    TestLoginVC* vc=[[TestLoginVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
