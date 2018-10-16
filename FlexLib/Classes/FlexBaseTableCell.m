/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "FlexBaseTableCell.h"
#import "FlexRootView.h"

static void* gObserverFrame         = &gObserverFrame;

@interface FlexBaseTableCell()
{
    FlexRootView* _flexRootView ;
    BOOL _bObserved;
}
@end

@implementation FlexBaseTableCell
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)internalInit:(NSString*)flexName
{
    if(_flexRootView!=nil)
        return;
    
    __weak FlexBaseTableCell* weakSelf = self;
    
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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    
    if( self != nil){
        [self internalInit:nil];
    }
    return self;
}

-(instancetype)initWithFlex:(NSString*)flexName
            reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
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
