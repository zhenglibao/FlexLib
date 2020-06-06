/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "TestLoginVC.h"

@interface TestLoginVC ()
{
    UIScrollView* scroll;
    UIView* close;
}

@end

@implementation TestLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Touch Demo";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)tapCloseAction
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)tapTouchAction
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                    message:@"You pressed"
//                                                   delegate:nil
//                                          cancelButtonTitle:@"Cancel"
//                                          otherButtonTitles:@"OK",nil];
//    
//    [alert show];
}

@end
