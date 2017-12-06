//
//  TestVC.m
//  FlexLayout_Example
//
//  Created by zhenglibao on 2017/12/4.
//  Copyright © 2017年 zhenglibao@haizhi.com. All rights reserved.
//

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
