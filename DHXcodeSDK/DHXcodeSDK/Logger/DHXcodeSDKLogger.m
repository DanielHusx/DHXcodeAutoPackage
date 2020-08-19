//
//  DHXcodeSDKLogger.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/7/30.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHXcodeSDKLogger.h"

@implementation DHXcodeSDKLogger

+ (instancetype)logger {
    static DHXcodeSDKLogger *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DHXcodeSDKLogger alloc] init];
    });
    return _instance;
}

- (void)log:(NSString *)log {
    if (!_delegate) { return ; }
    [_delegate sdkLogger:self log:log];
}

- (void)log_stream:(NSString *)log {
    if (!_delegate) { return ; }
    [_delegate sdkLogger:self logStream:log];
}

@end
