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

static FlexMapColor gMapColor = NULL;

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

NSColor* systemColor(NSString* clr)
{
    NSString* methodDesc = [NSString stringWithFormat:@"%@Color",clr];
    
    SEL sel = NSSelectorFromString(methodDesc) ;
    if(sel == nil)
    {
        NSLog(@"Flexbox: NSColor no method %@",methodDesc);
        return nil;
    }
    
    NSMethodSignature* sig = [NSColor methodSignatureForSelector:sel];
    if(sig == nil)
    {
        NSLog(@"Flexbox: NSColor no method %@",methodDesc);
        return nil;
    }
    
    @try{
        
        NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig] ;
        [inv setTarget:[NSColor class]];
        [inv setSelector:sel];
        [inv invoke];
        
        NSColor* result;
        [inv getReturnValue:&result];
        return result;
    }@catch(NSException* e){
        NSLog(@"Flexbox: %@ called failed.",methodDesc);
    }
    return nil;
}
NSColor* colorFromString(NSString* clr,
                         NSObject* owner)
{
    if(![clr hasPrefix:@"#"]){
        
        {
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
    
    if (gMapColor!=NULL) {
        gMapColor(&r,&g,&b,&a);
    }
    
    return [NSColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:a / 255.0f];
}

NSFont* fontFromString(NSString* fontStr)
{
    NSArray* ary = [fontStr componentsSeparatedByString:@"|"];
    CGFloat fontSize = 17;
    NSString* fontName = nil ;
    NSFont* font = nil;
    
    if(ary.count==1)
    {
        fontSize = [ary.firstObject floatValue];
        
    }else if( ary.count>=2 ){
        
        fontName = ary.firstObject ;
        fontSize = [ary[1]floatValue];
    }
    if(fontSize<=0){
        fontSize = 17;
    }
    
    if([@"bold" compare:fontName]==NSOrderedSame)
    {
        font = [NSFont boldSystemFontOfSize:fontSize];
    }
    else if([@"italic" compare:fontName]==NSOrderedSame){
        
        //font = [NSFont italicSystemFontOfSize:fontSize];
    
    }else{
        font = [NSFont fontWithName:fontName size:fontSize];
    }
    
    if( font==nil ){
        font = [NSFont systemFontOfSize:fontSize];
        
//        if( font==nil ){
//            font = [NSFont preferredFontForTextStyle:UIFontTextStyleBody];
//        }
    }
    return font;
}

NSString* Int2String(int value,
                     NameValue table[],
                     int total)
{
    for (int i=0; i<total; i++) {
        if (value==table[i].value) {
            return [[NSString alloc]initWithUTF8String:table[i].name];
        }
    }
    return nil;
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

/*
 * 判断是否是iPhone X的设备，也包括iPhone XS和iPhone XS等
 * iPhone X指的是上边有刘海屏，下边有安全区的设备
 */
BOOL IsIphoneX(void)
{
    return NO;
}
BOOL IsPortrait(void)
{
    return YES;
}

double GetAccurateSecondsSince1970()
{
    struct timeval now ;
    gettimeofday(&now,NULL);
    double tf = now.tv_sec + (double)(now.tv_usec)/1000000.0 ;
    
    return tf;
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

void FlexSetMapColor(FlexMapColor mapFunc)
{
    gMapColor = mapFunc;
}
FlexMapColor FlexGetMapColor(void)
{
    return gMapColor;
}

static NSImage* loadImageResource(NSString* imgName,NSObject* owner)
{
    return [[owner bundleForRes]imageForResource:imgName];
}

static FlexImgLoadFunc gImgLoadFunc = loadImageResource;

void FlexSetImgLoadFunc(FlexImgLoadFunc imgLoadFunc)
{
    if (imgLoadFunc==NULL) {
        gImgLoadFunc = loadImageResource;
    } else {
        gImgLoadFunc = imgLoadFunc;
    }
}
FlexImgLoadFunc FlexGetImgLoadFunc(void)
{
    return gImgLoadFunc;
}
NSImage* FlexLoadImage(NSString* imgName,NSObject* owner)
{
    return gImgLoadFunc(imgName,owner);
}
