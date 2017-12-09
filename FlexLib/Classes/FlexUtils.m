/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */


#import "FlexUtils.h"

static NSString* _gclrs[]=
{
    @"black",   @"#0",
    @"white",   @"#ffffff",
    @"clear",   @"#00000000",
    @"darkGray",@"#555555",
    @"lightGray",@"#aaaaaa",
    @"gray",    @"#808080",
    @"red",     @"#ff0000",
    @"green",   @"#00ff00",
    @"blue",    @"#0000ff",
    @"cyan",    @"#00ffff",
    @"yellow",  @"#ffff00",
    @"magenta", @"#ff00ff",
    @"orange",  @"#ff8000",
    @"purple",  @"#800080",
    @"brown",   @"#996633",
};

UIColor* systemColor(NSString* clr)
{
    NSString* methodDesc = [NSString stringWithFormat:@"%@Color",clr];
    
    SEL sel = NSSelectorFromString(methodDesc) ;
    if(sel == nil)
    {
        NSLog(@"Flexbox: UIColor no method %@",methodDesc);
        return nil;
    }
    
    NSMethodSignature* sig = [UIColor methodSignatureForSelector:sel];
    if(sig == nil)
    {
        NSLog(@"Flexbox: UIColor no method %@",methodDesc);
        return nil;
    }
    
    @try{
        
        NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig] ;
        [inv setTarget:[UIColor class]];
        [inv setSelector:sel];
        [inv invoke];
        
        UIColor* result;
        [inv getReturnValue:&result];
        return result;
    }@catch(NSException* e){
        NSLog(@"Flexbox: %@ called failed.",methodDesc);
    }
    return nil;
}
UIColor* colorFromString(NSString* clr)
{
    if(![clr hasPrefix:@"#"]){
        int total = sizeof(_gclrs)/sizeof(NSString*) ;
        for(int i=0;i<total;i+=2){
            if([clr compare:_gclrs[i] options:NSCaseInsensitiveSearch]==0)
            {
                clr = _gclrs[i+1];
                break;
            }
        }
    }
    if(![clr hasPrefix:@"#"]){
        NSLog(@"Flexbox: unrecognized color format");
        return nil;
    }
    
    NSString *typeColor = [clr stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    
    NSScanner *scanner = [NSScanner scannerWithString:typeColor];
    unsigned hex;
    [scanner scanHexInt:&hex];
    
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    int a = clr.length>7 ? (hex >> 24)& 0xFF : 255 ;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:a / 255.0f];
}


int String2Int(const char* s,
               NameValue table[],
               int total)
{
    for(int i=0;i<total;i++){
        if(strcmp(s,table[i].name)==0){
            return table[i].value;
        }
    }
    return table[0].value;
}
int NSString2Int(NSString* s,
                 NameValue table[],
                 int total)
{
    const char* c = [s cStringUsingEncoding:NSASCIIStringEncoding];
    return String2Int(c, table, total);
}

BOOL String2BOOL(NSString* s)
{
    return [s compare:@"true" options:NSDiacriticInsensitiveSearch]==NSOrderedSame;
}

BOOL IsIphoneX(void)
{
    static int iphoneX = -1;
    if(iphoneX < 0)
    {
        iphoneX = 0 ;
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
            
            UIScreen* screen = [UIScreen mainScreen];
            if([screen respondsToSelector:@selector(nativeBounds)])
            {
                if((int)[screen nativeBounds].size.height==2436)
                {
                    iphoneX = 1;
                }
            }
        }
    }
    return iphoneX;
}
BOOL IsPortrait(void)
{
    CGRect rcScreen = [[UIScreen mainScreen]bounds];
    return rcScreen.size.height > rcScreen.size.width ;
}
