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

@objc(TestModalVC)
class TestModalVC: FlexBaseVC {
    
    @objc var _modal : FlexModalView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Modal Demo";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func tapModalTop()->Void{
        _modal.setViewAttr("position", value: "top")
        _modal.showModal(in: self.view, anim: true)
    }
    @objc func tapModalCenter()->Void{
        _modal.setViewAttr("position", value: "center")
        _modal.showModal(in: self.view, anim: true)
    }
    @objc func tapModalBottom()->Void{
        _modal.setViewAttr("position", value: "bottom")
        _modal.showModal(in: self.view, anim: true)
    }
}
