/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "TextViewVC.h"

@interface TextViewVC ()
{
    UIScrollView* scroll;
}

@end

@implementation TextViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"TextView Demo";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)onPrev
{
    NSArray* all = [self.view findAllInputs];
    UIView* current = [self.view findFirstResponder];
    
    NSUInteger index = [all indexOfObject:current];
    if( index!=NSNotFound ){
        if(index>0){
            [all[index-1] becomeFirstResponder];
        }
    }
}
-(void)onNext
{
    NSArray* all = [self.view findAllInputs];
    UIView* current = [self.view findFirstResponder];
    
    NSUInteger index = [all indexOfObject:current];
    if( index!=NSNotFound ){
        if(index+1<all.count){
            [all[index+1] becomeFirstResponder];
        }
    }
}
@end
