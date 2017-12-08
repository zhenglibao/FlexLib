/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */


#import "FlexBaseVC.h"
#import "FlexRootView.h"
#import "YogaKit/UIView+Yoga.h"

@interface FlexBaseVC ()
{
    NSString* _flexName ;
    FlexRootView* _flexRootView ;
}

@end

@implementation FlexBaseVC

-(instancetype)initWithFlexName:(NSString*)flexName
{
    self = [super init];
    if(self){
        _flexName = flexName ;
    }
    return self;
}
-(NSString*)getFlexName
{
    return nil;
}
-(UIView*)rootView
{
    return _flexRootView;
}
-(void)loadView
{
    if(_flexName == nil){
        _flexName = [self getFlexName];
        if(_flexName == nil){
            _flexName = NSStringFromClass([self class]);
        }
    }
    FlexRootView* contentView = [FlexRootView loadWithNodeFile:_flexName Owner:self] ;
    _flexRootView = contentView ;
    
    self.view = [[UIView alloc]initWithFrame:CGRectZero];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:contentView];
}

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

@end
