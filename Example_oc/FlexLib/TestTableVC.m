/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

/*
 最新的例子使用评估高度，如下：
 
 _table.rowHeight = UITableViewAutomaticDimension;
 _table.estimatedRowHeight = 88;
 
 无需再重写
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 
 原来的方式仍然支持
 */


#import "TestTableVC.h"
#import "TestTableCell.h"

static NSString *identifier = @"TestTableCellIdentifier";

@interface TestTableVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _table;
    UIView* close;
    
    NSMutableArray* _datas;
    NSMutableArray* _heights;
    
    UILabel* content;   //header中的content
    
    TestTableCell* _heightCell;
}

@end

@implementation TestTableVC
- (void)dealloc
{
}
-(void)tableHeaderFrameChange
{
    [_table beginUpdates];
    [_table setTableHeaderView:_table.tableHeaderView];
    [_table endUpdates];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Table Demo";
    
    [_table registerClass:TestTableCell.class forCellReuseIdentifier:identifier];
    
    _table.delegate = self ;
    _table.dataSource = self ;
    _heightCell = [[TestTableCell alloc]initWithFlex:nil reuseIdentifier:nil];
    
    __weak TestTableVC* weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf loadInBackground];
    });
}
-(void)loadInBackground
{
    NSArray* datas =
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
          @"name": @"Amanda",
          @"type": @"一般类型",
          @"date": @"2011-5-11",
          @"title": @"我是标题",
          @"content": @"This is no good if you want a maximum of three lines, like the question implied. Guess I need to calculate the height of three lines and pass it in to the sizeWithFont function then.",
          },
      @{
          @"name": @"Karry",
          @"type": @"一般类型",
          @"date": @"2011-5-11",
          @"title": @"我是标题",
          @"content": @"great answer. I found this the most useful for multiline labels",
          },
      @{
          @"name": @"测试",
          @"type": @"一般类型",
          @"date": @"2011-5-11",
          @"title": @"我是标题",
          @"content": @"I found Ian L's answer best using -sizeWithFont:constrainedToSize:lineBreakMode:",
          },
      @{
          @"name": @"测试",
          @"type": @"一般类型",
          @"date": @"2011-5-11",
          @"title": @"我是标题",
          @"content": @"方式快捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多",
          },
      @{
          @"name": @"测试",
          @"type": @"一般类型",
          @"date": @"2011-5-11",
          @"title": @"我是标题",
          @"content": @"int lineCount = myLabel.numberOfLines;ount;",
          },
      @{
          @"name": @"测试",
          @"type": @"一般类型",
          @"date": @"2011-5-11",
          @"title": @"我是标题",
          @"content": @" Beware that for my situation, width of my label is fixed and I only need sizeToFit for adjusting height",
          },
      @{
          @"name": @"测试",
          @"type": @"一般类型",
          @"date": @"2011-5-11",
          @"title": @"我是标题",
          @"content": @"中华人民共和国北京市海淀区中关村768产业园，回龙观，你的地址？？？？",
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
          @"name": @"Amanda",
          @"type": @"一般类型",
          @"date": @"2011-5-11",
          @"title": @"我是标题",
          @"content": @"This is no good if you want a maximum of three lines, like the question implied. Guess I need to calculate the height of three lines and pass it in to the sizeWithFont function then.",
          },
      @{
          @"name": @"Karry",
          @"type": @"一般类型",
          @"date": @"2011-5-11",
          @"title": @"我是标题",
          @"content": @"great answer. I found this the most useful for multiline labels",
          },
      @{
          @"name": @"测试",
          @"type": @"一般类型",
          @"date": @"2011-5-11",
          @"title": @"我是标题",
          @"content": @"I found Ian L's answer best using -sizeWithFont:constrainedToSize:lineBreakMode:",
          },
      @{
          @"name": @"测试",
          @"type": @"一般类型",
          @"date": @"2011-5-11",
          @"title": @"我是标题",
          @"content": @"方式快捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多",
          },
      @{
          @"name": @"测试",
          @"type": @"一般类型",
          @"date": @"2011-5-11",
          @"title": @"我是标题",
          @"content": @"int lineCount = myLabel.numberOfLines;ount;",
          },
      @{
          @"name": @"测试",
          @"type": @"一般类型",
          @"date": @"2011-5-11",
          @"title": @"我是标题",
          @"content": @" Beware that for my situation, width of my label is fixed and I only need sizeToFit for adjusting height",
          },
      @{
          @"name": @"测试",
          @"type": @"一般类型",
          @"date": @"2011-5-11",
          @"title": @"我是标题",
          @"content": @"中华人民共和国北京市海淀区中关村768产业园，回龙观，你的地址？？？？",
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
      ];
    NSMutableArray* ary = [datas mutableCopy];
    for (int i=0;i<20; i++) {
        [ary addObjectsFromArray:datas];
    }
    
    NSMutableArray* heights = [NSMutableArray array];
    CGFloat tableWidth = [[UIScreen mainScreen]bounds].size.width;
    
    for (NSDictionary* data in ary)
    {
        [_heightCell setData:data ForHeight:YES];
        CGFloat h = [_heightCell heightForWidth:tableWidth];
        [heights addObject:[NSNumber numberWithFloat:h]];
    }
    
    // load
    dispatch_async(dispatch_get_main_queue(), ^{
        _datas = ary;
        _heights = heights;
        [self onLoadFinish];
    });
}
-(void)onLoadFinish
{
    __weak TestTableVC* weakSelf = self;
    
    CGRect rcFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0);
    FlexFrameView* header = [[FlexFrameView alloc]initWithFlex:@"TableHeader" Frame:rcFrame Owner:self];
    header.flexibleHeight = YES;
    content.text = @"这个例子演示了在后台线程计算布局高度：）这个例子在横竖屏切换时没有重新计算高度，因此切换横竖屏时会有问题：）";
    [header layoutIfNeeded];
    header.onFrameChange = ^(CGRect rc){
        [weakSelf tableHeaderFrameChange];
    };
    _table.tableHeaderView = header;
    
    _table.rowHeight = UITableViewAutomaticDimension;
    _table.estimatedRowHeight = 88;
    
    [_table reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapCloseAction
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count ;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TestTableCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    [cell setData:_datas[indexPath.row] ForHeight:NO];
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.row<_heights.count)
//        return [[_heights objectAtIndex:indexPath.row]floatValue];
//    return 0;
//}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
