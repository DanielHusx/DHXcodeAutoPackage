//
//  DHDataTools.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHDataTools : NSObject
// MARK: - validate
+ (BOOL)validateConfigurationName:(NSString *)configurationName;
+ (BOOL)validateChannel:(NSString *)channel;
+ (BOOL)validateEnableBitcode:(NSString *)enableBitcode;
+ (BOOL)validateDistributionPlatform:(NSString *)platform;

// MARK: - options
+ (NSArray *)channelOptions;
+ (NSArray *)distributionPlatformOptions;
+ (NSArray *)configurationNameOptions;
+ (NSArray *)enableBitcodeOptions;
+ (NSArray *)channelWithoutUnkonwnOptions;
+ (NSArray *)distributionPlatformWithoutNoneOptions;

@end

NS_ASSUME_NONNULL_END
