//
//  DHTaskUpdator.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskUpdator.h"
#import "DHTaskModel.h"
#import <DHXcodeSDK/DHXcodeSDK.h>
#import "DHTaskModel+DHTaskParseInfo.h"

@implementation DHTaskUpdator

+ (void)updateTask:(DHTaskModel *)task withPlatform:(id<DHDistributionProtocol>)platform {
    task.distributionPlatform = platform;
    // 更新task信息
    [self updateTask:task withDistribution:platform];
    
    if ([platform isKindOfClass:[DHDistributionPgyerModel class]]) {
        [self updatePgyerPlatform:(DHDistributionPgyerModel *)platform withTask:task];
    } else if ([platform isKindOfClass:[DHDistributionFirModel class]]) {
        [self updateFirimPlatform:(DHDistributionFirModel *)platform withTask:task];
    }
}

+ (void)updatePgyerPlatform:(DHDistributionPgyerModel *)pgyerPlatform withTask:(DHTaskModel *)task {
    pgyerPlatform.appDisplayName = task.currentDisplayName;
}

+ (void)updateFirimPlatform:(DHDistributionFirModel *)firimPlatform  withTask:(DHTaskModel *)task {
    firimPlatform.appDisplayName = task.currentDisplayName;
    firimPlatform.appVersion = task.currentVersion;
    firimPlatform.appBuildVersion = task.currentBuildVersion;
    firimPlatform.appBundleId = task.currentBundleId;
}

// 配置buildConfiguration信息
+ (void)updateTask:(DHTaskModel *)task withConfiguration:(DHBuildConfigurationModel *)configuration {
    task.currentBundleId = configuration.bundleId;
    task.currentTeamId = configuration.teamId;
    task.currentVersion = configuration.shortVersion;
    task.currentBuildVersion = configuration.buildVersion;
    task.currentEnableBitcode = configuration.enableBitcode;
    task.currentProductName = configuration.productName;
    task.currentDisplayName = configuration.displayName;
}

// 配置app信息
+ (void)updateTask:(DHTaskModel *)task withApp:(DHAppModel *)app {
    task.currentProductName = app.productName;
    task.currentDisplayName = app.displayName;
    task.currentBundleId = app.bundleId;
    task.currentVersion = app.version;
    task.currentBuildVersion = app.buildVersion;
    task.currentEnableBitcode = app.enableBitcode;
    task.currentTeamId = app.embeddedProfile.teamId;
    
    [self updateTask:task
         withProfile:app.embeddedProfile];
}

// 配置profile信息
+ (void)updateTask:(DHTaskModel *)task withProfile:(DHProfileModel *)profile {
    task.currentProfilePath = profile.profilePath;
    task.currentProfileName = profile.name;
    task.currentProfileBundleId = profile.bundleId;
    task.currentProfileAppId = profile.appId;
    task.currentProfileTeamId = profile.teamId;
    task.currentProfileTeamName = profile.teamName;
    task.currentProfileUUID = profile.uuid;
    task.currentProfileCreateTimestamp = profile.createTimestamp;
    task.currentProfileExpireTimestamp = profile.expireTimestamp;
    task.currentProfileChannel = profile.channel;
}

// 配置git信息
+ (void)updateTask:(DHTaskModel *)task withGit:(DHGitModel *)git {
    task.gitFile = git.gitFile;
    task.branchNameOptions = git.branchNameOptions;
    task.currentBranch = git.currentBranch;
}

// 配置pod信息
+ (void)updateTask:(DHTaskModel *)task withPod:(DHPodModel *)pod {
    task.podfilePath = pod.podfilePath;
}

// 配置分发信息
+ (void)updateTask:(DHTaskModel *)task withDistribution:(id<DHDistributionProtocol>)distribution {
    task.currentDistributionNickname = distribution.nickname;
    task.currentDistributionPlatformApiKey = distribution.platformApiKey;
    task.currentDistributionInstallPassword = distribution.installPassword;
    task.currentDistributionPlatformType = distribution.platformType;
    task.currentDistributionChangeLog = distribution.changeLog;
    task.currentDistributer = distribution.distributer;
}

@end
