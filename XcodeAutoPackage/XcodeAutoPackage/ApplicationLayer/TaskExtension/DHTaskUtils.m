//
//  DHTaskUtils.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/24.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskUtils.h"
#import <DHXcodeSDK/DHXcodeSDK.h>
#import "DHTaskModel+DHTaskParseInfo.h"

@implementation DHTaskUtils

+ (BOOL)checkPathValid:(NSString *)path {
    if ([DHPathUtils isXcarchiveFile:path]) { return YES; }
    if ([DHPathUtils isIPAFile:path]) { return YES; }
    if ([DHPathUtils findXcworkspace:path]) { return YES; }
    if ([DHPathUtils findXcodeproj:path]) { return YES; }
    return NO;
}

+ (BOOL)checkDistributionPlatformValid:(NSString *)platform {
    return [DHDataTools validateDistributionPlatform:platform];
}

+ (BOOL)checkDistributionInstallPasswordSupportableWithPlatform:(NSString *)platform {
    return [platform isEqualToString:kDHDistributionPlatformPgyer];
}

+ (NSString *)convertChannelToChannelName:(NSString *)channel {
    return [self exchangeChannelAndChannelName:channel];
}

+ (NSString *)convertChannelNameToChannel:(NSString *)channelName {
    return [self exchangeChannelAndChannelName:channelName];
}

+ (NSString *)convertDistributionPlatformToPlatformName:(NSString *)platform {
    return [self exchangeDistributionPlatformAndPlatformName:platform];
}

+ (NSString *)convertDistributionPlatformNameToPlatform:(NSString *)platformName {
    return [self exchangeDistributionPlatformAndPlatformName:platformName];
}

+ (NSString *)exchangeChannelAndChannelName:(NSString *)channelOrChannelName {
    __block NSString *result = kDHChannelUnknown;
    [@{
        kDHChannelUnknown:kDHChannelNameUnknown,
        kDHChannelAdHoc:kDHChannelNameAdHoc,
        kDHChannelAppStore:kDHChannelNameAppStore,
        kDHChannelEnterprise:kDHChannelNameEnterprise,
        kDHChannelDevelopment:kDHChannelNameDevelopment,
    } enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:channelOrChannelName]) {
            result = obj;
            *stop = YES;
        } else if ([obj isEqualToString:channelOrChannelName]) {
            result = key;
            *stop = YES;
        }
    }];
    
    return result;
}

+ (NSString *)exchangeDistributionPlatformAndPlatformName:(NSString *)platformOrPlatformName {
    __block NSString *result = kDHDistributionPlatformNone;
    [@{
        kDHDistributionPlatformNone:kDHDistributionPlatformNameNone,
        kDHDistributionPlatformPgyer:kDHDistributionPlatformNamePgyer,
        kDHDistributionPlatformFir:kDHDistributionPlatformNameFir
    } enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:platformOrPlatformName]) {
            result = obj;
            *stop = YES;
        } else if ([obj isEqualToString:platformOrPlatformName]) {
            result = key;
            *stop = YES;
        }
    }];
    
    return result;
}

+ (NSArray *)channelNameOptionsWithChannelOptions:(NSArray *)channelOptions {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:channelOptions.count];
    for (NSString *item in channelOptions) {
        [result addObject:[self convertChannelToChannelName:item]];
    }
    return [result copy];
}

+ (NSArray *)distributionPlatformNameOptionsWithDistributionPlatformOptions:(NSArray *)distributionPlatformOptions {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:distributionPlatformOptions.count];
    for (NSString *item in distributionPlatformOptions) {
        [result addObject:[self convertDistributionPlatformToPlatformName:item]];
    }
    return [result copy];
}

+ (NSArray *)channelNameOptions {
    return [self channelNameOptionsWithChannelOptions:[self channelOptions]];
}

+ (NSArray *)distributionPlatformNameOptions {
    return [self distributionPlatformNameOptionsWithDistributionPlatformOptions:[self distributionPlatformOptions]];
}

+ (NSArray *)channelOptions {
    return [DHDataTools channelOptions];
}
+ (NSArray *)distributionPlatformOptions {
    return [DHDataTools distributionPlatformOptions];
}
+ (NSArray *)configurationNameOptions {
    return [DHDataTools configurationNameOptions];
}
+ (NSArray *)enableBitcodeOptions {
    return [DHDataTools enableBitcodeOptions];
}

+ (NSArray *)filterAvailableDistributionPlatformsAtPlatform:(NSString *)platformType
                                  withDistributionPlatforms:(NSArray *)distributionPlatforms {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    for (id<DHDistributionProtocol> item in distributionPlatforms) {
        if ([item.platformType isEqualToString:platformType]) {
            [result addObject:[item copyWithZone:nil]];
        }
    }
    return result;
}

+ (NSArray *)teamIdentifierOptionsWithProfilesDirectory:(NSString *)profilesDirectory {
    NSArray *profiles = [DHProfileUtils filterProfilesForUniqueTeamIdsWithDirectory:profilesDirectory];
    if (![DHCommonTools isValidArray:profiles]) { return @[]; }
    
    return [[profiles mutableArrayValueForKey:@"teamId"] copy];
}

+ (NSArray *)teamNameOptionsWithProfilesDirectory:(NSString *)profilesDirectory {
    NSArray *profiles = [DHProfileUtils filterProfilesForUniqueTeamIdsWithDirectory:profilesDirectory];
    if (![DHCommonTools isValidArray:profiles]) { return @[]; }
    
    return [[profiles mutableArrayValueForKey:@"teamName"] copy];
}

+ (NSString *)fetchTeamNameWithProfilesDirectory:(NSString *)profilesDirectory
                                  teamIdentifier:(NSString *)teamIdentifier {
    NSArray *profiles = [DHProfileUtils filterProfileWithDirectory:profilesDirectory
                                                                teamId:teamIdentifier];
    if (![DHCommonTools isValidArray:profiles]) { return @""; }
    
    DHProfileModel *profile = profiles.firstObject;
    return profile.teamName;
}

+ (NSArray *)filterTaskModels:(NSArray *)taskModels
                withCondition:(DHFilterCondition)condition {
    if (condition == DHFilterConditionAll) { return taskModels; }
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:taskModels.count];
    [taskModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DHTaskType type = ((DHTaskModel *)obj).taskType;
        if (condition == DHFilterConditionProjectOnly
            && ((type & DHTaskTypeXcworkspace)
                || (type & DHTaskTypeXcodeproj))) {
            [result addObject:obj];
        }
        if (condition == DHFilterConditionArchiveOnly
            && (type & DHTaskTypeXcarchive)) {
            [result addObject:obj];
        }
        if (condition == DHFilterConditionIPAOnly
            && (type & DHTaskTypeIPA)) {
            [result addObject:obj];
        }
    }];
    
    return result;
}

@end
