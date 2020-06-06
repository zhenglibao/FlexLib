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

@objc(TestScrollVC)
class TestScrollVC: FlexBaseVC {
    
    @objc var multilabel : UILabel!
    @objc var attrLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func tapShow() -> Void {
        multilabel.isHidden = !multilabel.isHidden;
        multilabel.rootView.layoutAnimation(0.3);
    }
    
    @objc(tapLabel:)
    func tapLabel(sender:Any)->Void{
        
        let node : FlexNode = attrLabel.getFlexNode("a1")
        
        for attr:FlexAttr in node.viewAttrs {
        
            if( attr.name=="text"){
                let newstr = attr.value.appending("abc")
                attrLabel.setFlexAttrString(newstr, name: "a1")
                break;
            }
        }
        
        attrLabel.updateAttributeText()
        attrLabel.markDirty()
    }
    
    @objc
    func tapLabel()->Void{
        NSLog("tap2")
    }
    @objc(tapText:)
    func tapText(click:FlexClickRange)->Void
    {
        let range = Range(click.range,in:attrLabel.text!)
        let txt = attrLabel.text![range!]
        
        let alertview = UIAlertView.init(title: "点击了", message: String(txt), delegate: nil, cancelButtonTitle: "取消")
        alertview.show()
    }

}
