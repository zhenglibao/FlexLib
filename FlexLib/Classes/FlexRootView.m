//
//  FlexRootView.m
//  Pods
//
//  Created by zhenglibao on 2017/12/4.
//

#import "FlexRootView.h"
#import "YogaKit/UIView+Yoga.h"
#import "FlexNode.h"

static void* gObserverHidden    = (void*)1;
static void* gObserverText      = (void*)2;
static void* gObserverAttrText  = (void*)3;

@interface FlexRootView()
{
    BOOL _bInLayouting;
    NSMutableSet<UIView*>* _observedViews;
}
@end
@implementation FlexRootView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bInLayouting = NO ;
        _flexOption = 0 ;
        _observedViews = [NSMutableSet set];
    }
    return self;
}


+(FlexRootView*)loadWithNodeFile:(NSString*)resName
                           Owner:(NSObject*)owner
{
    if(resName==nil){
        resName = NSStringFromClass([owner class]);
    }
    
    NSString* path;
    
    if([resName hasPrefix:@"/"]){
        // it's absolute path
        path = resName ;
    }else{
        path = [[NSBundle mainBundle]pathForResource:resName ofType:@"xml"];
    }
    
    if(path==nil){
        NSLog(@"Flexbox: resource %@ not found.",resName);
        return nil;
    }
    
    FlexRootView* root = [[FlexRootView alloc]init];
    FlexNode* node = [FlexNode loadNodeFile:path];
    if(node != nil){
        UIView* sub = [node buildViewTree:owner RootView:root];
        
        if(sub != nil){
            [root addSubview:sub];
        }
    }
    root.yoga.isEnabled = YES;
    return root;
}

- (void)dealloc
{
    for(UIView* subview in _observedViews)
    {
        [self removeWatchView:subview];
    }
}
-(void)registSubView:(UIView*)subView
{
    if([_observedViews containsObject:subView])
        return;
    
    [_observedViews addObject:subView];
    
    [subView addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:gObserverHidden];
    [subView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:gObserverText];
    [subView addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:gObserverAttrText];
}
-(void)removeWatchView:(UIView*)view
{
    if(view==nil)
        return;
    
    [view removeObserver:self forKeyPath:@"hidden"];
    [view removeObserver:self forKeyPath:@"text"];
    [view removeObserver:self forKeyPath:@"attributedText"];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView*)object change:(NSDictionary *)change context:(void *)context
{
    if(_bInLayouting)
        return;
    
    if(object != nil){
        
        if( context == gObserverHidden ){
            BOOL n = [[change objectForKey:@"new"] boolValue];
            object.yoga.isIncludedInLayout = !n;
        }
        
        [object.yoga markDirty];
    }
    [self setNeedsLayout];
}
#pragma mark - layout methods

-(void)layoutSubviews
{
    if(_bInLayouting)
        return;
    
    
    [self configureLayoutWithBlock:^(YGLayout* layout){
        CGRect rc = self.superview.frame ;
        
        layout.width = YGPointValue(rc.size.width) ;
        layout.height = YGPointValue(rc.size.height) ;
    }];
    
    YGDimensionFlexibility option = 0 ;
    if((self.flexOption & FlexibleWidth)!=0)
        option |= YGDimensionFlexibilityFlexibleWidth ;
    if((self.flexOption & FlexibleHeight)!=0)
        option |= YGDimensionFlexibilityFlexibleHeigth ;
    
    _bInLayouting = YES;
    [self.yoga applyLayoutPreservingOrigin:NO dimensionFlexibility:option];
    _bInLayouting = NO ;
}

-(CGSize)calculateSize:(CGSize)szLimit
{
    [self configureLayoutWithBlock:^(YGLayout* layout){
        
        if((self.flexOption & FlexibleWidth)==0)
            layout.width = YGPointValue(szLimit.width) ;
        if((self.flexOption & FlexibleHeight)==0)
            layout.height = YGPointValue(szLimit.height) ;
    }];
    
    if((self.flexOption & FlexibleWidth)!=0)
        szLimit.width = NAN ;
    if((self.flexOption & FlexibleHeight)!=0)
        szLimit.height = NAN ;
    
    return [self.yoga calculateLayoutWithSize:szLimit];
}
-(CGSize)calculateSize
{
    CGRect rc = self.superview.frame ;
    return [self calculateSize:rc.size];
}


@end
