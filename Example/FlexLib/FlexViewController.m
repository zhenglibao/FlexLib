//
//  FlexViewController.m
//  FlexLib
//
//  Created by zhenglibao on 12/06/2017.
//  Copyright (c) 2017 zhenglibao. All rights reserved.
//

#import "FlexViewController.h"
#import "TestVC.h"
#import "TestTableVC.h"
#import "TestScrollVC.h"
#import "TestModalVC.h"

@interface FlexViewController ()

@end

@implementation FlexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTest:(id)sender {
    
    TestVC* vc=[[TestVC alloc]init];
    
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)onTestTable:(id)sender {
    TestTableVC* vc=[[TestTableVC alloc]init];
    
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)onTestScrollView:(id)sender {
    TestScrollVC* vc=[[TestScrollVC alloc]init];
    
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)onTestModalView:(id)sender {
    TestModalVC* vc=[[TestModalVC alloc]init];
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end
