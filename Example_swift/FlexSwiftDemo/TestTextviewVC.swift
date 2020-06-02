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

@objc(TestTextviewVC)
class TestTextviewVC: FlexBaseVC {
    
    @objc var _imgParent : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareInputs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func removeCell(sender : UIGestureRecognizer) -> Void {
        let cell = sender.view
        cell?.removeFromSuperview()
        _imgParent.markDirty()
    }
    @objc
    func onAddImage() -> Void {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(TestTextviewVC.removeCell(sender:)))
        let cell = UIView()
        cell.enableFlexLayout(true)
        cell.addGestureRecognizer(tap)
        cell.setLayoutAttrStrings([
            "width","60",
            "margin","2",
            "height","40",
            "alignItems","center",
            "justifyContent","center",
            ])
        cell.setViewAttr("bgColor", value: "#e5e5e5")
        cell.setViewAttr("borderRadius", value: "10")
        _imgParent.insertSubview(cell, at: 0)
        
        let label = UILabel()
        label.enableFlexLayout(true)
        label.setViewAttrStrings([
            "fontSize","16",
            "color","red",
            "text","删除",
            ])
        cell.addSubview(label)
        
        _imgParent.markDirty()
    }
}
