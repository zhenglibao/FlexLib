//
//  FlexScrollView.m
//  Expecta
//
//  Created by zhenglibao on 2017/12/7.
//

#import "FlexScrollView.h"
#import "FlexRootView.h"
#import "ViewExt/UIView+Flex.h"
#import "YogaKit/UIView+Yoga.h"

@interface FlexScrollView()
{
    FlexRootView* _contentView;
}
@end


@implementation FlexScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contentView = [[FlexRootView alloc]init];
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
        [_contentView setNeedsLayout];
    }
}

-(void)subFrameChanged:(UIView*)subView
                  Rect:(CGRect)newFrame
{
    self.contentSize = newFrame.size ;
}

-(void)postCreate
{
#define COPYYGVALUE(prop)           \
if(from.prop.unit==YGUnitPoint||    \
    from.prop.unit==YGUnitPercent)  \
{                                   \
    to.prop = from.prop;            \
}                                   \
    
    //同步yoga属性
    YGLayout* from = self.yoga ;
    YGLayout* to = _contentView.yoga ;
    
    to.direction = from.direction ;
    to.flexDirection = from.flexDirection;
    to.justifyContent = from.justifyContent;
    to.alignItems = from.alignItems;
    to.alignSelf = from.alignSelf;
    to.flexWrap = from.flexWrap;
    to.overflow = from.overflow;
    to.display = from.display;
    
    COPYYGVALUE(paddingLeft)
    COPYYGVALUE(paddingTop)
    COPYYGVALUE(paddingRight)
    COPYYGVALUE(paddingBottom)
    COPYYGVALUE(paddingStart)
    COPYYGVALUE(paddingEnd)
    COPYYGVALUE(paddingHorizontal)
    COPYYGVALUE(paddingVertical)
    COPYYGVALUE(padding)
    
    to.aspectRatio = from.aspectRatio;
}
-(void)addSubview:(UIView *)view
{
    [_contentView addSubview:view];
    [_contentView registSubView:view];
}

FLEXSET(horzScroll)
{
    BOOL b = [sValue compare:@"true" options:NSDiacriticInsensitiveSearch]==NSOrderedSame;
    self.horizontal = b ;
    
    _contentView.flexibleWidth = b;
}
FLEXSET(vertScroll)
{
    BOOL b = [sValue compare:@"true" options:NSDiacriticInsensitiveSearch]==NSOrderedSame;
    self.vertical = b ;
    
    _contentView.flexibleHeight = b;
}
@end
