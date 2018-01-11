/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "FlexUtils.h"
#import <sys/time.h>
#import "FlexBaseVC.h"
#import "FlexNode.h"

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
UIColor* colorFromString(NSString* clr,
                         NSObject* owner)
{
    if(![clr hasPrefix:@"#"]){
        
        if([clr rangeOfString:@"."].length>0){
            // 这是一张图片
            UIImage* image = [UIImage imageNamed:clr inBundle:[owner bundleForImages] compatibleWithTraitCollection:nil];
            if(image == nil){
                NSLog(@"Flexbox: image %@ for color load failed",clr);
                return nil;
            }
            return [UIColor colorWithPatternImage:image];
            
        }else{
            int total = sizeof(_gclrs)/sizeof(NSString*) ;
            for(int i=0;i<total;i+=2){
                if([clr compare:_gclrs[i] options:NSCaseInsensitiveSearch]==0)
                {
                    clr = _gclrs[i+1];
                    break;
                }
            }
        }
    }
    if(![clr hasPrefix:@"#"]){
        NSLog(@"Flexbox: unrecognized color format %@",clr);
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
    //增加数字检测, 支持正整数
    if(s[0]>='0' && s[0]<='9'){
        return atoi(s);
    }
    
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
int NSString2GroupInt(NSString* s,
                      NameValue table[],
                      int total)
{
    int result = 0;
    NSArray* ary = [s componentsSeparatedByString:@"|"];
    NSCharacterSet* white = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    for (NSString* part in ary) {
        NSString* ps = [part stringByTrimmingCharactersInSet:white];
        if(ps.length==0)
            continue;
        
        int tmp = NSString2Int(ps,
                               table,
                               total);
        result |= tmp ;
    }
    return result;
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

double GetAccurateSecondsSince1970()
{
    struct timeval now ;
    gettimeofday(&now,NULL);
    double tf = now.tv_sec + (double)(now.tv_usec)/1000000.0 ;
    
    return tf;
}

static NSString* gBaseUrl = nil;

void FlexSetPreviewBaseUrl(NSString* filexName)
{
    gBaseUrl = [filexName copy];
}
NSData* FlexFetchLayoutFile(NSString* flexName,NSError** outError)
{
    if(gBaseUrl.length==0){
        NSLog(@"Flexbox: preview base url not set");
        return nil;
    }
    NSString* url = [NSString stringWithFormat:@"%@%@.xml",gBaseUrl,flexName];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil)
    {
        return data;
    }else if(outError != NULL){
        *outError = error;
    }
    return nil;
}
NSBundle* FlexBundle(void)
{
    NSString* flexPath = [[NSBundle bundleForClass:[FlexBaseVC class]]resourcePath];
    flexPath = [flexPath stringByAppendingPathComponent:@"FlexLib.bundle"];
    return [NSBundle bundleWithPath:flexPath];
}
FlexLanuage FlexGetLanguage(void)
{
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    if([languageName rangeOfString:@"zh-"].length>0){
        return flexChinese;
    }
    return flexEnglish;
}
