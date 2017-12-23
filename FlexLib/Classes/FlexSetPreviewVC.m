/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "FlexSetPreviewVC.h"
#import "FlexNode.h"

@interface FlexSetPreviewVC ()
{
    UITextField* _baseUrlField;
    UISwitch* _loadSwitch;
    
    UILabel* _warning;
}

@end

@implementation FlexSetPreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(FlexGetLanguage()==flexChinese){
        self.navigationItem.title = @"预览设置";

    }else{
        self.navigationItem.title = @"Flex Preview Setting";
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [_baseUrlField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_baseUrlField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _baseUrlField.text = [defaults objectForKey:FLEXBASEURL];
    
    [_loadSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    _loadSwitch.on = [defaults boolForKey:FLEXONLINELOAD];
    
}
- (void)reloadFlexView
{
    //阻止该界面
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)switchAction:(id)sender
{
    UISwitch* sw = (UISwitch*)sender;
    
    _warning.hidden = !sw.on;
}
-(void)onSave
{
    NSString* baseurl = _baseUrlField.text;
    BOOL onlineLoad = _loadSwitch.isOn;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:baseurl forKey:FLEXBASEURL];
    [defaults setBool:onlineLoad forKey:FLEXONLINELOAD];
    
    FlexSetPreviewBaseUrl(baseurl);
    FlexSetLoadFunc(onlineLoad?flexFromNet:flexFromFile);
}

@end
