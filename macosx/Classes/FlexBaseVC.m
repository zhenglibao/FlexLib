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
#import "YogaKit/NSView+Yoga.h"
#import "FlexUtils.h"
#import "FlexScrollView.h"
#import "FlexNode.h"

static void* gObserverFrame = &gObserverFrame;

/// 用于控制器的根视图
@interface FlexControllerView : NSView

@property(nonatomic,copy) void (^onSizeChanged)(void);

@end

@implementation FlexControllerView

- (void)setFrameSize:(NSSize)newSize
{
    NSSize oldSize = self.frame.size;
    
    [super setFrameSize:newSize];
    
    if (!CGSizeEqualToSize(oldSize, newSize)) {
        if(self.onSizeChanged){
            self.onSizeChanged();
        }
        
        for(NSView* subview in self.subviews)
        {
            if([subview isKindOfClass:[FlexRootView class]])
            {
                [subview setNeedsLayout:YES];
            }
        }
    }
}

@end

@interface FlexBaseVC ()
{
    NSString* _flexName ;
    FlexRootView* _flexRootView ;
    
    BOOL _bUpdating;        //正在热更新
}

@end

@implementation FlexBaseVC

- (instancetype)init
{
    self = [super init];
    if (self) {
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

-(void)hideKeyboard
{
    [[self.view findFirstResponder]resignFirstResponder];
}

-(NSString*)getFlexName
{
    return nil;
}

-(NSView*)findByName:(NSString*)viewName
{
    return [self.view findByName:viewName];
}

#pragma mark - override

-(void)onLayoutReload
{
    
}
-(void)onRootDidLayout
{
}

#pragma mark - root view

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
    self.view.layer.backgroundColor=_flexRootView.topSubView.layer.backgroundColor;
    [self.view addSubview:_flexRootView];
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
    
    self.view = [[FlexControllerView alloc]initWithFrame:CGRectZero];
    
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
   
}
-(void)viewLayouts
{
}
-(void)viewOnlineResources
{
}
- (NSEdgeInsets)getSafeArea:(BOOL)portrait
{
    return NSEdgeInsetsMake(0, 0, 0, 0);
}

@end
