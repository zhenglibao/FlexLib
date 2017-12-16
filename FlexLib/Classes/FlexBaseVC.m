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

static void* gObserverFrame         = (void*)1;

@interface FlexBaseVC ()<UITextFieldDelegate,UITextViewDelegate>
{
    NSString* _flexName ;
    FlexRootView* _flexRootView ;
    float _keyboardHeight;
    
    BOOL _bUpdating;        //正在热更新
    
    UIToolbar* _tbKeyboard;
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    tap.delaysTouchesBegan = NO;
    [self.view addGestureRecognizer:tap];
}
-(void)hideKeyboard
{
    [[self.view findFirstResponder]resignFirstResponder];
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
    
    NSLog(@"Flexbox: reloading layout file %@ ...",_flexName);
    
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
        return UIEdgeInsetsMake(height, 0, _keyboardHeight>0?0:34, 0);
    }
    return UIEdgeInsetsMake(height, 44, _keyboardHeight>0?0:21, 44);
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
    UIScrollView* parent = [self scrollViewOfControl:view];
    
    if(parent !=nil ){
        UIScrollView* scrollView = (UIScrollView*)parent;
        CGRect rcView = view.frame;
        rcView = CGRectInset(rcView,0,-40);
        
        rcView = [scrollView convertRect:rcView fromView:view.superview];
        [scrollView scrollRectToVisible:rcView animated:bAnim];
    }
}
-(NSArray*)getKeyboardItemsStrings
{
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    if([languageName rangeOfString:@"zh-"].length>0){
        return @[
             @"上一个",
             @"下一个",
             @"发送"
             ];
    }
    return @[
             @"Prev",@"Next",@"Send"
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
            UIReturnKeyType keytype = (i+1==views.count)?UIReturnKeyDefault:UIReturnKeyNext;
            UITextView* tv = (UITextView*)view;
            tv.delegate = self;
            tv.returnKeyType = keytype;
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

        _tbKeyboard.items = @[prev,next,space,submit];
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
    rcCaret = CGRectInset(rcCaret, 0, -20);
    [scrollView scrollRectToVisible:rcCaret animated:YES];
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
-(void)submitForm
{
    NSLog(@"Flexbox: submitForm called");
}
@end
