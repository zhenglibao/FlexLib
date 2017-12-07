//
//  TestScrollVC.m
//  FlexLib_Example
//
//  Created by zhenglibao on 2017/12/7.
//  Copyright © 2017年 zhenglibao. All rights reserved.
//

#import "TestScrollVC.h"

@interface TestScrollVC ()
{
    UIScrollView* scroll;
    UIView* close;
}

@end

@implementation TestScrollVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
