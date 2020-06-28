//
//  
//  BossZP
//
//  Created by 郑立宝 on 2018/5/24.
//  Copyright © 2018年 com.dlnu.*. All rights reserved.
//
#import "FlexLib.h"

@interface NSFont (Extension)

+ (nonnull NSFont *)CustomFontGBKSize:(float)size;

///苹方 普通
+ (nonnull NSFont *)PSCFontSize:(float)size;
///苹方 粗
+ (nonnull NSFont *)PSCBoldFontSize:(float)size;
///苹方 中粗
+ (nonnull NSFont *)PSCMediumFontSize:(float)size;
///苹方 细
+ (nonnull NSFont *)PSCLightFontSize:(float)size;
///看准字体
+ (nonnull NSFont *)KZRegularFontSize:(float)size;

@end


@implementation NSFont (Extension)

+ (nonnull NSFont *)CustomFontGBKSize:(float)size {
    //iOS8暂时没有苹方字体
    return [NSFont systemFontOfSize:size];
    //    return [NSFont fontWithName:@"PingFang SC" size:size];
}

+ (nonnull NSFont *)PSCFontSize:(float)size {
    {
        NSFont *font = [NSFont fontWithName:@"PingFangSC-Regular" size:size];
        if (font) {
            return font;
        }
    }
    return [NSFont systemFontOfSize:size];
}

+ (nonnull NSFont *)PSCBoldFontSize:(float)size {
    
    {
        NSFont *font = [NSFont fontWithName:@"PingFangSC-Semibold" size:size];
        if (font) {
            return font;
        }
    }
    
    return [NSFont boldSystemFontOfSize:size];
    
}

+ (nonnull NSFont *)PSCMediumFontSize:(float)size {
    
    {
        NSFont *font = [NSFont fontWithName:@"PingFangSC-Medium" size:size];
        if (font) {
            return font;
        }
    }
    return [NSFont boldSystemFontOfSize:size];
    
}

+ (nonnull NSFont *)PSCLightFontSize:(float)size {
        NSFont *font = [NSFont fontWithName:@"PingFangSC-Light" size:size];
        if (font) {
            return font;
        }
    
    return [NSFont systemFontOfSize:size];
}

///看准字体
+ (nonnull NSFont *)KZRegularFontSize:(float)size {
    NSFont *font = [NSFont fontWithName:@"kanzhun" size:size];
    if (font) {
        return font;
    }
    return [NSFont boldSystemFontOfSize:size];
}

@end

void asyncLoadImage(UIImageView* imageView,NSString* imageName,NSBundle* bundle)
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSImage* img = [[NSBundle mainBundle] imageForResource:imageName];
        if(img==nil)
            return ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = img;
        });
    });
}


#pragma mark - UIImageView

@interface UIImageView (Flex)
@end

@implementation UIImageView (Flex)
FLEXSET(asyncSource)
{
    asyncLoadImage(self,
                   sValue,
                   [owner bundleForImages]);
}

@end

#pragma mark - UIView

@interface UIView (Flex)

@end

@implementation UIView (Flex)

FLEXSET(userStyle) {
}

FLEXSET(bzFont)
{
    SEL sel = @selector(setFont:);
    NSMethodSignature* sig = [self.class instanceMethodSignatureForSelector:sel];
    if(sig == nil)
    {
        NSLog(@"Flexbox: no setFont: in class %@",[self class]);
        return ;
    }
    
    NSFont *font = [self bzFontWithFontNameString:sValue];
    if(font == nil){
        return;
    }
    
    @try{
        
        NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig] ;
        [inv setTarget:self];
        [inv setSelector:sel];
        [inv setArgument:&font atIndex:2];
        
        [inv invoke];
    }@catch(NSException* e){
        NSLog(@"Flexbox: setFont: called failed.");
    }
}

- (NSFont *)bzFontWithFontNameString:(NSString *)fontNameString {
    NSFont *font = nil;
    NSArray* ary = [fontNameString componentsSeparatedByString:@"|"];
    
    if (ary.count == 0) {
        return nil;
    }
    
    if(ary.count==1){
        CGFloat fontSize = [ary.firstObject floatValue]<0.1?14.0f:[ary.firstObject floatValue];
        return [NSFont systemFontOfSize:fontSize];
    }
    
    NSString* fontName = ary.firstObject;
    CGFloat fontSize = [ary[1] floatValue];
    
    if ([fontName containsString:@"Medium"]) {
        font = [NSFont PSCMediumFontSize:fontSize];
    } else if ([fontName containsString:@"Regular"]) {
        font = [NSFont PSCFontSize:fontSize];
    } else if ([fontName containsString:@"Semibold"]) {
        font = [NSFont PSCBoldFontSize:fontSize];
    } else if ([fontName containsString:@"Light"]) {
        font = [NSFont PSCLightFontSize:fontSize];
    } else if ([fontName containsString:@"Kanzhun"])  {
        font = [NSFont KZRegularFontSize:fontSize];
    } else {
        font = [NSFont systemFontOfSize:fontSize];
    }
    return font;
}
@end


