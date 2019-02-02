//
//  TestXmlView.swift
//  FlexSwiftDemo
//
//  Created by 郑立宝 on 2019/2/2.
//  Copyright © 2019年 wbg. All rights reserved.
//

import UIKit
import FlexLib

@objc(TestXmlView)
class TestXmlView: FlexXmlBaseView {

    @objc var _attachParent : UIView!
    
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
            "width","80%",
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
