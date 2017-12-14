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
    
    BOOL _bUpdating;        //正在热更新
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
-(void)onLayoutReload
{
    
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
    
    if (@available(iOS 11.0, *))
    {
    }else{
        // for <ios11, it's necessary
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)resetByFlexData:(NSData*)flexData
{
    _bUpdating = NO ;
    if(flexData == nil){
        return;
    }
    
    FlexRootView* contentView = [FlexRootView loadWithNodeData:flexData Owner:self] ;
    if(contentView != nil){
        // 移除旧的
        [_flexRootView removeFromSuperview];
        _flexRootView = nil;
    }
    
    _flexRootView = contentView ;
    _flexRootView.portraitSafeArea = [self getSafeArea:YES];
    _flexRootView.landscapeSafeArea = [self getSafeArea:NO];
    
 self.view.backgroundColor=_flexRootView.topSubView.backgroundColor;
    [self.view addSubview:contentView];
    [self onLayoutReload];
}
- (void)reloadFlexView
{
    if(_bUpdating)
        return;
    
    _bUpdating = YES;
    
    __weak FlexBaseVC* weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue,^{
        NSError* error = nil;
        NSData* flexData = FlexFetchLayoutFile(_flexName, &error);
        dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf resetByFlexData:flexData];
        });
        if(error != nil){
            NSLog(@"Flexbox: reload flex data error: %@",error);
        }
    });
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


- (NSArray<UIKeyCommand *> *)keyCommands
{
#ifdef DEBUG
    return @[
             // Reload
             [UIKeyCommand keyCommandWithInput:@"r"
                                 modifierFlags:UIKeyModifierCommand
                                        action:@selector(reloadFlexView)],
             ];
#else
    return @[];
#endif
}

@end
