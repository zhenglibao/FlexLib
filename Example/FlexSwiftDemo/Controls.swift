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

@objc(Controls)
class Controls: FlexBaseVC,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @objc var _activityView : UIActivityIndicatorView!
    @objc var _pickerView : UIPickerView!
    @objc var _tabBar : UITabBar!
    @objc var _toolbar : UIToolbar!
    
    @objc var _pickerDatas = ["aaaa","bbb","ccccc","ddddd","eeeee"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.navigationItem.title = "Controls"
        
        _activityView.startAnimating()
        
        _pickerView.delegate = self
        _pickerView.dataSource = self
        _pickerView.reloadAllComponents()
        

        let tabBarItem2 = UITabBarItem(title: "人均", image: nil, tag: 1)
        let tabBarItem3 = UITabBarItem(title: "距离", image: nil, tag: 2)
        let tabBarItem4 = UITabBarItem(title: "好评", image: nil, tag: 3)
        _tabBar.setItems([tabBarItem2,tabBarItem3,tabBarItem4], animated: true)
        
        
        let leftItem = UIBarButtonItem(title: "左边", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: nil)
        _toolbar.setItems([leftItem,rightItem], animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func createView(_ cls: AnyClass!, name: String?) -> UIView? {
        if  (name != nil) {
            if("_segment".compare(name!).rawValue==0){
                return UISegmentedControl.init(items: ["item1","item2","item3"])
            }
        }
        return nil
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _pickerDatas.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return _pickerDatas[row]
    }
}
