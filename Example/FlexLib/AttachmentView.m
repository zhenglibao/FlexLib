/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "AttachmentView.h"

@interface AttachmentView()
{
    UIView* _attachParent;
}
@end

@implementation AttachmentView
-(void)onInit{
    self.flexibleWidth = NO;
    self.flexibleHeight = YES;
}

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
                                 @"width",@"100%",
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
