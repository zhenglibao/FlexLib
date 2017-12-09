/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
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
    FlexRootView* _root;
    FlexRootView* _ownerRootView;
    
    FlexModalPosition _position;
    BOOL _cancelable;
}
@end

@implementation FlexModalView
- (instancetype)init
{
    self = [super init];
    if (self) {
        _root = [[FlexRootView alloc]init];
        _root.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapOutside)];
        [_root addGestureRecognizer:tap];
        [_root addSubview:self];
    }
    return self;
}
-(void)setOwnerRootView:(FlexRootView*)rootView
{
    _ownerRootView = rootView;
}
-(void)postCreate
{
    YGLayout* layout = self.yoga;
    
    switch (_position) {
        case modalTop:
            layout.top = YGPointValue(0);
            break;
        case modalCenter:
            _root.yoga.justifyContent = YGJustifyCenter;
            break;
        case modalBottom:
            layout.position = YGPositionTypeAbsolute;
            layout.bottom = YGPointValue(0);
            break;
        default:
            break;
    }
}
-(void)onTapOutside
{
    if(_cancelable)
        [self hideModal];
}
-(void)showModalInView:(UIView*)view
{
    [self hideModal];
    
    _root.portraitSafeArea = _ownerRootView.portraitSafeArea;
    _root.landscapeSafeArea = _ownerRootView.landscapeSafeArea;

    [view addSubview:_root];
    [_root markChildDirty:self];
}
-(void)hideModal
{
    if(_root==nil||_root.superview==nil)
        return;
    [_root removeFromSuperview];
}

FLEXSET(position){
    _position = NSString2Int(sValue, _gModalPosition, sizeof(_gModalPosition)/sizeof(NameValue));
}
FLEXSET(cancelable){
    _cancelable = String2BOOL(sValue);
}
@end
