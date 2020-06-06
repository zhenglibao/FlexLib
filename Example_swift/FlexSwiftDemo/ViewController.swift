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

@objc(ViewController)
class ViewController: FlexBaseVC {
    
    @objc var _scroll : UIScrollView?
    @objc var _label : UILabel?;
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "FlexSwiftDemo";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @objc func onControls() -> Void {
       
        let vc=Controls();
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onTestTable() -> Void {
        let vc=TestTableVC.init(flexName: "TestTableVC");
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @objc(onTestScrollView:)
    func onTestScrollView(id:UIView) -> Void {
        let vc=TestScrollVC();
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func onTestModalView() -> Void {
        let vc=TestModalVC();
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func onTestLoginView() -> Void {
        let vc=TestTouchVC();
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func onjustifyContent() -> Void {
        let vc=TestJustifycontentVC(flexName:"justifyContent");
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @objc func onTextView() -> Void {
        let vc=TestTextviewVC.init(flexName: "TextViewVC");
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @objc func onViewLayouts() -> Void {
        FlexLayoutViewerVC.present(inVC: self)
    }
    @objc func onFrameVC()->Void{
        let vc=FrameVC.init(nibName: nil, bundle: nil);
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func onExplorerFlex()->Void{
        FlexHttpVC.present(inVC: self)
    }
    @objc func onFrameView()->Void{
        var  frame = UIScreen.main.bounds;
        frame.origin.y = 100
        frame.size.height=400
        let view = TestFrameView.init(flex: nil, frame: frame, owner: nil)
        self.view.addSubview(view!)
    }
    
}

