//
//  DHXcodeSDKLogger.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/7/30.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DHXcodeSDKLoggerDelegate;
@interface DHXcodeSDKLogger : NSObject
/// 单例
+ (instancetype)logger;
/// 输出代理
@property (nonatomic, weak) id<DHXcodeSDKLoggerDelegate> delegate;

@end

@protocol DHXcodeSDKLoggerDelegate <NSObject>
/// 输出日志
- (void)sdkLogger:(DHXcodeSDKLogger *)sdkLogger log:(NSString *)log;
/// 输出流日志
- (void)sdkLogger:(DHXcodeSDKLogger *)sdkLogger logStream:(NSString *)log;

@end

NS_ASSUME_NONNULL_END
