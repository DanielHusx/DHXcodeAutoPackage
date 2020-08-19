//
//  DHAlert.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHAlert.h"
#import <AppKit/AppKit.h>

@implementation DHAlert
+ (void)showInfoAlertWithTitle:(NSString *)title
                       message:(NSString *)message
                   doneHandler:(void (^ _Nullable)(void))doneHandler {
    [self showAlertWithTitle:title
                     message:message
                  alertStyle:NSAlertStyleInformational
            showCancelButton:YES
               cancelHandler:nil
                 doneHandler:doneHandler];
}

+ (void)showWarningAlertWithTitle:(NSString *)title
                          message:(NSString *)message {
    [self showAlertWithTitle:title
                     message:message
                  alertStyle:NSAlertStyleWarning
            showCancelButton:NO
               cancelHandler:nil
                 doneHandler:nil];
}
static NSModalResponse kDHModalResponseDone = 1000;
static NSModalResponse kDHMOdalResponseCancel = 1001;

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                alertStyle:(NSAlertStyle)alertStyle
          showCancelButton:(BOOL)showCancelButton
             cancelHandler:(void (^ _Nullable)(void))cancelHandler
               doneHandler:(void (^ _Nullable)(void))doneHandler {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = title;
    alert.informativeText = message;
    alert.alertStyle = alertStyle;
    [alert addButtonWithTitle:@"Done"]; // 1000
    if (showCancelButton) {
        [alert addButtonWithTitle:@"Cancel"]; // 1001
    }
    [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow
                  completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == kDHModalResponseDone) {
            if (doneHandler) { doneHandler(); }
        } else if (returnCode == kDHMOdalResponseCancel) {
            if (cancelHandler) { cancelHandler(); }
        }
    }];
}
@end
