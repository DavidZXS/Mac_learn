//
//  AppDelegate.m
//  TextDemo
//
//  Created by Cedar on 2020/6/23.
//  Copyright © 2020 Cedar. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeVC.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    //窗口 关闭，缩小，放大等功能，根据需求自行组合
    NSUInteger style =  NSWindowStyleMaskTitled | NSWindowStyleMaskClosable |NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
//    float w = [[NSScreen mainScreen] frame].size.width / 3 * 2;
//    float h = [[NSScreen mainScreen] frame].size.height / 3 * 2;
    self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 471, 357) styleMask:style backing:NSBackingStoreBuffered defer:YES];
    self.window.title = @"Demo";
    [self.window makeKeyAndOrderFront:self];
    [self.window center];
    
    HomeVC *homeVC = [[HomeVC alloc] init];
    [self.window setContentViewController:homeVC];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
