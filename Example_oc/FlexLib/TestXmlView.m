//
//  TestXmlView.m
//  FlexLib_Example
//
//  Created by 郑立宝 on 2019/2/2.
//  Copyright © 2019年 zhenglibao. All rights reserved.
//

#import "TestXmlView.h"

@interface TestXmlView()
{
    UIView* _attachParent;
}
@end

@implementation TestXmlView


-(void)removeCell:(UIGestureRecognizer*)sender
{
    UIView* cell = sender.view;
    [cell removeFromSuperview];
    [_attachParent markDirty];
}
-(void)onAddAttachment
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeCell:)];
    UIView* cell = [[UIView alloc]init];
    
    [_attachParent addSubview:cell];
    
    [cell enableFlexLayout:YES];
    [cell addGestureRecognizer:tap];
    [cell setLayoutAttrStrings:@[
                                 @"width",@"80%",
                                 @"height",@"44",
                                 @"marginTop",@"5",
                                 @"marginBottom",@"5",
                                 @"alignItems",@"center",
                                 @"justifyContent",@"center",
                                 ]];
    [cell setViewAttr:@"bgColor" Value:@"#e5e5e5"];
    
    UILabel* label=[UILabel new];
    [cell addSubview:label];
    [label enableFlexLayout:YES];
    [label setViewAttrStrings:@[
                                @"fontSize",@"16",
                                @"color",@"red",
                                @"text",@"点我删除",
                                ]];
    
    [_attachParent markDirty];
}

@end
