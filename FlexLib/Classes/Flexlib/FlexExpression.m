/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "FlexExpression.h"
#import "FlexUtils.h"

#pragma mark - 宏

static NSMutableDictionary* gMacros = nil;


static void FlexRegisterSystemMacro(void)
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    dict[@"ScreenWidth"] = ^double{
        return (double)[[UIScreen mainScreen] bounds].size.width;
    };
    
    dict[@"ScreenHeight"] = ^double{
        return (double)[[UIScreen mainScreen] bounds].size.height;
    };
    
    dict[@"NavHeight"] = ^double{
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
            return 64.;
        return IsIphoneX() ? 88. : 64.;
    };
    
    dict[@"ScreenScale"] = ^double{
        return (double)[UIScreen mainScreen].scale;
    };
    
    gMacros = dict;
}

void FlexRegisterMacro(NSString* macroName,FlexMacro value)
{
    if (gMacros==nil) {
        FlexRegisterSystemMacro();
    }
    @synchronized (gMacros) {
        [gMacros setValue:value forKey:macroName];
    }
}

/**
 * 获取宏的值
 */
double FlexGetMacroValue(NSString* macro)
{
    if (gMacros==nil) {
        FlexRegisterSystemMacro();
    }
    
    FlexMacro block = nil;
    @synchronized (gMacros) {
        block = [gMacros objectForKey:macro];
    }
    
    if (block) {
        return block();
    }
    NSLog(@"Flex: not supported macro - %@",macro);
    return 0;
}

#pragma mark - 表达式计算

static int getOpPriority(unichar c,BOOL leftOp)
{
    const int count = 7;
    const static unichar ops[] = {'+','-','*','/','(',')','='};
    const static int p1[] = {3,3,5,5,1,6,0};
    const static int p2[] = {2,2,4,4,6,1,0};
    
    for (int i=0; i<count; i++) {
        if (c==ops[i]) {
            return leftOp ? p1[i] : p2[i];
        }
    }
    NSCAssert(NO, @"unsupported operator %c",c);
    return 0;
}

@interface FlexExp : NSObject
{
    NSMutableArray* _numAry;
    NSMutableArray* _opAry;
}

-(double)calcExpression:(NSString*)expression;

@end

@implementation FlexExp

- (instancetype)init
{
    self = [super init];
    if (self) {
        _numAry = [NSMutableArray array];
        _opAry = [NSMutableArray array];
    }
    return self;
}

-(double)calcExpression:(NSString*)expression
{
    if(![self scanExpression:expression] || _numAry.count!=1){
        NSLog(@"Flex: wrong expression: %@",expression);
        return NAN;
    }
    
    return [_numAry.firstObject doubleValue];
}

-(BOOL)scanExpression:(NSString*)expression
{
    BOOL hasNum = NO;
    for (NSUInteger i=0; i<expression.length; i++)
    {
        unichar c = [expression characterAtIndex:i];
        
        if (c=='('){
            if(hasNum)
                return NO;
            
            if(![self parseOperator:c])
                return NO;
            
            hasNum = NO;
        }else if(c==')')
        {
            if(!hasNum)
                return NO;
            
            if(![self parseOperator:c])
                return NO;
            hasNum = YES;
            
        }else if(c=='*' || c=='/')
        {
            if (!hasNum) {
                return NO;
            }
            
            if(![self parseOperator:c])
                return NO;
            hasNum = NO;
        }else if(c=='+'||
                 c=='-')
        {
            if (hasNum) {
                if(![self parseOperator:c])
                    return NO;
                hasNum = NO;
                
            }else if(_opAry.count==0 || [_opAry.lastObject charValue]=='('){

                [_numAry addObject:@(0)];
                [_opAry addObject:@(c)];
                hasNum = NO;

            } else if(i>=expression.length-1){
                
                return NO;
                
            } else if(isalnum([expression characterAtIndex:i+1])||
                      [expression characterAtIndex:i+1]=='.') {
                
                i = [self parseNumber:expression from:i]-1;
                hasNum = YES;
            } else{
                return NO;
            }
            
        }else if(isspace(c)){
            
        }else{
            if(hasNum)
                return NO;
            
            i = [self parseNumber:expression from:i]-1;
            hasNum = YES;
        }
    }
    return [self parseOperator:'='];
}
-(BOOL)parseOperator:(unichar)op
{
    if (_opAry.count==0) {
        if (op=='=') {
            return _numAry.count!=0;
        }
        
        [_opAry addObject:@(op)];
        return YES;
    }
    
    unichar leftOp = [_opAry.lastObject intValue];
    int pr = getOpPriority(op, NO);
    int pl = getOpPriority(leftOp, YES);
    
    if (pr > pl) {
        [_opAry addObject:@(op)];
        return YES;
    }
        
    if (leftOp == '(') {
        [_opAry removeLastObject];
        return op==')';
    }
    
    if(leftOp == ')'){
        return NO;
    }
    
    if (_numAry.count<2) {
        return NO;
    }
    
    double num1 = [[_numAry objectAtIndex:_numAry.count-2]doubleValue];
    double num2 = [[_numAry lastObject]doubleValue];
    
    double result ;
    switch (leftOp) {
        case '+':
            result = num1 + num2;
            break;
        case '-':
            result = num1 - num2;
            break;
        case '*':
            result = num1 * num2;
            break;
        case '/':
            result = num1 / num2;
            break;
        default:
            result=0;
            break;
    }
    [_opAry removeLastObject];
    [_numAry removeObjectsInRange:NSMakeRange(_numAry.count-2, 2)];
    [_numAry addObject:@(result)];
    if (op=='=' && _opAry.count==0) {
        return YES;
    }
    return [self parseOperator:op];
}
-(NSUInteger)parseNumber:(NSString*)expression from:(NSUInteger)from
{
    unichar firstChar = [expression characterAtIndex:from];
    NSUInteger index = from;
    if (firstChar=='+' || firstChar=='-')
    {
        index++;
        if(index >= expression.length){
            return index;
        }
    }
    
    unichar secondChar = [expression characterAtIndex:index];
    double value = 0 ;

    from = index;

    if (isalpha(secondChar)) {
        index++;
        while (index<expression.length && isalpha([expression characterAtIndex:index]))
        {
            index++;
        }
        NSString* macro = [expression substringWithRange:NSMakeRange(from, index-from)];
        value = FlexGetMacroValue(macro);
    }else{
        
        while (index<expression.length)
        {
            unichar c = [expression characterAtIndex:index];
        
            if (!isnumber(c) && c!='.' && c!='e' && c!='E')
            {
                break;
            }
            index++;
        }
        if (index==from) {
            NSLog(@"Flex: wrong character 0x%0x for expression",(int)[expression characterAtIndex:from]);
            return from+1;
        }
        NSString* s = [expression substringWithRange:NSMakeRange(from, index-from)];
        value = [s doubleValue];
    }
    if (firstChar=='-') {
        value = -value;
    }
    [_numAry addObject:@(value)];
    return index;
}
@end


double FlexCalcExpression(NSString* expression)
{
    FlexExp* exp = [[FlexExp alloc]init];
    return [exp calcExpression:expression];
}
