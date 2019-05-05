//
//  FlexXmlBaseView.m
//  Expecta
//
//  Created by 郑立宝 on 2019/2/2.
//

#import "FlexXmlBaseView.h"
#import "FlexNode.h"
#import "FlexStyleMgr.h"
#import "FlexModalView.h"
#import "YogaKit/UIView+Yoga.h"
#import "YogaKit/YGLayout.h"
#import "ViewExt/UIView+Flex.h"

@interface FlexXmlBaseView()

@property(nonatomic,strong) FlexNode* flexNode;

@end

@implementation FlexXmlBaseView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.flexNode = [FlexNode loadNodeFromRes:NSStringFromClass(self.class) Owner:self];
    }
    return self;
}

-(instancetype)initWithRootView:(FlexRootView*)rootview
{
    self = [self init];
    if (self) {
        [self afterInit:self rootView:rootview];
    }
    return self;
}

- (void)afterInit:(NSObject *)owner rootView:(FlexRootView *)rootView
{
    FlexNode* node = self.flexNode ;
    self.flexNode = nil;
    
    if(node == nil){
        NSLog(@"Flexbox: FlexXmlBaseView load subviews failed - %@",self.class);
        return;
    }
    
    if(![node.viewClassName isEqualToString:NSStringFromClass(self.class)]){
        NSLog(@"Flexbox: the outermost view must be %@",self.class);
        return;
    }
    
    if (node.name.length>0) {
        NSLog(@"Flexbox: the name %@ will be ignored in %@ xml",node.name,self.class);
    }
    if (node.onPress.length>0) {
        NSLog(@"Flexbox: the onPress %@ should be set only when %@ being used",node.onPress,self.class);
    }
    
    // 设置布局属性
    [self configureLayoutWithBlock:^(YGLayout* layout){
        
        layout.isEnabled = YES;
        layout.isIncludedInLayout = YES;
        
        NSArray<FlexAttr*>* layoutParam = node.layoutParams ;
        
        for (FlexAttr* attr in layoutParam) {
            if([attr.name compare:@"@" options:NSLiteralSearch]==NSOrderedSame){
                
                NSArray* ary = [[FlexStyleMgr instance]getStyleByRefPath:attr.value];
                for(FlexAttr* styleAttr in ary)
                {
                    FlexApplyLayoutParam(layout, styleAttr.name, styleAttr.value);
                }
                
            }else{
                FlexApplyLayoutParam(layout, attr.name, attr.value);
            }
        }
    }];
    
    // 设置视图属性
    if(node.viewAttrs.count > 0){
        NSArray<FlexAttr*>* attrParam = node.viewAttrs ;
        for (FlexAttr* attr in attrParam) {
            if([attr.name compare:@"@" options:NSLiteralSearch]==NSOrderedSame){
                
                NSArray* ary = [[FlexStyleMgr instance]getStyleByRefPath:attr.value];
                for(FlexAttr* styleAttr in ary)
                {
                    FlexSetViewAttr(self, styleAttr.name, styleAttr.value,self);
                }
                
            }else{
                FlexSetViewAttr(self, attr.name, attr.value,self);
            }
        }
    }
    
    // 创建子view
    
    for (FlexNode* subnode in node.children) {
        UIView* child = [subnode buildViewTree:self
                                      RootView:rootView];
        
        if(child!=nil && ![child isKindOfClass:[FlexModalView class]])
        {
            [self addSubview:child];
        }
    }
    
    [self onInit];
}

-(void)onInit
{
    
}

@end
