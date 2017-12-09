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
-(instancetype)initWithFlex:(NSString*)flexName
            reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if( self != nil){
        _flexRootView = [FlexRootView loadWithNodeFile:flexName Owner:self];
        _flexRootView.flexibleHeight = YES ;
        [self.contentView addSubview:_flexRootView];

        if(!_bObserved){
            [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            _bObserved = YES;
        }
    }
    return self ;
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
    [_flexRootView setNeedsLayout];
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
