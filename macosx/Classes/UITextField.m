//
//  UITextField.m
//  FlexLibOsx
//
//  Created by 郑立宝 on 2020/6/18.
//

#import "UITextField.h"

@implementation UITextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bordered = NO;
        self.bezeled = NO;
        self.editable = YES;
        self.selectable = YES;
        self.usesSingleLineMode = YES;
        self.focusRingType = NSFocusRingTypeNone;
        if (@available(macOS 10.11, *)) {
            self.maximumNumberOfLines = 1;
        }
    }
    return self;
}

- (NSSize)sizeThatFits:(NSSize)size
{
    return NSMakeSize(size.width, 40);
}

@end
