//
//  AppDelegate.m
//  FlexOsxDemo
//
//  Created by 郑立宝 on 2019/11/21.
//  Copyright © 2019 郑立宝. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic,strong) ViewController* viewController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    self.viewController = [[ViewController alloc]init];
    [self.window.contentView addSubview:self.viewController.view];
    self.viewController.view.frame = self.window.contentView.bounds;
    self.viewController.view.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    return YES;
}

@end
