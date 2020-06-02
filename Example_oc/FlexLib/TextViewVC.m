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
    
    UIView* _imgParent;
}

@end

@implementation TextViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"TextView自适应高度/动态添加删除view";
    [self prepareInputs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)removeCell:(UIGestureRecognizer*)sender
{
    UIView* cell = sender.view;
    [cell removeFromSuperview];
    [_imgParent markDirty];
}
-(void)onAddImage
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeCell:)];
    UIView* cell = [[UIView alloc]init];
    
    [cell enableFlexLayout:YES];
    [cell addGestureRecognizer:tap];
    
    [cell setLayoutAttrStrings:@[
                                 @"width",@"60",
                                 @"margin",@"2",
                                 @"height",@"40",
                                 @"alignItems",@"center",
                                 @"justifyContent",@"center",
                                 ]];
    [cell setViewAttr:@"bgColor" Value:@"#e5e5e5"];
    [cell setViewAttr:@"borderRadius" Value:@"10"];
    [_imgParent insertSubview:cell atIndex:0];
    
    UILabel* label=[UILabel new];
    [label enableFlexLayout:YES];
    [label setViewAttrStrings:@[
                                @"fontSize",@"16",
                                @"color",@"red",
                                @"text",@"删除",
                                ]];
    [cell addSubview:label];
    
    [_imgParent markDirty];
}
@end
