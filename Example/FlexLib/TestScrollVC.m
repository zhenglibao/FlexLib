/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "TestScrollVC.h"

@interface TestScrollVC ()
{
    UIScrollView* scroll;
    UIView* close;
    
    UILabel* multilabel;
    UILabel* attrLabel;
}

@end

@implementation TestScrollVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Scroll Demo";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)tapCloseAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tapShow
{
    multilabel.hidden = !multilabel.isHidden;
    
    [multilabel.rootView layoutAnimation:0.3];
}

-(void)tapLabel:(id)sender
{
    FlexNode* node = [attrLabel getFlexNode:@"a1"];
    
    for (FlexAttr* attr in node.viewAttrs) {
        
        if( [attr.name isEqualToString:@"text"] ){
            NSString* newstr = [attr.value stringByAppendingString:@"abc"];
            [attrLabel setFlexAttrString:newstr name:@"a1"];
            NSLog(@"new string: %@",newstr);
            break;
        }
    }
    [attrLabel updateAttributeText];
    [attrLabel markDirty];
}

-(void)tapLabel
{
    NSLog(@"tap2");
}
-(void)tapText:(FlexClickRange*)click
{
    NSString* txt = [attrLabel.text substringWithRange:click.range];
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"点击了" message:txt delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
    [alertview show];
}

@end
