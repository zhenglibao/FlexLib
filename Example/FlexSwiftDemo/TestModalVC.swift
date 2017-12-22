//
//  TestModalVC.swift
//  FlexSwiftDemo
//
//  Created by zhenglibao on 2017/12/22.
//  Copyright © 2017年 wbg. All rights reserved.
//

import UIKit
import FlexLib

@objc(TestModalVC)
class TestModalVC: FlexBaseVC {
    
    @objc var _modal : FlexModalView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Modal Demo";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func tapModalTop()->Void{
        _modal?.setViewAttr("position", value: "top")
        _modal?.showModal(in: self.view, anim: true)
    }
    @objc func tapModalCenter()->Void{
        _modal?.setViewAttr("position", value: "center")
        _modal?.showModal(in: self.view, anim: true)
    }
    @objc func tapModalBottom()->Void{
        _modal?.setViewAttr("position", value: "bottom")
        _modal?.showModal(in: self.view, anim: true)
    }
}
