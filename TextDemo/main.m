//
//  main.m
//  TextDemo
//
//  Created by Cedar on 2020/6/23.
//  Copyright © 2020 Cedar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
    }
    
    AppDelegate *delegate = [[AppDelegate alloc] init];
    [NSApplication sharedApplication].delegate = delegate;
    
    return NSApplicationMain(argc, argv);
}
