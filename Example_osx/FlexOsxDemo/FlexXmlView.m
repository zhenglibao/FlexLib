//
//  FlexXmlView.m
//  FlexOsxDemo
//
//  Created by 郑立宝 on 2020/6/16.
//  Copyright © 2020 郑立宝. All rights reserved.
//

#import "FlexXmlView.h"
#import "FlexLib.h"

@interface FlexXmlView()

@property(nonatomic,strong) FlexFrameView* rootFrameView;

@end

@implementation FlexXmlView

- (BOOL)needBindVariable
{
    return NO;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return YES;
}

-(BOOL)loadXml:(NSString*)xmlPath
{
    if (self.rootFrameView) {
        [self.rootFrameView removeFromSuperview];
        self.rootFrameView = nil;
    }
    
    CGRect rc = self.frame ;
    rc.origin = CGPointZero;
    self.rootFrameView = [[FlexFrameView alloc]initWithFlex:xmlPath Frame:rc Owner:self];
    self.rootFrameView.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
    [self addSubview:self.rootFrameView];
    
    return YES;
}

@end
