/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "FlexRootView.h"
#import "YogaKit/UIView+Yoga.h"
#import "FlexNode.h"
#import "FlexModalView.h"
#import "ViewExt/UIView+Flex.h"
#import "FlexUtils.h"
#import "FlexStyleMgr.h"

static void* gObserverHidden    = &gObserverHidden;
static void* gObserverText = &gObserverText;
static void* gObserverAttrText  = &gObserverAttrText;

static NSInteger _compareInputView(UIView * _Nonnull f,
                                   UIView * _Nonnull s,
                                   void * _Nullable context)
{
    CGPoint pt1 = f.viewAttrs.originInRoot;
    CGPoint pt2 = s.viewAttrs.originInRoot;
    if(pt1.y < pt2.y)
        return NSOrderedAscending;
    if(pt1.y > pt2.y)
        return NSOrderedDescending;
    if(pt1.x < pt2.x)
        return NSOrderedAscending;
    if(pt1.x > pt2.x)
        return NSOrderedDescending;
    return NSOrderedSame;
}

@implementation UIView(FlexPublic)

+(UIView*)buildFlexView:(Class)viewCls
                 Layout:(NSArray<NSString*>*)layoutAttrs
              ViewAttrs:(NSArray<NSString*>*)viewAttrs
{
    if(![viewCls isSubclassOfClass:[UIView class]])
        return nil;
    
    UIView* view = [[viewCls alloc]init];
    
    [view enableFlexLayout:YES];
    
    if(layoutAttrs.count > 0){
        [view setLayoutAttrStrings:layoutAttrs];
    }
    if(viewAttrs.count > 0){
        [view setViewAttrStrings:viewAttrs];
    }
    return view;
}
-(FlexRootView*)rootView
{
    UIView* parent = self;
    while(parent!=nil){
        if([parent isKindOfClass:[FlexRootView class]]){
            return (FlexRootView*)parent;
        }
        parent = parent.superview;
    }
    return nil;
}
-(NSObject*)owner
{
    UIView* parent = self;
    while(parent!=nil){
        if([parent isKindOfClass:[FlexRootView class]] &&
           [(FlexRootView*)parent owner]!=nil)
        {
            return [(FlexRootView*)parent owner];
        }
        parent = parent.superview;
    }
    return nil;
}

-(UIView*)findLeaf
{
    if(self.yoga.isLeaf)
        return self;
    
    for (UIView* subview in self.subviews) {
        UIView* leaf = [subview findLeaf];
        if(leaf != nil)
            return leaf;
    }
    return nil;
}
-(BOOL)buildChildElements:(NSArray<FlexNode*>*)childElems
                    Owner:(NSObject*)owner
                 RootView:(FlexRootView*)rootView
{
    return NO;
}
-(void)markDirty
{
    FlexRootView* rootView = self.rootView;
    if(rootView != nil){
        UIView* leaf = [self findLeaf];
        if(leaf != nil){
            [rootView markChildDirty:leaf];
        }
    }
}

-(void)markYogaDirty
{
    [self.yoga markDirty];
}

-(void)enableFlexLayout:(BOOL)enable
{
    [self configureLayoutWithBlock:^(YGLayout* layout){
        
        layout.isIncludedInLayout = enable;
        layout.isEnabled = enable;
        
    }];
}

-(BOOL)isFlexLayoutEnable{
    return self.yoga.isIncludedInLayout;
}

-(void)setViewAttr:(NSString*) name
             Value:(NSString*) value
{
    FlexSetViewAttr(self, name, value,self.owner);
}
-(void)setViewAttrs:(NSArray<FlexAttr*>*)attrs
{
    NSObject* owner = self.owner ;
    for (FlexAttr* attr in attrs) {
        FlexSetViewAttr(self, attr.name, attr.value,owner);
    }
}
-(void)setViewAttrStrings:(NSArray<NSString*>*)stringAttrs
{
    NSObject* owner = self.owner ;
    for (NSInteger i=0;i+1<stringAttrs.count;i+=2) {
        FlexSetViewAttr(self, stringAttrs[i], stringAttrs[i+1],owner);
    }
}
-(void)setLayoutAttr:(NSString*) name
               Value:(NSString*) value
{
    FlexApplyLayoutParam(self.yoga, name, value);
}
-(void)setLayoutAttrs:(NSArray<FlexAttr*>*)attrs
{
    [self configureLayoutWithBlock:^(YGLayout* layout){
        for (FlexAttr* attr in attrs) {
            FlexApplyLayoutParam(layout, attr.name, attr.value);
        }
    }];
}
-(void)setLayoutAttrStrings:(NSArray<NSString*>*)stringAttrs
{
    [self configureLayoutWithBlock:^(YGLayout* layout){
        for (NSInteger i=0;i+1<stringAttrs.count;i+=2) {
            FlexApplyLayoutParam(layout, stringAttrs[i], stringAttrs[i+1]);
        }
    }];
}
-(UIView*)findByName:(NSString*)name
{
    if([name compare:self.viewAttrs.name options:NSLiteralSearch]==NSOrderedSame)
        return self;
    
    for (UIView* sub in self.subviews) {
        UIView* find = [sub findByName:name];
        if(find != nil)
            return find;
    }
    return nil;
}
-(void)findAllViews:(NSMutableArray*)result Type:(Class)type
{
    for (UIView* sub in self.subviews) {
        if([sub isKindOfClass:type]){
            [result addObject:sub];
        }else if(sub.subviews.count>0){
            [sub findAllViews:result Type:type];
        }
    }
}
-(NSArray<UIView*>*)findAllInputs
{
    NSMutableArray<UIView*>* ary = [NSMutableArray array];
    
    [self findAllViews:ary Type:[UITextField class]];
    [self findAllViews:ary Type:[UITextView class]];
    
    for (UIView* sub in ary) {
        CGPoint pt = [self convertPoint:sub.frame.origin fromView:sub.superview];
        sub.viewAttrs.originInRoot = pt;
    }
    
    [ary sortUsingFunction:_compareInputView context:NULL];
    return [ary copy];
}
-(UIView*)findFirstResponder
{
    if(self.isFirstResponder)
        return self;
    
    for (UIView* sub in self.subviews) {
        if(sub.isFirstResponder)
            return sub;
        UIView* first = [sub findFirstResponder];
        if(first != nil)
            return first;
    }
    return nil;
}
@end

@interface FlexRootView()
{
    BOOL _bInLayouting;
    NSMutableSet<UIView*>* _observedViews;
    
    CGRect _lastConfigFrame;
    CGRect _thisConfigFrame;
    BOOL _bChildDirty;
    
    __weak NSObject* _owner;
 }
@end
@implementation FlexRootView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bInLayouting = NO ;
        _observedViews = [NSMutableSet set];
        _safeArea = UIEdgeInsetsMake(0, 0, 0, 0);
        _lastConfigFrame = CGRectZero;
        _bChildDirty = NO;
        
        [self enableFlexLayout:YES];
    }
    return self;
}

-(UIView*)topSubView
{
    if(self.subviews.count>0){
        return self.subviews[0];
    }
    return nil;
}
-(NSObject*)owner{
    return _owner;
}

+(FlexRootView*)loadWithNodeData:(NSData*)data
                           Owner:(NSObject*)owner
{
    FlexRootView* root = [[FlexRootView alloc]init];
    root->_owner = owner;
    
    FlexNode* node = [FlexNode loadNodeData:data];
    if(node != nil){
        UIView* sub ;
        
        @try{
            sub = [node buildViewTree:owner
                             RootView:root];
        }@catch(NSException* exception){
            NSLog(@"Flexbox: FlexRootView exception occured - %@",exception);
        }
        
        if(sub != nil && ![sub isKindOfClass:[FlexModalView class]])
        {
            [root addSubview:sub];
        }
    }
    return root;
}
+(FlexRootView*)loadWithNodeFile:(NSString*)resName
                           Owner:(NSObject*)owner
{
    if(resName==nil){
        resName = NSStringFromClass([owner class]);
    }
    
    FlexRootView* root = [[FlexRootView alloc]init];
    root->_owner = owner;
    
    FlexNode* node = [FlexNode loadNodeFromRes:resName Owner:owner];
    if(node != nil){
        UIView* sub ;
        
        @try{
            sub = [node buildViewTree:owner
                             RootView:root];
        }@catch(NSException* exception){
            NSLog(@"Flexbox: FlexRootView exception occured - %@",exception);
        }
        
        if(sub != nil && ![sub isKindOfClass:[FlexModalView class]])
        {
            [root addSubview:sub];
        }
    }
    return root;
}

- (void)dealloc
{
    NSArray* all = _observedViews.allObjects;
    for(UIView* subview in all)
    {
        [self removeWatchView:subview];
    }
}
-(void)registSubView:(UIView*)subView
{
    if(subView==nil || [_observedViews containsObject:subView])
        return;
    
    [_observedViews addObject:subView];
    
    [subView addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:gObserverHidden];
    
    if([subView isKindOfClass:[UILabel class]]){
        [subView addObserver:self forKeyPath:@"text" options:0 context:gObserverText];
        [subView addObserver:self forKeyPath:@"attributedText" options:0 context:gObserverAttrText];
    }
}
-(void)removeWatchView:(UIView*)view
{
    if(view==nil||![_observedViews containsObject:view])
        return;
    
    [_observedViews removeObject:view];
    
    [view removeObserver:self forKeyPath:@"hidden"];
    
    if([view isKindOfClass:[UILabel class]]){
        [view removeObserver:self forKeyPath:@"text"];
        [view removeObserver:self forKeyPath:@"attributedText"];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView*)object change:(NSDictionary *)change context:(void *)context
{
    if(_bInLayouting||object == nil)
    {
        if(context==gObserverHidden ||
           context==gObserverText||
           context==gObserverAttrText)
        {
            return;
        }
    }
    
    if( context == gObserverHidden ){
        BOOL n = [[change objectForKey:@"new"] boolValue];
        BOOL o = [[change objectForKey:@"old"] boolValue];
        if(n!=o){
            [object enableFlexLayout:!n];
            [object markDirty];
        }
    }else if( context == gObserverText ){
        
        [object markDirty];
        
    }else if( context == gObserverAttrText ){
        
        [object markDirty];
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void)markChildDirty:(UIView*)child
{
    [child.yoga markDirty];
    _bChildDirty = YES;
    [self setNeedsLayout];
}

#pragma mark - layout methods

-(void)configureLayout:(CGRect)safeArea
{
    [self configureLayoutWithBlock:^(YGLayout* layout){
        
        layout.left = YGPointValue(safeArea.origin.x) ;
        layout.top = YGPointValue(safeArea.origin.y);
        
        if(self.flexibleWidth)
            layout.width = YGPointValue(NAN);
        else
            layout.width = YGPointValue(safeArea.size.width) ;
        
        if(self.flexibleHeight)
            layout.height = YGPointValue(NAN);
        else
            layout.height = YGPointValue(safeArea.size.height) ;
        
        self->_thisConfigFrame = CGRectMake(layout.left.value, layout.top.value, layout.width.value, layout.height.value);
    }];
}

-(CGRect)getSafeArea
{
    CGRect rcSafeArea = self.superview.frame ;
    rcSafeArea.origin = CGPointZero;
    if(self.calcSafeArea!=nil)
        return UIEdgeInsetsInsetRect(rcSafeArea,self.calcSafeArea());
    return UIEdgeInsetsInsetRect(rcSafeArea,self.safeArea);
}
-(BOOL)isConfigSame
{
    return memcmp(&_thisConfigFrame, &_lastConfigFrame, sizeof(CGRect))==0;
}

-(void)layoutSubviews
{
    if(_bInLayouting)
        return;
    
    [self configureLayout: [self getSafeArea]];
    BOOL configsame = [self isConfigSame];
    
    if(!_bChildDirty && configsame)
    {
        return;
    }
    
    //NSLog(@"Flexbox: FlexRootView layouting");

    _bInLayouting = YES;
    _lastConfigFrame = _thisConfigFrame;
    
    enum YGDimensionFlexibility option = 0 ;
    if(self.flexibleWidth)
        option |= YGDimensionFlexibilityFlexibleWidth ;
    if(self.flexibleHeight)
        option |= YGDimensionFlexibilityFlexibleHeight ;
    
    CGRect rcOld = self.frame;
    
    if(self.beginLayout != nil)
        self.beginLayout();
    
    // 布局前事件
    if(self.onWillLayout != nil){
        self.onWillLayout();
    }
    
    [self.yoga applyLayoutPreservingOrigin:NO dimensionFlexibility:option];
    
    // 布局后事件
    if(self.onDidLayout != nil){
        self.onDidLayout();
    }
    
    if(!CGRectEqualToRect(rcOld, self.frame)){
        [self.superview subFrameChanged:self Rect:self.frame];
    }
    
    if(self.endLayout !=nil)
        self.endLayout();

    self.endLayout = nil;
    self.beginLayout = nil;

    _bInLayouting = NO ;
    _bChildDirty = NO;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:FLEXDIDLAYOUT object:self];
}

-(CGSize)calculateSize:(CGSize)szLimit
{
    CGRect rc ;
    rc.origin = CGPointMake(0, 0);
    rc.size = szLimit;
    [self configureLayout:rc];
    
    if(self.flexibleWidth)
        szLimit.width = NAN ;
    if(self.flexibleHeight)
        szLimit.height = NAN ;
    
    CGSize sz=[self.yoga calculateLayoutWithSize:szLimit];
    return sz;
}
-(CGSize)calculateSize
{
    CGRect rc = self.superview.frame ;
    return [self calculateSize:rc.size];
}


-(void)layoutAnimation:(NSTimeInterval)duration
{
    self.beginLayout = ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
    };
    
    self.endLayout = ^{
        [UIView commitAnimations];
    };
}

@end
