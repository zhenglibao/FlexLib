//
//  FrameVC.swift
//  FlexSwiftDemo
//
//  Created by zhenglibao on 2018/2/5.
//  Copyright © 2018年 wbg. All rights reserved.
//

import UIKit
import FlexLib

class FrameVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = FlexFrameView.init(flex: "FrameVC", frame: CGRect.zero, owner: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
