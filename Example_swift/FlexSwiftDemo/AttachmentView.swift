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

@objc(AttachmentView)
class AttachmentView: FlexCustomBaseView {
    
    @objc var _attachParent : UIView!
    
    override func onInit(){
        self.flexibleWidth = false;
        self.flexibleHeight = true;
    }
    
    @objc(removeCell:)
    func removeCell(sender : UIGestureRecognizer) -> Void {
        let cell = sender.view!
        cell.removeFromSuperview()
        _attachParent.markDirty()
    }
    
    @objc
    func onAddAttachment() -> Void {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(AttachmentView.removeCell(sender:)))
        let cell = UIView()
        cell.enableFlexLayout(true)
        cell.addGestureRecognizer(tap)
        cell.setLayoutAttrStrings([
            "width","100%",
            "height","44",
            "marginTop","5",
            "marginBottom","5",
            "alignItems","center",
            "justifyContent","center",
            ])
        cell.setViewAttr("bgColor", value: "#e5e5e5")
        _attachParent.addSubview(cell)
        
        let label = UILabel()
        label.enableFlexLayout(true)
        label.setViewAttrStrings([
            "fontSize","16",
            "color","red",
            "text","点我删除",
            ])
        cell.addSubview(label)
        
        _attachParent.markDirty()
    }
}
