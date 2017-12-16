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

static void* gObserverFrame         = (void*)1;

@interface FlexBaseVC ()
{
    NSString* _flexName ;
    FlexRootView* _flexRootView ;
    float _keyboardHeight;
    
    BOOL _bUpdating;        //正在热更新
}

@end

@implementation FlexBaseVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _avoidKeyboard = YES;
        _keyboardHeight = 0;
    }
    return self;
}
-(instancetype)initWithFlexName:(NSString*)flexName
{
    self = [self init];
    if(self){
        _flexName = flexName ;
    }
    return self;
}
- (void)dealloc
{
    [self.view removeObserver:self forKeyPath:@"frame"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // register keyboard
    
    NSNotificationCenter* nsc = [NSNotificationCenter defaultCenter];
    [nsc addObserver:self
            selector:@selector(keyboardDidShow:)
                name:UIKeyboardDidShowNotification
              object:nil];
    
    [nsc addObserver:self
            selector:@selector(keyboardWillHide:)
                name:UIKeyboardWillHideNotification
              object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // remove keyboard notification
    
    NSNotificationCenter* nsc = [NSNotificationCenter defaultCenter];
    
    [nsc removeObserver:self
                   name:UIKeyboardDidShowNotification
                 object:nil];
    
    [nsc removeObserver:self
                   name:UIKeyboardWillHideNotification
                 object:nil];
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
    
    self.view = [[UIView alloc]initWithFrame:CGRectZero];
    self.view.backgroundColor=_flexRootView.topSubView.backgroundColor;
    [self.view addSubview:contentView];
    
    if (@available(iOS 11.0, *))
    {
    }else{
        // for <ios11, it's necessary
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // added
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:gObserverFrame];
    [self layoutFlexRootViews];
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
 self.view.backgroundColor=_flexRootView.topSubView.backgroundColor;
    [self.view addSubview:contentView];
    [self layoutFlexRootViews];
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
            height += self.navigationController.navigationBar.frame.size.height ;
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
        height += self.navigationController.navigationBar.frame.size.height ;
    }
    if(portrait){
        height += 44 ;
        return UIEdgeInsetsMake(height, 0, 34, 0);
    }
    return UIEdgeInsetsMake(height, 44, 21, 44);
}

-(void)layoutFlexRootViews{
    BOOL isPortrait = IsPortrait();
    UIEdgeInsets safeArea = [self getSafeArea:isPortrait];
    safeArea.bottom += _keyboardHeight ;
    
    for(UIView* subview in self.view.subviews){
        if([subview isKindOfClass:[FlexRootView class]]){
            FlexRootView* rootView = (FlexRootView*)subview;
            rootView.safeArea = safeArea;
            [subview setNeedsLayout];
        }
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView*)object change:(NSDictionary *)change context:(void *)context
{
    if(context == gObserverFrame){
        [self layoutFlexRootViews];
    }
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

#pragma mark - keybaord

-(void)keyboardDidShow:(NSNotification*) notification {
    
    if(self.avoidKeyboard){
        _keyboardHeight = [self getKeyboardHeight:notification];
        [self layoutFlexRootViews];
    }
}

-(void)keyboardWillHide:(NSNotification*) notification {
    if(_keyboardHeight>0){
        _keyboardHeight = 0;
        [self layoutFlexRootViews];
    }
}
-(float) getKeyboardHeight:(NSNotification*) notification
{
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIView *mainView = window.rootViewController.view;
    CGRect rcFrameConverted = [mainView convertRect:keyboardFrame fromView:window];
    
    return rcFrameConverted.size.height;
}

@end
