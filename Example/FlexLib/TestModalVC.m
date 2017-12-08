//
//  TestModalVC.m
//  FlexLib_Example
//
//  Created by zhenglibao on 2017/12/8.
//  Copyright © 2017年 zhenglibao. All rights reserved.
//

#import "TestModalVC.h"

@interface TestModalVC ()
{
    FlexModalView* modal;
}

@end

@implementation TestModalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapCloseAction
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)tapModal
{
    [modal showModalInView:self.view];
}
-(void)closeModal
{
    [modal hideModal];
}
@end
