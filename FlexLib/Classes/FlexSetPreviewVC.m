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
#import "FlexHttpVC.h"

@protocol FlexIndexProtocol<NSObject>
@required
-(BOOL)shouldContinue;
-(void)onProgress:(CGFloat)percent; // 0~1
-(void)onError:(NSString*)error;
@end

NSString* appendPathComponent(NSString* baseUrl,NSString* filename)
{
    if(![baseUrl hasSuffix:@"/"])
        baseUrl = [baseUrl stringByAppendingString:@"/"];
    return [baseUrl stringByAppendingString:filename];
}

void createFlexIndex(NSString* url,
                     NSMutableDictionary* flexIndex,
                     CGFloat basePercent,
                     CGFloat startPercent,
                     id<FlexIndexProtocol> delegate)
{
    if(![delegate shouldContinue])
        return;
    
    NSError* error = nil;
    NSData* data = FlexFetchHttpRes(url, &error);
    if(data!=nil){
        
        NSString* sdata = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSArray* links = [FlexHttpVC extractLinks:sdata];
        
        if(links.count==0){
            [delegate onProgress:basePercent+startPercent];
            return;
        }
        
        CGFloat thisBasePercent = basePercent/links.count;
        
        for (NSInteger i=0;i<links.count;i+=2) {
            NSString* link = links[i];
            NSString* name = links[i+1];
            NSString* fullPath = appendPathComponent(url, link);
            CGFloat thisStartPercent = startPercent + thisBasePercent*i;
            
            if([name hasSuffix:@"/"]){
                
                createFlexIndex(fullPath,
                                flexIndex,
                                thisBasePercent*2.0,
                                thisStartPercent,
                                delegate);
                
            }else if([name hasSuffix:@".xml"]){
                name = [name stringByDeletingPathExtension];
                [flexIndex setObject:fullPath forKey:name];
            }
            [delegate onProgress:thisStartPercent+thisBasePercent*2.0];
            
            if(![delegate shouldContinue])
                return;
        }
        [delegate onProgress:basePercent+startPercent];
        
    }else{
        NSString* se ;
        if(error == nil)
            se = @"unknown error";
        else
            se = [error localizedDescription];
        
        [delegate onError:se];
    }
}

@interface FlexSetPreviewVC ()<FlexIndexProtocol>
{
    UITextField* _baseUrlField;
    UISwitch* _loadSwitch;
    UILabel* _warning;
    
    NSString* _errorMsg;
    BOOL _creatingIndex;
    BOOL _canContinue;
}
@property(nonatomic,strong) UIProgressView* progress;

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
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _canContinue = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _canContinue = NO;
}
- (void)dealloc
{
    
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
    
    if(baseurl.length==0){
        FlexShowToast(FlexLocalizeString(@"baseUrlNonNull"), 1.0f);
        return;
    }
    
    if(![baseurl hasSuffix:@"/"]){
        baseurl = [baseurl stringByAppendingString:@"/"];
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:baseurl forKey:FLEXBASEURL];
    [defaults setBool:onlineLoad forKey:FLEXONLINELOAD];
    
    FlexSetPreviewBaseUrl(baseurl);
    FlexSetLoadFunc(onlineLoad?flexFromNet:flexFromFile);
}

-(void)onCreateIndexFinish:(NSDictionary*)dict
{
    FlexHideBusyForView(self.view);

    _creatingIndex = NO;
    _progress.hidden = YES;
    
    if(_errorMsg!=nil){
        FlexShowToast(_errorMsg, 1.0f);
    }else{
        FlexSetFlexIndex(dict);
        FlexShowToast(FlexLocalizeString(@"createFlexIndexStatus"), 1.0f);
    }
}
-(void)onCreateIndex
{
    if(_creatingIndex)
        return ;
    
    _creatingIndex = YES;

    __weak FlexSetPreviewVC* weakSelf = self;
    
    _errorMsg = nil;
    _progress.hidden = NO;
    _progress.progress = 0;
    
    FlexShowBusyForView(self.view);
    
    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue,^{
        
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        
        createFlexIndex(FlexGetPreviewBaseUrl(),
                        dict, 1, 0, weakSelf);
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [weakSelf onCreateIndexFinish:dict];
                       });
    });
}

#pragma mark - create index delegate

-(BOOL)shouldContinue
{
    return _canContinue;
}
-(void)onProgress:(CGFloat)percent
{
    __weak FlexSetPreviewVC* weakSelf = self;
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       weakSelf.progress.progress = percent;
                   });
}
-(void)onError:(NSString*)error
{
    _errorMsg = error;
}

#pragma mark - present

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
