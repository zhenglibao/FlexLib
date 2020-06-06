//
//  FlexTableHeaderFooterView.m
//  DYLegalExamination
//
//  Created by Anssy on 2019/7/25.
//  Copyright © 2019 湖北安式软件有限公司. All rights reserved.
//

#import "FlexTableHeaderFooterView.h"
#import "FlexRootView.h"

static void* gObserverFrame         = &gObserverFrame;
@interface FlexTableHeaderFooterView ()
{
    FlexRootView* _flexRootView ;
    BOOL _bObserved;
}
@end

@implementation FlexTableHeaderFooterView


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)internalInit:(NSString*)flexName
{
    if(_flexRootView!=nil)
        return;
    
    __weak FlexTableHeaderFooterView* weakSelf = self;
    
    _flexRootView = [FlexRootView loadWithNodeFile:flexName Owner:self];
    _flexRootView.flexibleHeight = YES ;
    _flexRootView.onDidLayout = ^{
        [weakSelf onRootViewDidLayout];
    };
    [self.contentView addSubview:_flexRootView];
    
    if(!_bObserved){
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:gObserverFrame];
        _bObserved = YES;
    }
    
    [self onInit];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if( self != nil){
        [self internalInit:nil];
    }
    return self;
}

-(instancetype)initWithFlex:(NSString*)flexName
            reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if( self != nil){
        [self internalInit:flexName];
    }
    return self ;
}


- (void)onInit{
}
-(UITableView*)tableView
{
    UIView* view = [self superview];
    
    while (view && ![view isKindOfClass:[UITableView class]] ) {
        view = [view superview];
    }
    return (UITableView*)view;
}
- (FlexRootView *)rootView{
    return _flexRootView;
}
- (void)onRootViewDidLayout
{
    CGRect rcRootView = _flexRootView.frame ;
    if(!CGSizeEqualToSize(self.frame.size,rcRootView.size))
    {
        if(self.onContentSizeChanged != nil){
            self.onContentSizeChanged(rcRootView.size);
        }
    }
}

- (void)dealloc
{
    if(_bObserved){
        [self removeObserver:self forKeyPath:@"frame"];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView*)object change:(NSDictionary *)change context:(void *)context
{
    if(context == gObserverFrame){
        
        CGSize szNew = [[change objectForKey:@"new"]CGRectValue].size;
        CGSize szOld = [[change objectForKey:@"old"]CGRectValue].size;
        if(!CGSizeEqualToSize(szNew, szOld))
            [_flexRootView setNeedsLayout];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize
{
    return [self calculateSize:targetSize];
}
- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority
{
    return [self calculateSize:targetSize];
}
-(CGFloat)heightForWidth:(CGFloat)width
{
    CGSize szLimit = CGSizeMake(width, FLT_MAX);
    return [_flexRootView calculateSize:szLimit].height;
}
-(CGFloat)heightForWidth
{
    return [self heightForWidth:self.contentView.frame.size.width];
}
-(CGSize)calculateSize:(CGSize)szLimit
{
    return [_flexRootView calculateSize:szLimit];
}


@end
