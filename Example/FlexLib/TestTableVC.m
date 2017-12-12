/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */



#import "TestTableVC.h"
#import "TestTableCell.h"

@interface TestTableVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _table;
    UIView* close;
    TestTableCell* _cell;
    
    NSArray* _datas;
}

@end

@implementation TestTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _table.delegate = self ;
    _table.dataSource = self ;
    
    _datas =
  @[
    @{
        @"name": @"研发",
        @"type": @"一般周报",
        @"date": @"2013-5-11",
        @"title": @"测试费时代峰峻啥地方",
        @"content": @"我是东方啥地方世纪东方手机里",
    },
    @{
        @"name": @"名字",
        @"type": @"一般类型",
        @"date": @"2011-5-11 14:20",
        @"title": @"我是标题",
        @"content": @"登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
        },
    @{
        @"name": @"测试",
        @"type": @"一般类型",
        @"date": @"2011-5-11",
        @"title": @"我是标题",
        @"content": @"时代峰峻历史课带附件莱克斯顿解放路我是东方啥地方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快受打击了开放时间类库地方就是留点饭捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
        },
    @{
        @"name": @"测试",
        @"type": @"一般类型",
        @"date": @"2011-5-11",
        @"title": @"我是标题",
        @"content": @"this is test content, haha I need more text, can you input it ? more, more, more ………………",
        },
    @{
        @"name": @"测试",
        @"type": @"一般类型",
        @"date": @"2011-5-11",
        @"title": @"我是标题",
        @"content": @"this is test content, haha I need more text, can you input it ? more, more, more ………………this is test content, haha I need more text, can you input it ? more, more, more ………………this is test content, haha I need more text, can you input it ? more, more, more ………………",
        },
    @{
        @"name": @"测试",
        @"type": @"一般类型",
        @"date": @"2011-5-11",
        @"title": @"我是标题",
        @"content": @"我是东方啥地this is test content, haha I need more text, can you input it ? more, more, more ………………方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
        },
    @{
        @"name": @"测试",
        @"type": @"一般类型",
        @"date": @"2011-5-11",
        @"title": @"我是标题",
        @"content": @"我是东方啥地方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快啥阶段了开发建设路口带附件sjdfklsdjf捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
        },
    @{
        @"name": @"测试",
        @"type": @"一般类型",
        @"date": @"2011-5-11",
        @"title": @"我是标题",
        @"content": @"我是东方啥地方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
        },
    @{
        @"name": @"测试",
        @"type": @"一般类型",
        @"date": @"2011-5-11",
        @"title": @"我是标题",
        @"content": @"我是东方啥地方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
        },
    @{
        @"name": @"测试",
        @"type": @"一般类型",
        @"date": @"2011-5-11",
        @"title": @"我是标题",
        @"content": @"我是东方啥地方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
        },
    @{
        @"name": @"测试",
        @"type": @"一般类型",
        @"date": @"2011-5-11",
        @"title": @"我是标题",
        @"content": @"我是东方啥地方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
        },
    @{
        @"name": @"测试",
        @"type": @"一般类型",
        @"date": @"2011-5-11",
        @"title": @"我是标题",
        @"content": @"我是东方啥地方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
        },
    @{
        @"name": @"测试",
        @"type": @"一般类型",
        @"date": @"2011-5-11",
        @"title": @"我是标题",
        @"content": @"我是东方啥地方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
        },
    @{
        @"name": @"测试",
        @"type": @"一般类型",
        @"date": @"2011-5-11",
        @"title": @"我是标题",
        @"content": @"我是东方啥地方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
        },
    @{
        @"name": @"测试",
        @"type": @"一般类型",
        @"date": @"2011-5-11",
        @"title": @"我是标题",
        @"content": @"我是东方啥地方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
        },
    @{
        @"name": @"测试",
        @"type": @"一般类型",
        @"date": @"2011-5-11",
        @"title": @"我是标题",
        @"content": @"我是东方啥地方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
        },
  ];
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
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count ;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *identifier = @"TestTableCellIdentifier";
    TestTableCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TestTableCell alloc]initWithFlex:nil reuseIdentifier:identifier];
    }
    [cell setData:_datas[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_cell==nil){
        _cell = [[TestTableCell alloc]initWithFlex:nil reuseIdentifier:nil];
    }
    [_cell setData:_datas[indexPath.row]];
    CGFloat h = [_cell heightForWidth:_table.frame.size.width];
    
    //NSLog(@"height %ld = %f  text=%@",indexPath.row,h,[_datas[indexPath.row]objectForKey:@"content"]);
    return h;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
