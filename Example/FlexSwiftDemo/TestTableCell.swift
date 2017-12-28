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

@objc(TestTableCell)
class TestTableCell: FlexBaseTableCell {

    @objc var head : UIImageView!
    @objc var name : UILabel!
    @objc var type : UILabel!
    @objc var date : UILabel!
    @objc var title : UILabel!
    @objc var content : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(data : Dictionary<String,String>, height:Bool) -> Void {
        if(!height){
            name.text = data["name"]
            type.text = data["type"]
            date.text = data["date"]
            title.text = data["title"]
        }
        content.text = data["content"]
    }
}
