//
//  DHTaskUtils.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/24.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHTaskModel;
NS_ASSUME_NONNULL_BEGIN

@interface DHTaskUtils : NSObject
/// 检验路径是否可有效创建Task
+ (BOOL)checkPathValid:(NSString *)path;
+ (BOOL)checkDistributionPlatformValid:(NSString *)platform;
+ (BOOL)checkDistributionInstallPasswordSupportableWithPlatform:(NSString *)platform;

+ (NSString *)convertChannelToChannelName:(NSString *)channel;
+ (NSString *)convertChannelNameToChannel:(NSString *)channelName;
+ (NSString *)convertDistributionPlatformToPlatformName:(NSString *)platform;
+ (NSString *)convertDistributionPlatformNameToPlatform:(NSString *)platformName;

+ (NSArray *)channelNameOptionsWithChannelOptions:(NSArray *)channelOptions;
+ (NSArray *)distributionPlatformNameOptionsWithDistributionPlatformOptions:(NSArray *)distributionPlatformOptions;

+ (NSArray *)channelNameOptions;
+ (NSArray *)distributionPlatformNameOptions;

+ (NSArray *)channelOptions;
+ (NSArray *)distributionPlatformOptions;
+ (NSArray *)configurationNameOptions;
+ (NSArray *)enableBitcodeOptions;
+ (NSArray *)teamIdentifierOptionsWithProfilesDirectory:(NSString *)profilesDirectory;
+ (NSArray *)teamNameOptionsWithProfilesDirectory:(NSString *)profilesDirectory;

+ (NSArray *)filterAvailableDistributionPlatformsAtPlatform:(NSString *)platformType
                                  withDistributionPlatforms:(NSArray *)distributionPlatforms;

+ (NSString *)fetchTeamNameWithProfilesDirectory:(NSString *)profilesDirectory
                                  teamIdentifier:(NSString *)teamIdentifier;

+ (NSArray *)filterTaskModels:(NSArray *)taskModels
                withCondition:(DHFilterCondition)condition;


@end

NS_ASSUME_NONNULL_END
