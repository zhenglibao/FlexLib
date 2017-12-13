/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "TestScrollVC.h"

@interface TestScrollVC ()
{
    UIScrollView* scroll;
    UIView* close;
    
    UILabel* multilabel;
}

@end

@implementation TestScrollVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Scroll Demo";
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
}
-(void)tapShow
{
    multilabel.hidden = !multilabel.isHidden;
    
    [self.rootView layoutAnimation:0.8];
}

@end
