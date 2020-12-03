//
//  AppDelegate.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "AppDelegate.h"
#import "DHGlobalArchiver.h"
#import <DHXcodeSDK/DHProfileArchiver.h>
//#import <DHXcodeSDK/DHProfileUtils.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//    // 解档缓存的全局设置
//    [DHGlobalArchiver unarchiveGlobalConfiguration];
//    // 解档profiles
//    [DHProfileArchiver unarchiveProfiles];
    
//    DHLogInfo(@"我收到货覅啥地方是考虑对方收代理费\ndflkjsaldkfjlskdfj sdfskdfj ");
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)addTaskAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDHToolbarAddNotificationName object:nil];
}

- (IBAction)deleteTaskAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDHToolbarDeleteNotificationName object:nil];
}

- (IBAction)runTaskAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDHToolbarRunNotificationName object:nil];
}

- (IBAction)stopTaskAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDHToolbarStopNotificationName object:nil];
}

- (IBAction)settingAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDHToolbarSettingNotificationName object:nil];
}

@end
