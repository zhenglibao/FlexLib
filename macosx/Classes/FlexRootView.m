/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "FlexRootView.h"
#import "YogaKit/NSView+Yoga.h"
#import "FlexNode.h"
#import "ViewExt/NSView+Flex.h"
#import "FlexUtils.h"
#import "FlexStyleMgr.h"
#import "UILabel.h"

static void* gObserverHidden    = &gObserverHidden;
static void* gObserverText = &gObserverText;
static void* gObserverAttrText  = &gObserverAttrText;

static NSInteger _compareInputView(NSView * _Nonnull f,
                                   NSView * _Nonnull s,
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

@implementation NSView(FlexPublic)

+(NSView*)buildFlexView:(Class)viewCls
                 Layout:(NSArray<NSString*>*)layoutAttrs
              ViewAttrs:(NSArray<NSString*>*)viewAttrs
{
    if(![viewCls isSubclassOfClass:[NSView class]])
        return nil;
    
    NSView* view = [[viewCls alloc]init];
    
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
    NSView* parent = self;
    while(parent!=nil){
        if([parent isKindOfClass:[FlexRootView class]]){
            return (FlexRootView*)parent;
        }
        parent = parent.superview;
    }
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: frame:%@", NSStringFromClass(self.class),NSStringFromRect(self.frame)];
}

-(NSObject*)owner
{
    NSView* parent = self;
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

-(NSView*)findLeaf
{
    if(self.yoga.isLeaf)
        return self;
    
    for (NSView* subview in self.subviews) {
        NSView* leaf = [subview findLeaf];
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

- (NSSize)sizeThatFits:(NSSize)size
{
    return self.frame.size;
}

-(void)markDirty
{
    FlexRootView* rootView = self.rootView;
    if(rootView != nil){
        NSView* leaf = [self findLeaf];
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
-(NSView*)findByName:(NSString*)name
{
    if([name compare:self.viewAttrs.name options:NSLiteralSearch]==NSOrderedSame)
        return self;
    
    for (NSView* sub in self.subviews) {
        NSView* find = [sub findByName:name];
        if(find != nil)
            return find;
    }
    return nil;
}
-(void)findAllViews:(NSMutableArray*)result Type:(Class)type
{
    for (NSView* sub in self.subviews) {
        if([sub isKindOfClass:type]){
            [result addObject:sub];
        }else if(sub.subviews.count>0){
            [sub findAllViews:result Type:type];
        }
    }
}
-(NSArray<NSView*>*)findAllInputs
{
    NSMutableArray<NSView*>* ary = [NSMutableArray array];
    
    [self findAllViews:ary Type:[NSTextField class]];
    [self findAllViews:ary Type:[NSTextView class]];
    
    for (NSView* sub in ary) {
        CGPoint pt = [self convertPoint:sub.frame.origin fromView:sub.superview];
        sub.viewAttrs.originInRoot = pt;
    }
    
    [ary sortUsingFunction:_compareInputView context:NULL];
    return [ary copy];
}
-(NSView*)findFirstResponder
{
//    if(self.isFirstResponder)
//        return self;
//    
//    for (NSView* sub in self.subviews) {
//        if(sub.isFirstResponder)
//            return sub;
//        NSView* first = [sub findFirstResponder];
//        if(first != nil)
//            return first;
//    }
    return nil;
}
@end


@interface FlexRootView()
{
    BOOL _bInLayouting;
    NSMutableSet<NSView*>* _observedViews;
    
    CGRect _lastConfigFrame;
    CGRect _thisConfigFrame;
    BOOL _bChildDirty;
    
    __weak NSObject* _owner;
 }
@end
@implementation FlexRootView

- (BOOL)isFlipped
{
    return YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bInLayouting = NO ;
        _observedViews = [NSMutableSet set];
        _safeArea = NSEdgeInsetsMake(0, 0, 0, 0);
        _lastConfigFrame = CGRectZero;
        _bChildDirty = NO;
        
        [self enableFlexLayout:NO];
    }
    return self;
}

-(NSView*)topSubView
{
    if(self.subviews.count>0){
        return self.subviews[0];
    }
    return nil;
}
-(NSObject*)owner{
    return _owner;
}

- (BOOL)inLayouting
{
    return _bInLayouting;
}

-(BOOL)loadWithNodeData:(NSData*)data
                  Owner:(NSObject*)owner
{
    _owner = owner;
    
    FlexNode* node = [FlexNode loadNodeData:data];
    if(node != nil){
        NSView* sub ;
        
        @try{
            sub = [node buildViewTree:owner
                             RootView:self];
        }@catch(NSException* exception){
            NSLog(@"Flexbox: FlexRootView exception occured - %@",exception);
        }
        
        [self addSubview:sub];
        return sub!=nil;
    }
    return NO;
}

-(BOOL)loadWithNodeFile:(NSString*)resName
                  Owner:(NSObject*)owner
{
    if(resName==nil){
        resName = NSStringFromClass([owner class]);
    }
    
    _owner = owner;
    
    FlexNode* node = [FlexNode loadNodeFromRes:resName Owner:owner];
    if(node != nil){
        NSView* sub ;
        
        @try{
            sub = [node buildViewTree:owner
                             RootView:self];
        }@catch(NSException* exception){
            NSLog(@"Flexbox: FlexRootView exception occured - %@",exception);
        }
        
        [self addSubview:sub];
        return sub!=nil;
    }
    return NO;
}

+(FlexRootView*)loadWithNodeData:(NSData*)data
                           Owner:(NSObject*)owner
{
    FlexRootView* root = [[FlexRootView alloc]init];
    [root loadWithNodeData:data Owner:owner];
    return root;
}
+(FlexRootView*)loadWithNodeFile:(NSString*)resName
                           Owner:(NSObject*)owner
{
    FlexRootView* root = [[FlexRootView alloc]init];
    [root loadWithNodeFile:resName Owner:owner];
    return root;
}

- (void)dealloc
{
    NSArray* all = _observedViews.allObjects;
    for(NSView* subview in all)
    {
        [self removeWatchView:subview];
    }
}
-(void)registSubView:(NSView*)subView
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
-(void)removeWatchView:(NSView*)view
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSView*)object change:(NSDictionary *)change context:(void *)context
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
-(void)markChildDirty:(NSView*)child
{
    [child.yoga markDirty];
    _bChildDirty = YES;
    [self setNeedsLayout:YES];
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
    CGRect rcSafeArea ;
    
    if (self.useFrame) {
        rcSafeArea = self.frame;
    } else {
        rcSafeArea = self.superview.frame ;
        rcSafeArea.origin = CGPointZero;
        
        NSEdgeInsets inset;
        if(self.calcSafeArea!=nil)
        {
            inset = self.calcSafeArea();
        }else{
            inset = self.safeArea;
        }
        rcSafeArea = CGRectMake(rcSafeArea.origin.x+inset.left,
                      rcSafeArea.origin.y+inset.top,
                      rcSafeArea.size.width-inset.left-inset.right,
                      rcSafeArea.size.height-inset.top-inset.bottom);
    }
    return rcSafeArea;
}
-(BOOL)isConfigSame
{
    return memcmp(&_thisConfigFrame, &_lastConfigFrame, sizeof(CGRect))==0;
}

-(void)layout
{
    if(_bInLayouting)
        return;
    
    [self configureLayout: [self getSafeArea]];
    BOOL configsame = [self isConfigSame];
    
    if(!_bChildDirty && configsame)
    {
        return;
    }
    
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
    
    [self enableFlexLayout:YES];
    [self.yoga applyLayoutPreservingOrigin:NO dimensionFlexibility:option];
    [self enableFlexLayout:NO];
    
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
    
    CGSize sz;
    [self enableFlexLayout:YES];
    sz=[self.yoga calculateLayoutWithSize:szLimit];
    [self enableFlexLayout:NO];
    return sz;
}
-(CGSize)calculateSize
{
    CGRect rc = self.superview.frame ;
    return [self calculateSize:rc.size];
}


-(void)layoutAnimation:(NSTimeInterval)duration
{
    NSLog(@"not support animation for osx");
//    self.beginLayout = ^{
//        [NSView beginAnimations:nil context:nil];
//        [NSView setAnimationDuration:duration];
//    };
//
//    self.endLayout = ^{
//        [NSView commitAnimations];
//    };
}

-(NSScrollView*)scrollView{
    NSScrollView* scrollView = (NSScrollView*) self.superview ;
    
    while (scrollView!=nil) {
        if([scrollView isKindOfClass:[NSScrollView class]]){
            return scrollView;
        }
        scrollView = (NSScrollView*) scrollView.superview;
    }
    return scrollView;
}

@end
