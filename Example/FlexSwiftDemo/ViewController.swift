//
//  ViewController.swift
//  FlexSwiftDemo
//
//  Created by zhenglibao on 2017/12/21.
//  Copyright © 2017年 wbg. All rights reserved.
//

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


    @objc func onTest() -> Void {
       
        let vc=TestVC.init(flexName: "test");
        self.navigationController?.pushViewController(vc!, animated: true)
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
}

