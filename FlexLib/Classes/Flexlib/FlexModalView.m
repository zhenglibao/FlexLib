/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "FlexModalView.h"
#import "FlexRootView.h"
#import "YogaKit/UIView+Yoga.h"
#import "ViewExt/UIView+Flex.h"
#import "FlexUtils.h"

typedef NS_ENUM(NSInteger, FlexModalPosition) {
    modalTop,
    modalCenter,
    modalBottom,
};

static NameValue _gModalPosition[] =
{
    {"top",modalTop},
    {"center",modalCenter},
    {"bottom",modalBottom},
};

@interface FlexModalView()
{
    __weak FlexRootView* _root;
    __weak FlexRootView* _ownerRootView;
    
    FlexModalPosition _position;
    BOOL _cancelable;
    BOOL _showInPosition;
    
    FlexRootView* _realRoot;
}
@property(nonatomic,assign) BOOL bLastHiding;
@end

@implementation FlexModalView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _realRoot = [[FlexRootView alloc]init];
        _root = _realRoot;
        _root.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapOutside)];
        tap.cancelsTouchesInView = NO;
        tap.delaysTouchesBegan = NO;
        [_root addGestureRecognizer:tap];
        
        tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapInside)];
        tap.cancelsTouchesInView = NO;
        tap.delaysTouchesBegan = NO;
        [self addGestureRecognizer:tap];
        
        _position = modalBottom;
        _cancelable = YES;
    }
    return self;
}
-(void)setOwnerRootView:(FlexRootView*)rootView
{
    _ownerRootView = rootView;
}
-(void)resetLayout
{
    YGLayout* layout = self.yoga;
    YGLayout* rootLayout = _root.yoga;
    layout.position = YGPositionTypeRelative;
    layout.top = YGPointValue(0);
    layout.left = YGPointValue(0);

    switch (_position) {
        case modalTop:
            rootLayout.justifyContent = YGJustifyFlexStart;
            break;
        case modalCenter:
            rootLayout.justifyContent = YGJustifyCenter;
            break;
        case modalBottom:
            rootLayout.justifyContent = YGJustifyFlexEnd;
            break;
        default:
            break;
    }
}
-(void)postCreate
{
    [self resetLayout];
}
-(void)onTapInside
{
}
-(void)onTapOutside
{
    if(_cancelable)
        [self hideModal:YES];
}
-(void)showModalInView:(UIView*)view Anim:(BOOL)anim
{
    [self hideModal:NO];
    
    self.bLastHiding = NO;
    
    _root.safeArea = _ownerRootView.safeArea;
    
    [self resetLayout];

    [view addSubview:_root];
    [_root addSubview:self];
    [_root markChildDirty:self];
    
    _realRoot = nil;
    
    if(anim)
        [self beginShowAnim:NO];
}
-(void)showModalInView:(UIView*)view Position:(CGPoint)topLeft Anim:(BOOL)anim
{
    [self hideModal:NO];
    
    self.bLastHiding = NO;
    
    _root.safeArea = _ownerRootView.safeArea;
    
    [self configureLayoutWithBlock:^(YGLayout* layout){
        layout.position = YGPositionTypeAbsolute;
        layout.left = YGPointValue(topLeft.x);
        layout.top = YGPointValue(topLeft.y);
    }];
    
    [view addSubview:_root];
    [_root addSubview:self];
    [_root markChildDirty:self];
    
    _realRoot = nil;
    
    if(anim)
        [self beginShowAnim:YES];
}

-(void)beginShowAnim:(BOOL)inPosition
{
    _showInPosition = inPosition;
    [_root layoutIfNeeded];
    [self enableFlexLayout:NO];
    
    CGRect rcFinal = self.frame;
    CGRect rcNew = rcFinal;
    
    if(inPosition){
        rcNew.size = CGSizeMake(0, 0);
    }else{
        switch (_position) {
            case modalTop:
                rcNew = CGRectOffset(rcFinal, 0, -rcFinal.size.height);
                break;
            case modalCenter:
                rcNew = CGRectOffset(rcFinal, rcFinal.size.width, 0);
                break;
            case modalBottom:
                rcNew = CGRectOffset(rcFinal, 0, rcFinal.size.height);
                break;
            default:
                break;
        }
    }
    self.frame = rcNew;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.2];
    self.frame = rcFinal;
    [UIView commitAnimations];
    [self enableFlexLayout:YES];
}
-(void)hideModal:(BOOL)anim
{
    if(_root==nil||_root.superview==nil)
        return;
    
    self.bLastHiding = YES;
    if(!anim)
    {
        _realRoot = _root;
        [self removeFromSuperview];
        [_root removeFromSuperview];
    }
    else
        [self beginHideAnim:_showInPosition];
}
-(void)beginHideAnim:(BOOL)inPosition
{
    [self enableFlexLayout:NO];
    
    CGRect rcFinal = self.frame;
    
    if(inPosition){
        rcFinal.size = CGSizeMake(0, 0);
    }else{
        switch (_position) {
            case modalTop:
                rcFinal = CGRectOffset(rcFinal, 0, -rcFinal.size.height);
                break;
            case modalCenter:
                rcFinal = CGRectOffset(rcFinal, rcFinal.size.width, 0);
                break;
            case modalBottom:
                rcFinal = CGRectOffset(rcFinal, 0, rcFinal.size.height);
                break;
            default:
                break;
        }
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.2];
    self.frame = rcFinal;
    [UIView commitAnimations];
    [self enableFlexLayout:YES];
    
    __weak FlexRootView* weakRoot = _root;
    __weak FlexModalView* weakSelf = self;
    _realRoot = _root;
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        // 防止执行显示动画的时候将其移除
        if(weakSelf.bLastHiding){
            [weakSelf removeFromSuperview];
            [weakRoot removeFromSuperview];
        }
    });
}
FLEXSET(position){
    _position = NSString2Int(sValue, _gModalPosition, sizeof(_gModalPosition)/sizeof(NameValue));
}
FLEXSET(cancelable){
    _cancelable = String2BOOL(sValue);
}
FLEXSET(maskColor){
    _root.backgroundColor = colorFromString(sValue,owner);
}

@end
