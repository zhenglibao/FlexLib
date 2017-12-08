/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */


#import "TestVC.h"

@interface TestVC ()
{
    UIView* add;
    UIView* batch;
    UIView* close;
}

@end

@implementation TestVC

-(NSString*)getFlexName{
    return @"test";
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)tapAddAction{
    
}
-(void)tapBatchAction
{
    
}

-(void)tapCloseAction
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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


+(void)Test{
    
}
@end
