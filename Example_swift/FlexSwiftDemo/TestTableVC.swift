/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit
import FlexLib

@objc(TestTableVC)
class TestTableVC: FlexBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @objc var _table : UITableView!
    @objc var _cell : TestTableCell!
    @objc var content : UILabel!
    
    var _datas = [
    [
    "name": "研发",
    "type": "一般周报",
    "date": "2013-5-11",
    "title": "测试费时代峰峻啥地方",
    "content": "我是东方啥地方世纪东方手机里",
    ],
    [
    "name": "名字",
    "type": "一般类型",
    "date": "2011-5-11 14:20",
    "title": "我是标题",
    "content": "登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
    ],
    [
    "name": "测试",
    "type": "一般类型",
    "date": "2011-5-11",
    "title": "我是标题",
    "content": "时代峰峻历史课带附件莱克斯顿解放路我是东方啥地方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快受打击了开放时间类库地方就是留点饭捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
    ],
    [
    "name": "测试",
    "type": "一般类型",
    "date": "2011-5-11",
    "title": "我是标题",
    "content": "this is test content, haha I need more text, can you input it ? more, more, more ………………",
    ],
    [
    "name": "测试",
    "type": "一般类型",
    "date": "2011-5-11",
    "title": "我是标题",
    "content": "this is test content, haha I need more text, can you input it ? more, more, more ………………this is test content, haha I need more text, can you input it ? more, more, more ………………this is test content, haha I need more text, can you input it ? more, more, more ………………",
    ],
    [
    "name": "测试",
    "type": "一般类型",
    "date": "2011-5-11",
    "title": "我是标题",
    "content": "我是东方啥地this is test content, haha I need more text, can you input it ? more, more, more ………………方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
    ],
    [
    "name": "Amanda",
    "type": "一般类型",
    "date": "2011-5-11",
    "title": "我是标题",
    "content": "This is no good if you want a maximum of three lines, like the question implied. Guess I need to calculate the height of three lines and pass it in to the sizeWithFont function then.",
    ],
    [
    "name": "Karry",
    "type": "一般类型",
    "date": "2011-5-11",
    "title": "我是标题",
    "content": "great answer. I found this the most useful for multiline labels",
    ],
    [
    "name": "测试",
    "type": "一般类型",
    "date": "2011-5-11",
    "title": "我是标题",
    "content": "I found Ian L's answer best using -sizeWithFont:constrainedToSize:lineBreakMode:",
    ],
    [
    "name": "测试",
    "type": "一般类型",
    "date": "2011-5-11",
    "title": "我是标题",
    "content": "方式快捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多",
    ],
    [
    "name": "测试",
    "type": "一般类型",
    "date": "2011-5-11",
    "title": "我是标题",
    "content": "int lineCount = myLabel.numberOfLines;ount;",
    ],
    [
    "name": "测试",
    "type": "一般类型",
    "date": "2011-5-11",
    "title": "我是标题",
    "content": " Beware that for my situation, width of my label is fixed and I only need sizeToFit for adjusting height",
    ],
    [
    "name": "测试",
    "type": "一般类型",
    "date": "2011-5-11",
    "title": "我是标题",
    "content": "中华人民共和国北京市海淀区中关村768产业园，回龙观，你的地址？？？？",
    ],
    [
    "name": "测试",
    "type": "一般类型",
    "date": "2011-5-11",
    "title": "我是标题",
    "content": "我是东方啥地方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
    ],
    [
    "name": "测试",
    "type": "一般类型",
    "date": "2011-5-11",
    "title": "我是标题",
    "content": "我是东方啥地方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快捷登录放暑假了多分数据代理费私搭乱建快放暑假了坑多分数据留点饭",
    ],
    [
    "name": "测试",
    "type": "一般类型",
    "date": "2011-5-11",
    "title": "我是标题",
    "content": "我是东方啥地方世纪东方手机里的放假了时代峰峻历史记录东方闪电交流方式快捷登录放暑假了多分数据代理费   私搭乱建快放暑假了坑多分数据留点饭",
    ]
    ]
    
    func tableHeaderFrameChange() -> Void {
        _table.beginUpdates()
        _table.tableHeaderView = _table.tableHeaderView
        _table.endUpdates()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "TableView Demo";
        
        _table.delegate = self;
        _table.dataSource = self;
        
        weak var weakSelf = self;
        
        let rc : CGRect = CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:0);
        let header : FlexFrameView = FlexFrameView.init(flex: "TableHeader", frame: rc, owner: self)!
        content.text = "这是一个高度可变的header,文字超长,后面的文本就是随机字符:)哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"
        header.flexibleHeight=true
        header.layoutIfNeeded()
        header.onFrameChange = { (rc)->Void in
            weakSelf?.tableHeaderFrameChange()
        }
        _table.tableHeaderView = header;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _datas.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier : String = "TestTableCellIdentifier"
        
        var cell : TestTableCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? TestTableCell
        
        if (cell == nil) {
            cell = TestTableCell(flex:nil,reuseIdentifier:identifier)
        }
        cell?.setData(data: _datas[indexPath.row],height: false)
        return cell!;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if(_cell==nil){
            _cell = TestTableCell(flex:nil,reuseIdentifier:nil)
        }
        _cell.setData(data: _datas[indexPath.row],height: true)
        return (_cell?.height(forWidth: tableView.frame.size.width))!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
