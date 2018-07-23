/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "FlexLayoutViewerVC.h"
#import "FlexBaseVC.h"
#import "FlexUtils.h"


@interface FlexViewer : FlexBaseVC
@end

@implementation FlexViewer
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareInputs];
}
/*
 * 重写以防止变量绑定异常导致查看xml时有内存泄漏
 */
- (void)setValue:(id)value forKey:(NSString *)key
{
}
@end

@interface FlexLayoutViewerVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _table;
    
    NSArray* _layouts;
}

@end

@implementation FlexLayoutViewerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = FlexLocalizeString(@"layoutVCTitle");
    
    
    _table.delegate = self;
    _table.dataSource = self;
    
    [self loadData];
}
-(NSBundle*)bundleForStrings
{
    return FlexBundle();
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSArray<UIKeyCommand *> *)keyCommands
{
    return @[
             // close
             [UIKeyCommand keyCommandWithInput:@"w"
                                 modifierFlags:UIKeyModifierControl
                                        action:@selector(closeViewer)],
             ];
}
-(void)closeViewer
{
    if(self.navigationController.childViewControllers.count>1){
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)loadData
{
    NSArray* items = [[NSBundle mainBundle]pathsForResourcesOfType:@"xml" inDirectory:nil];
    
    NSMutableArray* layouts = [NSMutableArray arrayWithCapacity:items.count];
    for (NSString* item in items) {
        [layouts addObject:item.lastPathComponent];
    }
    _layouts = [layouts copy];
    
    [_table reloadData];
}

#pragma mark - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _layouts.count ;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *identifier = @"FlexViewerCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [_layouts objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = @"";
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString* name = [_layouts objectAtIndex:indexPath.row];
    name = [name stringByDeletingPathExtension];
    
    Class class = NSClassFromString(name);
    if(class == nil || ![class isSubclassOfClass:[UIViewController class]])
    {
        class = [FlexViewer class];
    }
    
    UIViewController* vc ;
    if( [class isSubclassOfClass:[FlexBaseVC class]] ){
        vc = [[class alloc]initWithFlexName:name];
    }else{
        vc = [[class alloc]init];
    }
    vc.navigationItem.title = name;
    [self.navigationController pushViewController:vc animated:YES];
}

+(void)presentInVC:(UIViewController*)parentVC{
    NSString* flexName = NSStringFromClass([FlexLayoutViewerVC class]);
    
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[FlexLayoutViewerVC class]];
    NSString *resourcePath = [frameworkBundle pathForResource:flexName ofType:@"xml" inDirectory:@"FlexLib.bundle"];
    
    FlexLayoutViewerVC* vc = [[FlexLayoutViewerVC alloc]initWithFlexName:resourcePath];
    
    if(parentVC.navigationController != nil){
        [parentVC.navigationController pushViewController:vc animated:YES];
    }else{
        UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
        
        [parentVC presentViewController:nav animated:YES completion:nil];
    }
}
@end
