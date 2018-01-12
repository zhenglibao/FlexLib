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
#import "FlexUtils.h"

@interface FlexSetPreviewVC ()
{
    UITextField* _baseUrlField;
    UISwitch* _loadSwitch;
    
    UILabel* _warning;
}

@end

@implementation FlexSetPreviewVC
-(NSBundle*)bundleForStrings
{
    return FlexBundle();
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = FlexLocalizeString(@"previewVCTitle");
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [_baseUrlField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_baseUrlField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _baseUrlField.text = [defaults objectForKey:FLEXBASEURL];
    
    [_loadSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    _loadSwitch.on = [defaults boolForKey:FLEXONLINELOAD];
    _warning.hidden = !_loadSwitch.on;
}
- (NSArray<UIKeyCommand *> *)keyCommands
{
    return @[];
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
    
    baseurl = [baseurl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:baseurl forKey:FLEXBASEURL];
    [defaults setBool:onlineLoad forKey:FLEXONLINELOAD];
    
    FlexSetPreviewBaseUrl(baseurl);
    FlexSetLoadFunc(onlineLoad?flexFromNet:flexFromFile);
}
+(void)presentInVC:(UIViewController*)parentVC{
    
    NSString* flexName = NSStringFromClass([FlexSetPreviewVC class]);
    
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[FlexSetPreviewVC class]];
    NSString *resourcePath = [frameworkBundle pathForResource:flexName ofType:@"xml" inDirectory:@"FlexLib.bundle"];
    
    FlexSetPreviewVC* vc = [[FlexSetPreviewVC alloc]initWithFlexName:resourcePath];
    
    if(parentVC.navigationController != nil){
        [parentVC.navigationController pushViewController:vc animated:YES];
    }else{
        [parentVC presentViewController:vc animated:YES completion:nil];
    }
}
@end
