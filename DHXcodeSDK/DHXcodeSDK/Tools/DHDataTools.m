//
//  DHDataTools.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHDataTools.h"

@implementation DHDataTools

// MARK: - validate
+ (BOOL)validateConfigurationName:(NSString *)configurationName {
    if (![DHObjectTools isValidString:configurationName]) { return NO; }
    if (![[self configurationNameOptions] containsObject:configurationName]) { return NO; }
    
    return YES;
}

+ (BOOL)validateChannel:(NSString *)channel {
    if (![DHObjectTools isValidString:channel]) { return NO; }
    if (![[self channelWithoutUnkonwnOptions] containsObject:channel]) { return NO; }
    
    return YES;
}

+ (BOOL)validateEnableBitcode:(NSString *)enableBitcode {
    if (![DHObjectTools isValidString:enableBitcode]) { return NO; }
    if (![[self enableBitcodeOptions] containsObject:enableBitcode]) { return NO; }
    
    return YES;
}

+ (BOOL)validateDistributionPlatform:(NSString *)platform {
    if (![DHObjectTools isValidString:platform]) { return NO; }
    if (![[self distributionPlatformWithoutNoneOptions] containsObject:platform]) { return NO; }
    
    return YES;
}


// MARK: - options
+ (NSArray *)channelOptions {
    return @[
        kDHChannelUnknown,
        kDHChannelDevelopment,
        kDHChannelAdHoc,
        kDHChannelAppStore,
        kDHChannelEnterprise
    ];
}

+ (NSArray *)distributionPlatformOptions {
    return @[
        kDHDistributionPlatformNone,
        kDHDistributionPlatformPgyer,
        kDHDistributionPlatformFir
    ];
}
+ (NSArray *)channelWithoutUnkonwnOptions {
    return @[
//        kDHChannelUnknown,
        kDHChannelDevelopment,
        kDHChannelAdHoc,
        kDHChannelAppStore,
        kDHChannelEnterprise
    ];
}

+ (NSArray *)distributionPlatformWithoutNoneOptions {
    return @[
//        kDHDistributionPlatformNone,
        kDHDistributionPlatformPgyer,
        kDHDistributionPlatformFir
    ];
}

+ (NSArray *)configurationNameOptions {
    return @[
        kDHConfigurationNameDebug,
        kDHConfigurationNameRelease
    ];
}

+ (NSArray *)enableBitcodeOptions {
    return @[
        kDHEnableBitcodeYES,
        kDHEnableBitcodeNO
    ];
}

@end
