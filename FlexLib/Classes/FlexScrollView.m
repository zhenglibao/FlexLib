//
//  FlexScrollView.m
//  Expecta
//
//  Created by zhenglibao on 2017/12/7.
//

#import "FlexScrollView.h"
#import "YogaKit/UIView+Yoga.h"

@interface FlexScrollView()
{
    UIView* _contentView;
}
@end


@implementation FlexScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contentView = [[UIView alloc]init];
        [_contentView configureLayoutWithBlock:^(YGLayout* layout)
         {
             layout.isEnabled = YES;
             layout.isIncludedInLayout = NO ;
         }];
        [super addSubview:_contentView];
        
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView*)object change:(NSDictionary *)change context:(void *)context
{
    CGRect rcOld = [[change objectForKey:@"old"]CGRectValue];
    CGRect rcNew = [[change objectForKey:@"new"]CGRectValue];
    
    if(!CGSizeEqualToSize(rcOld.size, rcNew.size)){
        [self setNeedsLayout];
    }
}
-(void)layoutSubviews
{
    CGRect rc = self.frame ;
    [_contentView configureLayoutWithBlock:^(YGLayout* layout){
        if(!self.horizontal)
            layout.width = YGPointValue(rc.size.width) ;
        else
            layout.width = YGPointValue(NAN);
        if(!self.vertical)
            layout.height = YGPointValue(rc.size.height) ;
        else
            layout.height = YGPointValue(NAN);
    }];
    
    YGDimensionFlexibility flex = 0 ;
    if(self.horizontal)
        flex |= YGDimensionFlexibilityFlexibleWidth ;
    if(self.vertical)
        flex |= YGDimensionFlexibilityFlexibleHeigth ;
    
    YGLayout* layout = _contentView.yoga;
    layout.isIncludedInLayout = YES;
    [layout applyLayoutPreservingOrigin:NO dimensionFlexibility:flex];
    layout.isIncludedInLayout = NO;
    self.contentSize = _contentView.frame.size ;
}

-(void)addSubview:(UIView *)view
{
    [_contentView addSubview:view];
}

-(void)setHorzScroll:(NSString*)s
{
    BOOL b = [s compare:@"true" options:NSDiacriticInsensitiveSearch]==NSOrderedSame;
    self.horizontal = b ;
}
-(void)setVertScroll:(NSString*)s
{
    BOOL b = [s compare:@"true" options:NSDiacriticInsensitiveSearch]==NSOrderedSame;
    self.vertical = b ;
}
@end
