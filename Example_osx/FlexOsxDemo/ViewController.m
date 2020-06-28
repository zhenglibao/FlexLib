//
//  ViewController.m
//  FlexViewer
//
//  Created by 郑立宝 on 2019/10/28.
//  Copyright © 2019年 郑立宝. All rights reserved.
//

#import "ViewController.h"
#import "FlexXmlView.h"
#import "FlexLib.h"

@interface ViewController ()

@property(nonatomic,strong) FlexXmlView* flexView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view;
    
    NSString* xmlPath = @"/Users/zhenglibao/Downloads/BZAuthLoginController.xml";
    [self.flexView loadXml:xmlPath];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (void)viewDidAppear
{
    [super viewDidAppear];
}

@end
