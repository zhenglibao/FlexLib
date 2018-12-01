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
#import "FlexScrollView.h"
#import "FlexSetPreviewVC.h"
#import "FlexLayoutViewerVC.h"
#import "FlexHttpVC.h"
#import "FlexNode.h"

static void* gObserverFrame = &gObserverFrame;

@interface FlexBaseVC ()
{
    NSString* _flexName ;
    FlexRootView* _flexRootView ;
    
    BOOL _bUpdating;        //正在热更新
    
    UIToolbar* _tbKeyboard;
    float _keyboardHeight;
    double _lastKeyTime;
    BOOL   _keyboardDirty;
    
    BOOL _navibarTranslucent;
}

@end

@implementation FlexBaseVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _avoidKeyboard = YES;
        _avoidiPhoneXBottom = YES;
        _keyboardHeight = 0;
        _keepNavbarTranslucent = YES;
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
    
    if(self.keepNavbarTranslucent){
        UINavigationBar* navibar = self.navigationController.navigationBar;
        _navibarTranslucent = navibar.translucent;
        navibar.translucent = YES;
    }
    
    // register keyboard observer
    
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
    
    if(self.keepNavbarTranslucent){
        UINavigationBar* navibar = self.navigationController.navigationBar;
        navibar.translucent = _navibarTranslucent;
    }
    
    // remove keyboard notification
    NSNotificationCenter* nsc = [NSNotificationCenter defaultCenter];
    
    [nsc removeObserver:self
                   name:UIKeyboardDidShowNotification
                 object:nil];
    
    [nsc removeObserver:self
                   name:UIKeyboardWillHideNotification
                 object:nil];
}
-(void)hideKeyboard
{
    [[self.view findFirstResponder]resignFirstResponder];
}

-(NSString*)getFlexName
{
    return nil;
}

-(UIView*)findByName:(NSString*)viewName
{
    return [self.view findByName:viewName];
}

#pragma mark - override

-(void)onLayoutReload
{
    
}
-(void)onRootDidLayout
{
    if(_keyboardHeight>0){
        __weak FlexBaseVC* weakSelf = self;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));

        dispatch_after(delayTime,dispatch_get_main_queue(),^{
            UIView* firstResponder = [weakSelf.view findFirstResponder];
            if(firstResponder != nil)
                [weakSelf scrollViewToVisible:firstResponder animated:YES];
        });
    }
}
-(void)submitForm
{
    NSLog(@"Flexbox: submitForm called");
}
#pragma mark - root view

-(float)keyboardHeight
{
    return _keyboardHeight;
}
-(FlexRootView*)rootView
{
    return _flexRootView;
}

-(void)postSetRootView
{
    if(_flexRootView == nil)
        return;
    
    __weak FlexBaseVC* weakSelf = self;
    _flexRootView.onDidLayout = ^{
        [weakSelf onRootDidLayout];
    };
    self.view.backgroundColor=_flexRootView.topSubView.backgroundColor;
    [self.view addSubview:_flexRootView];
    [self layoutFlexRootViews];
}
-(void)loadView
{
    if (@available(iOS 11.0, *))
    {
    }else{
        // for <ios11, it's necessary
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if(_flexName == nil){
        _flexName = [self getFlexName];
        if(_flexName == nil){
            _flexName = NSStringFromClass([self class]);
        }
    }
    FlexRootView* contentView = [FlexRootView loadWithNodeFile:_flexName Owner:self] ;
    _flexRootView = contentView ;
    
    self.view = [[UIView alloc]initWithFrame:CGRectZero];
   
    // observe self.view.frame change
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:gObserverFrame];
    
    [self postSetRootView];
}
- (void)resetByFlexData:(NSData*)flexData
{
    _bUpdating = NO ;
    if(flexData == nil){
        NSLog(@"Flexbox: Reload Error.");
        return;
    }
    
    FlexRootView* contentView = [FlexRootView loadWithNodeData:flexData Owner:self] ;
    if(contentView != nil){
        // 移除旧的
        [_flexRootView removeFromSuperview];
        _flexRootView = nil;
    }
    
    _flexRootView = contentView ;
 
    [self postSetRootView];
    [self onLayoutReload];
    
    NSLog(@"Flexbox: Reload Successful.");
}
- (void)reloadFlexView
{
    if(_bUpdating)
        return;
    
    _bUpdating = YES;
    
    NSString* flexname = _flexName.lastPathComponent ;
    
    NSLog(@"Flexbox: reloading layout file %@ ...",flexname);
    
    __weak FlexBaseVC* weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue,^{
        NSError* error = nil;
        NSData* flexData = FlexFetchLayoutFile(flexname, &error);
        dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf resetByFlexData:flexData];
        });
        if(error != nil){
            NSLog(@"Flexbox: reload flex data error: %@",error);
        }
    });
}
-(void)previewSetting{
    [FlexSetPreviewVC presentInVC:self];
}
-(void)viewLayouts
{
    [FlexLayoutViewerVC presentInVC:self];
}
-(void)viewOnlineResources
{
    [FlexHttpVC presentInVC:self];
}
-(CGFloat)getStatusBarHeight:(BOOL)portrait
{
    if(IS_IPHONE){
        return portrait?20:0;
    }
    return 20;
}
-(CGFloat)getNavibarHeight
{
    if(self.navigationController!=nil && !self.navigationController.navigationBar.hidden)
    {
        return self.navigationController.navigationBar.frame.size.height ;
    }
    return 0;
}
- (UIEdgeInsets)getSafeArea:(BOOL)portrait
{
    if(!IsIphoneX())
    {
        CGFloat height = [self getStatusBarHeight:portrait] ;
        
        height += [self getNavibarHeight] ;
        
        return UIEdgeInsetsMake(height, 0, 0, 0);
    }
    
    CGFloat height = [self getNavibarHeight];
    CGFloat bottom = portrait ? 34 : 21 ;
    
    if( _keyboardHeight > 0 || (!self.avoidiPhoneXBottom) ){
        bottom = 0;
    }
    
    if(portrait){
        height += 44 ;
        return UIEdgeInsetsMake(height, 0, bottom, 0);
    }
    return UIEdgeInsetsMake(height, 44, bottom, 44);
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
        CGSize szNew = [[change objectForKey:@"new"]CGRectValue].size;
        CGSize szOld = [[change objectForKey:@"old"]CGRectValue].size;
        if(!CGSizeEqualToSize(szNew, szOld))
            [self layoutFlexRootViews];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
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
             // Setting
             [UIKeyCommand keyCommandWithInput:@"d"
                                 modifierFlags:UIKeyModifierCommand
                                        action:@selector(previewSetting)],
             
            // view layouts
            [UIKeyCommand keyCommandWithInput:@"v"
                                modifierFlags:UIKeyModifierControl
                                       action:@selector(viewLayouts)],
             
             // view online resources
             [UIKeyCommand keyCommandWithInput:@"e"
                                 modifierFlags:UIKeyModifierControl
                                        action:@selector(viewOnlineResources)],
            ];
#else
    return @[];
#endif
}

#pragma mark - keybaord
-(void)delayLayoutByKeyboard:(BOOL)bFromSelf
{
    const double tmSep = 0.1;
    if(bFromSelf){
        if(_keyboardDirty){
            double now = GetAccurateSecondsSince1970();
            if(now-_lastKeyTime>=tmSep){
                _keyboardDirty = NO;
                [self layoutFlexRootViews];
            }
        }
    }else{
        __weak FlexBaseVC* weakSelf = self;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(tmSep* NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [weakSelf delayLayoutByKeyboard:YES];
        });
    }
}
-(void)keyboardDidShow:(NSNotification*) notification {
    if(self.avoidKeyboard){
        _keyboardDirty = YES;
        _lastKeyTime = GetAccurateSecondsSince1970();
        _keyboardHeight = [self getKeyboardHeight:notification];
        [self delayLayoutByKeyboard:NO];
    }
}

-(void)keyboardWillHide:(NSNotification*) notification {
    if(_keyboardHeight>0){
        _keyboardDirty = YES;
        _lastKeyTime = GetAccurateSecondsSince1970();
        _keyboardHeight = 0;
        [self delayLayoutByKeyboard:NO];
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
-(UIScrollView*)scrollViewOfControl:(UIView*)view
{
    UIView* parent = view.superview;
    while (parent!=nil && ![parent isKindOfClass:[UIScrollView class]]) {
        parent = parent.superview;
    }
    return (UIScrollView*)parent;
}
-(void)scrollViewToVisible:(UIView*)view
                  animated:(BOOL)bAnim
{
    UIScrollView* scrollView = [self scrollViewOfControl:view];
    
    if(scrollView == nil )
        return;
    
    CGRect rcVisible = [scrollView convertRect:scrollView.frame fromView:scrollView.superview];
    CGRect rcView = view.frame;
    rcView = [scrollView convertRect:rcView fromView:view.superview];
    
    CGFloat dy = rcVisible.size.height-rcView.size.height;
    if(dy > 80){
        rcView = CGRectInset(rcView, 0, -40);
    }else{
        rcView = CGRectInset(rcView, 0, -dy/2.0);
    }
    
    [scrollView scrollRectToVisible:rcView animated:bAnim];
}
-(NSArray*)getKeyboardItemsStrings
{
    return @[
             FlexLocalizeString(@"Prev"),
             FlexLocalizeString(@"Next"),
             FlexLocalizeString(@"Send"),
             FlexLocalizeString(@"Finish"),
             ];
}

-(void)prepareInputs
{
    // 设置所有inputview
    NSArray<UIView*>* views = [self.view findAllInputs];
    
    for (NSUInteger i=0;i<views.count;i++) {
        UIView* view = [views objectAtIndex:i];
        if([view isKindOfClass:[UITextField class]])
        {
            UIReturnKeyType keytype = (i+1==views.count)?UIReturnKeySend:UIReturnKeyNext;
            UITextField* tf = (UITextField*)view;
            tf.delegate = self;
            tf.returnKeyType = keytype;
        }else if([view isKindOfClass:[UITextView class]])
        {
            UITextView* tv = (UITextView*)view;
            tv.delegate = self;
            tv.returnKeyType = UIReturnKeyDefault;
        }
    }
    //
    if(_tbKeyboard == nil){
        NSArray* items = [self getKeyboardItemsStrings];
        
        _tbKeyboard = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        UIBarButtonItem* prev=[[UIBarButtonItem alloc]initWithTitle:items[0] style:UIBarButtonItemStylePlain target:self action:@selector(onPrevInput)];
        UIBarButtonItem* next=[[UIBarButtonItem alloc]initWithTitle:items[1] style:UIBarButtonItemStylePlain target:self action:@selector(onNextInput)];
        UIBarButtonItem* space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

        UIBarButtonItem* submit=[[UIBarButtonItem alloc]initWithTitle:items[2] style:UIBarButtonItemStylePlain target:self action:@selector(onSubmitForm)];

        UIBarButtonItem* finish=[[UIBarButtonItem alloc]initWithTitle:items[3] style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];

        _tbKeyboard.items = @[prev,next,space,submit,finish];
    }
}
-(void)onPrevInput{
    NSArray* all = [self.view findAllInputs];
    if(all.count==0)
        return;
    
    UIView* current = [self.view findFirstResponder];
    
    NSUInteger index = [all indexOfObject:current];
    if( index!=NSNotFound ){
        if(index>0){
            [all[index-1] becomeFirstResponder];
            [self scrollViewToVisible:all[index-1]animated:YES];
        }
    }else{
        [all[0]becomeFirstResponder];
    }
}
-(void)onNextInput{
    NSArray* all = [self.view findAllInputs];
    if(all.count==0)
        return;
    
    UIView* current = [self.view findFirstResponder];
    
    NSUInteger index = [all indexOfObject:current];
    if( index!=NSNotFound ){
        if(index+1 < all.count){
            [all[index+1] becomeFirstResponder];
            [self scrollViewToVisible:all[index+1]animated:YES];
        }
    }else{
        [all[0]becomeFirstResponder];
    }
}
-(void)onSubmitForm{
    [self submitForm];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = _tbKeyboard;
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.inputAccessoryView = _tbKeyboard;
    return YES;
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    UIScrollView* scrollView = [self scrollViewOfControl:textView];
    
    if(scrollView == nil)
        return;
    
    CGRect rcCaret = [textView caretRectForPosition:textView.selectedTextRange.end];
    rcCaret = [scrollView convertRect:rcCaret fromView:textView];

    CGRect rcVisible = [scrollView convertRect:scrollView.frame fromView:scrollView.superview];
    
    if(!CGRectContainsRect(rcVisible, rcCaret))
    {
        CGFloat dy = rcVisible.size.height-rcCaret.size.height;
        if(dy > 40){
            rcCaret = CGRectInset(rcCaret, 0, -20);
        }else{
            rcCaret = CGRectInset(rcCaret, 0, -dy/2.0);
        }
        
        [scrollView scrollRectToVisible:rcCaret animated:YES];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSArray* all = [self.view findAllInputs];
    if(all.count>0){
        NSUInteger index = [all indexOfObject:textField];
        
        if( index!=NSNotFound ){
            if(index+1 < all.count){
                [all[index+1] becomeFirstResponder];
                [self scrollViewToVisible:all[index+1]animated:YES];
            }else{
                [self submitForm];
            }
        }else{
            [self submitForm];
        }
    }
    return NO;
}

@end
