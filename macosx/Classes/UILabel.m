//
//  UILabel.m
//  FlexViewer
//
//  Created by 郑立宝 on 2019/11/19.
//  Copyright © 2019 郑立宝. All rights reserved.
//

#import "UILabel.h"
#import "FlexUtils.h"



@implementation UILabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bezeled = NO;
        self.editable = NO;
        self.bordered = NO;
        self.backgroundColor = [NSColor clearColor];
    }
    return self;
}
- (NSSize)sizeThatFits:(NSSize)size
{
    NSSize sz = [super sizeThatFits:size];
    return sz;
}

FLEXSET(bgColor)
{
    NSColor* clr = colorFromString(sValue,owner) ;
    if(clr!=nil){
        self.backgroundColor = clr;
    }
}

FLEXSET(text)
{
    self.stringValue = sValue;
}
FLEXSET(fontSize)
{
    float nSize = [sValue floatValue];
    if(nSize > 0){
        NSFont* font = [NSFont systemFontOfSize:nSize];
        self.font = font;
    }
}
FLEXSET(linesNum)
{
    if (@available(macOS 10.11, *)) {
        self.maximumNumberOfLines = [sValue integerValue];
    } else {
        NSLog(@"maximumNumberOfLines only available for 10.11 above");
    }
}

FLEXSET(color)
{
    NSColor* clr = colorFromString(sValue,owner);
    if(clr!=nil){
        self.textColor = clr ;
    }
}

@end
