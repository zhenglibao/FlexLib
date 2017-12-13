/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "TestVC.h"

@interface TestVC ()
{
    UIView* add;
    UIView* batch;
    
    UILabel* testLabel;
}

@end

@implementation TestVC

-(NSString*)getFlexName{
    return @"test";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"ViewController";
}

-(void)tapAddAction{
    
}
-(void)tapBatchAction
{
    
}

-(void)tapCloseAction
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)onTestLabel
{
   testLabel.text = [testLabel.text stringByAppendingString:testLabel.text];
}

@end
