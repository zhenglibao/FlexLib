/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "FlexTextView.h"
#import "FlexRootView.h"
#import "FlexUtils.h"
#import "YogaKit/NSView+Yoga.h"
#import "NSView+Flex.h"
#import "UILabel.h"


@interface FlexTextView()
{
    UILabel* _placeholderLabel;
}
@property(nonatomic,assign) BOOL needAdjustFont;
@end

@implementation FlexTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UILabel* label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.textColor = [self.class defaultColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:NSTextDidChangeNotification object:self];
        
        _placeholderLabel = label;
    }
    return self;
}
- (void)dealloc
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFrameSize:(NSSize)newSize
{
    [super setFrameSize:newSize];
    
    [self updatePlaceholder];
}

- (void)setFont:(NSFont *)font
{
    [super setFont:font];
    
    self.needAdjustFont = YES;
    [self updatePlaceholder];
}

- (void)textDidChange:(NSNotification *)notification
{
    [self updatePlaceholder];
    
    CGRect rcSelf = self.frame;
    CGSize szLimit = CGSizeMake(rcSelf.size.width, FLT_MAX);
    CGSize sz = [self sizeThatFits:szLimit];
    
    CGFloat diff = ceil(sz.height)-rcSelf.size.height;
    
    if(diff>1){
        YGValue maxHeight = self.yoga.maxHeight;
        if(maxHeight.unit == YGUnitPoint &&
           rcSelf.size.height+0.5f >= maxHeight.value){
        }else{
            [self markDirty];
        }
    }else if(diff<-1){
        YGValue minHeight = self.yoga.minHeight;
        if(minHeight.unit == YGUnitPoint &&
           rcSelf.size.height<= minHeight.value+0.5f){
        }else{
            [self markDirty];
        }
    }
}

#pragma mark - placeholder

- (UILabel *)placeholdLabel
{
    return _placeholderLabel;
}

+ (NSColor *)defaultColor
{
    static NSColor *color = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        color = [NSColor colorWithRed:0 green:0 blue:0.098039215686274508 alpha:0.22];
    });
    return color;
}

#pragma mark - set get methods

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholderLabel.text = placeholder;
    [self updatePlaceholder];
}

- (NSString *)placeholder
{
    return _placeholderLabel.text;
}

- (void)setPlaceholderColor:(NSColor *)placeholderColor
{
    _placeholderLabel.textColor = placeholderColor;
    [self updatePlaceholder];
}

- (NSColor *)placeholderColor
{
    return self.placeholdLabel.textColor;
}

- (void)setAttributePlaceholder:(NSAttributedString *)attributePlaceholder
{
    _placeholderLabel.attributedText = attributePlaceholder;
    [self updatePlaceholder];
}

- (NSAttributedString *)attributePlaceholder
{
    return _placeholderLabel.attributedText;
}


- (void)updatePlaceholder
{
    if (self.text.length) {
        [_placeholderLabel removeFromSuperview];
        return;
    }


    [self addSubview:_placeholderLabel positioned:NSWindowBelow relativeTo:nil];

    if (self.needAdjustFont) {
        self.placeholdLabel.font = self.font;
        self.needAdjustFont = NO;
    }

    CGFloat  lineFragmentPadding =  self.textContainer.lineFragmentPadding;
    NSSize contentInset = self.textContainerInset;
    NSPoint textContainerOrigin = self.textContainerOrigin;

    CGFloat labelX = lineFragmentPadding + textContainerOrigin.x;
    CGFloat labelY = textContainerOrigin.y;
    if (self.location.x != 0 || self.location.y != 0) {
        if (self.location.x < 0 || self.location.x > CGRectGetWidth(self.bounds) - lineFragmentPadding - contentInset.width || self.location.y< 0) {
        }else{
            labelX += self.location.x;
            labelY += self.location.y;
        }
    }
    CGFloat labelW = CGRectGetWidth(self.bounds)  - contentInset.width - labelX;
    CGFloat labelH = [self.placeholdLabel sizeThatFits:CGSizeMake(labelW, MAXFLOAT)].height;
    _placeholderLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
}



#pragma mark - export attr

FLEXSET(placeholder)
{
    self.placeholder = sValue ;
}
FLEXSET(placeholderColor)
{
    NSColor* clr = colorFromString(sValue,owner) ;
    if(clr)
        self.placeholderColor = clr ;
}
@end
