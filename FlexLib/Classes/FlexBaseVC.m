/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "FlexBaseVC.h"
#import "FlexRootView.h"
#import "YogaKit/UIView+Yoga.h"
#import "FlexUtils.h"

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
-(FlexRootView*)rootView
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
    _flexRootView.portraitSafeArea = [self getSafeArea:YES];
    _flexRootView.landscapeSafeArea = [self getSafeArea:NO];
    
    self.view = [[UIView alloc]initWithFrame:CGRectZero];
    self.view.backgroundColor=_flexRootView.topSubView.backgroundColor;
    [self.view addSubview:contentView];
}
- (UIEdgeInsets)getSafeArea:(BOOL)portrait
{
    if(!IsIphoneX())
    {
        CGFloat height = 0;
        if(self.navigationController!=nil)
        {
            height += portrait ? 44 : 32 ;
        }
        
        if(portrait)
        {
            height += 20 ;
        }
        return UIEdgeInsetsMake(height, 0, 0, 0);
    }
    
    CGFloat height = 0;
    if(self.navigationController!=nil)
    {
        height += portrait ? 44 : 32 ;
    }
    if(portrait){
        height += 44 ;
        return UIEdgeInsetsMake(height, 0, 34, 0);
    }
    return UIEdgeInsetsMake(height, 44, 21, 44);
}

-(void)layoutFlexRootViews{
    for(UIView* subview in self.view.subviews){
        if([subview isKindOfClass:[FlexRootView class]]){
            [subview setNeedsLayout];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [self layoutFlexRootViews];
}
@end
