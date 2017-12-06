//
//  FlexUtils.m
//  Expecta
//
//  Created by zhenglibao on 2017/12/5.
//

#import "FlexUtils.h"

static NSString* _gclrs[]=
{
    @"black",   @"#0",
    @"white",   @"#ffffff",
    @"red",     @"#ff0000",
    @"green",   @"#00ff00",
    @"blue",    @"#0000ff",
};

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
