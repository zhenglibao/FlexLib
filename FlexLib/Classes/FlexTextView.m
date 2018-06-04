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
#import "YogaKit/UIView+Yoga.h"


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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
        
        [self addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        
        _placeholderLabel = label;
    }
    return self;
}
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"font"];
    [self removeObserver:self forKeyPath:@"frame"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

+ (UIColor *)defaultColor
{
    static UIColor *color = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @" ";
        color = [textField valueForKeyPath:@"_placeholderLabel.textColor"];
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

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderLabel.textColor = placeholderColor;
    [self updatePlaceholder];
}

- (UIColor *)placeholderColor
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
    
    [self insertSubview:_placeholderLabel atIndex:0];
    
    if (self.needAdjustFont) {
        self.placeholdLabel.font = self.font;
        self.needAdjustFont = NO;
    }
    
    CGFloat  lineFragmentPadding =  self.textContainer.lineFragmentPadding;
    UIEdgeInsets contentInset = self.textContainerInset;
    
    CGFloat labelX = lineFragmentPadding + contentInset.left;
    CGFloat labelY = contentInset.top;
    if (self.location.x != 0 || self.location.y != 0) {
        if (self.location.x < 0 || self.location.x > CGRectGetWidth(self.bounds) - lineFragmentPadding - contentInset.right || self.location.y< 0) {
        }else{
            labelX += self.location.x;
            labelY += self.location.y;
        }
    }
    CGFloat labelW = CGRectGetWidth(self.bounds)  - contentInset.right - labelX;
    CGFloat labelH = [self.placeholdLabel sizeThatFits:CGSizeMake(labelW, MAXFLOAT)].height;
    _placeholderLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
}


#pragma mark - observer font KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"font"])
    {
        self.needAdjustFont = YES;
        [self updatePlaceholder];
    }else if([keyPath isEqualToString:@"frame"]){

        [self updatePlaceholder];

    }else{

        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - export attr

FLEXSET(placeholder)
{
    self.placeholder = sValue ;
}
FLEXSET(placeholderColor)
{
    UIColor* clr = colorFromString(sValue,owner) ;
    if(clr)
        self.placeholderColor = clr ;
}
@end
