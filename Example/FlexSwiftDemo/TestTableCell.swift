//
//  TestTableCell.swift
//  FlexSwiftDemo
//
//  Created by zhenglibao on 2017/12/22.
//  Copyright © 2017年 wbg. All rights reserved.
//

import UIKit
import FlexLib

@objc(TestTableCell)
class TestTableCell: FlexBaseTableCell {

    @objc var head : UIImageView?
    @objc var name : UILabel?
    @objc var type : UILabel?
    @objc var date : UILabel?
    @objc var title : UILabel?
    @objc var content : UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(data : Dictionary<String,String>) -> Void {
        name?.text = data["name"]
        type?.text = data["type"]
        date?.text = data["date"]
        title?.text = data["title"]
        content?.text = data["content"]
    }
}
