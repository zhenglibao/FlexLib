/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "FlexHttpVC.h"
#import "FlexUtils.h"
#import "FlexNode.h"
#import "FlexSetPreviewVC.h"

@interface FlexHttpViewerVC : FlexBaseVC

@property (nonatomic,copy) NSString* url;

@end

@implementation FlexHttpViewerVC

/*
 * 重写以防止变量绑定异常导致查看xml时有内存泄漏
 */
- (void)setValue:(id)value forKey:(NSString *)key
{
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:FlexLocalizeString(@"refresh") style:UIBarButtonItemStylePlain target:self action:@selector(reloadFlexView)];
    
    [self viewFlexWithUrl:self.url];
}
- (void)reloadFlexView
{
     [self viewFlexWithUrl:self.url];
}
-(void)viewFlexWithUrl:(NSString*)url
{
    __weak FlexHttpViewerVC* weakSelf = self;
    
    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue,^{
        
        NSError* error = nil;
        NSData* data = FlexFetchHttpRes(url, &error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf onViewFlex:data error:error];
        });
    });
}
-(void)onViewFlex:(NSData*)flexData
            error:(NSError*)error
{
    if(flexData!=nil){
        
        [self resetByFlexData:flexData];
        
    }else{
        NSString* status;
        if(error==nil){
            status = @"Unknown error";
        }else{
            status = [error localizedDescription];
        }
        FlexShowToast(status, 1.0f);
    }
}

@end


@interface FlexHttpVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _table;
    UITextField* _pathLabel;
    UILabel* _statusBar;
    
    NSArray* _layouts;
    BOOL _bLoading;
}

@end

@implementation FlexHttpVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = FlexLocalizeString(@"HttpVCTitle");
    
    
    _table.delegate = self;
    _table.dataSource = self;
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(NSBundle*)bundleForStrings
{
    return FlexBundle();
}

-(NSString*)getFlexName
{
    NSString* flexName = NSStringFromClass([FlexHttpVC class]);
    
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[FlexHttpVC class]];
    NSString *resourcePath = [frameworkBundle pathForResource:flexName ofType:@"xml" inDirectory:@"FlexLib.bundle"];
    
    return resourcePath;
}
- (void)reloadFlexView
{
    [self loadData];
}
- (NSArray<UIKeyCommand *> *)keyCommands
{
    NSMutableArray* result = [[super keyCommands]mutableCopy];
    
    // close: control + w
    [result addObject:[UIKeyCommand keyCommandWithInput:@"w"
                                          modifierFlags:UIKeyModifierControl
                                                 action:@selector(closeViewer)]];
    return result;
}
-(void)closeViewer
{
    if(self.navigationController.childViewControllers.count>1){
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


+(void)presentInVC:(UIViewController*)parentVC{
    
    FlexHttpVC* vc = [[FlexHttpVC alloc]init];
    
    if(parentVC.navigationController != nil){
        [parentVC.navigationController pushViewController:vc animated:YES];
    }else{
        UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
        
        [parentVC presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _layouts.count/2 ;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *identifier = @"HttpCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSString* name = [_layouts objectAtIndex:indexPath.row*2+1];
    cell.textLabel.text = name;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    if([name hasSuffix:@"/"]){
        cell.textLabel.textColor = colorFromString(@"#0921ea", nil);
    }else if([name hasSuffix:@".xml"]){
        cell.textLabel.textColor = colorFromString(@"#157efb", nil);
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
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
    
    NSString* href = [_layouts objectAtIndex:indexPath.row*2];
    NSString* name = [_layouts objectAtIndex:indexPath.row*2+1];
    NSString* url = self.url ;
    
    if(![url hasSuffix:@"/"])
        url = [url stringByAppendingString:@"/"];
    url = [url stringByAppendingString:href];
        
    if([href hasSuffix:@"/"]){
        self.url = url;
        [self loadData];
    }else{
        FlexHttpViewerVC* vc = [[FlexHttpViewerVC alloc]init];
        vc.url = url;
        vc.navigationItem.title = name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - load data
/**
 * 返回提取内容，<a href="path">title</a>
 * 将path和title一对一加入到数组中返回
 */
+(NSMutableArray*)extractLinks:(NSString*)data
{
    NSString * patton = @"<a href=\"([^<>]+)\">([^<>]+)</a>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:patton options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray* array = [regex matchesInString:data options:0 range:NSMakeRange(0, data.length)];
    
    NSString *link,*name = nil;
    NSMutableArray* result = [NSMutableArray array];
    
    for (NSTextCheckingResult* b in array)
    {
        link = [data substringWithRange:[b rangeAtIndex:1]];
        name = [data substringWithRange:[b rangeAtIndex:2]];
        
        if([name hasSuffix:@"/"] || [name hasSuffix:@".xml"])
        {
            [result addObject:link];
            [result addObject:name];
        }
    }
    return result;
}
-(void)loadInBackground:(NSString*)url
{
    NSError* error = nil;
    NSData* data = FlexFetchHttpRes(url, &error);
    NSMutableArray* links = nil;
    
    if(data != nil){
        NSString* sdata = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        links = [FlexHttpVC extractLinks:sdata];
    }
    __weak FlexHttpVC* weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf onLoadFinish:links error:error];
    });
    
}
-(void)onLoadFinish:(NSMutableArray*)links
              error:(NSError*)error
{
    _bLoading = NO;
    
    NSString* status ;
    if(links != nil){
        status = @"Success";
        
        _layouts = links;
        [_table reloadData];
    }else{
        if(error==nil){
            status = @"Unknown error";
        }else{
            status = [error localizedDescription];
        }
    }
    _statusBar.text = status;
}
-(void)loadData
{
    NSString* url = self.url;
    if(url == nil){
        url = FlexGetPreviewBaseUrl();
        if(url == nil)
            return;
    }
    if(_bLoading)
        return;
    _bLoading = YES;
    
    self.url = url;
    _pathLabel.text = url;
    _statusBar.text = @"loading...";
    
    __weak FlexHttpVC* weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue,^{
        [weakSelf loadInBackground:url];
    });
}

#pragma mark - actions

-(void)onGoUp
{
    NSString* s = [self.url stringByDeletingLastPathComponent];
    if(s.length>7){
        s = [s stringByReplacingOccurrencesOfString:@":/" withString:@"://"];
        self.url = s;
        [self loadData];
    }
}
-(void)onGoHome
{
    self.url = FlexGetPreviewBaseUrl();
    [self loadData];
}
-(void)onRefresh
{
    [self loadData];
}
-(void)onSetting
{
    [FlexSetPreviewVC presentInVC:self];
}
@end
