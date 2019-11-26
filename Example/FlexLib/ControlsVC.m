/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "ControlsVC.h"

@interface TestIndicator : UIActivityIndicatorView

@end
@implementation TestIndicator

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

@end

@interface ControlsVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIActivityIndicatorView* _activityView;
    UIPickerView* _pickerView;
    UITabBar* _tabBar;
    UIToolbar* _toolbar;
    
    NSArray* _pickerDatas;
}

@end

@implementation ControlsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Controls";
    
    [self.view layoutIfNeeded];

    [_activityView startAnimating];
    
    _pickerDatas = @[@"aaaa",@"bbb",@"ccccc",@"ddddd",@"eeeee"];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerView reloadAllComponents];
    
    UITabBarItem * tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"人均" image:nil tag:1];
    UITabBarItem * tabBarItem3 = [[UITabBarItem alloc] initWithTitle:@"距离" image:nil tag:2];
    UITabBarItem * tabBarItem4 = [[UITabBarItem alloc] initWithTitle:@"好评" image:nil tag:3];
    NSArray *tabBarItemArray = [[NSArray alloc] initWithObjects: tabBarItem2, tabBarItem3, tabBarItem4,nil];
    [_tabBar setItems: tabBarItemArray];
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithTitle:@"左边" style:UIBarButtonItemStylePlain target:self action:@selector(onClick:)];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(onClick:)];
    NSArray* barButtonItems = [NSArray arrayWithObjects:leftItem,rightItem, nil];
    [_toolbar setItems:barButtonItems animated:YES];
}
-(void)onClick:(id)sender
{
    
}
-(UIView*)createView:(Class)cls
                Name:(NSString*)name
{
    if([@"_segment" compare:name]==0){
        NSArray* items=@[@"item1",@"item2",@"item3"];
        return [[UISegmentedControl alloc]initWithItems:items];
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickerDatas.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerDatas[row];
}

@end
