//
//  FlexModalView.m
//  Expecta
//
//  Created by zhenglibao on 2017/12/8.
//

#import "FlexModalView.h"
#import "FlexRootView.h"
#import "YogaKit/UIView+Yoga.h"

@interface FlexModalView()
{
    FlexRootView* _root;
}
@end

@implementation FlexModalView
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)showModalInView:(UIView*)view
{
    if(_root==nil){
        _root = [[FlexRootView alloc]init];
        _root.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _root.yoga.marginTop=YGPointValue(20);
        [_root addSubview:self];
    }
    
    [self hideModal];
    [view addSubview:_root];
}
-(void)hideModal
{
    if(_root==nil||_root.superview==nil)
        return;
    [_root removeFromSuperview];
}
@end
