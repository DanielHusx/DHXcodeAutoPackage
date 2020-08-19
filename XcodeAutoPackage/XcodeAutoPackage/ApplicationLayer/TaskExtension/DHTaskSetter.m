//
//  DHTaskSetter.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/25.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskSetter.h"
#import "DHTaskConfiguration.h"
#import "DHTaskModel.h"
#import <DHXcodeSDK/DHXcodeSDK.h>

@implementation DHTaskSetter

+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withXcodeprojFile:(NSString *)xcodeprojFile {
    if ([task.currentXcodeprojFile isEqualToString:xcodeprojFile]) { return NO; }
    
    // 更改项目整体信息
    [DHTaskConfiguration configureTask:task withXcodeprojFile:xcodeprojFile];
    
    return YES;
}

+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withTargetName:(NSString *)targetName {
    if ([task.currentTargetName isEqualToString:targetName]) { return NO; }
    
    // 检测当前的xcodeproj对应的project，然后根据配置得到对应的东西
    [DHTaskConfiguration configureTask:task withTargetName:targetName];
    
    return YES;
}

+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withTeamName:(NSString *)teamName {
    if ([task.currentTeamName isEqualToString:teamName]) { return NO; }
    // 实际啥也不干
    task.currentTeamId = task.teamIdOptions[[task.teamNameOptions indexOfObject:teamName]];
    
    return YES;
}

+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withBundleId:(NSString *)bundleId {
    if ([task.currentBundleId isEqualToString:bundleId]) { return NO; }
    
    task.currentBundleId = bundleId;
    // 更新profile
    [DHTaskConfiguration configureProfileWithTask:task];
    
    return YES;
}

+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withChannel:(NSString *)channel {
    if ([task.channel isEqualToString:channel]) { return NO; }
    
    task.channel = channel;
    // 更新profile
    [DHTaskConfiguration configureProfileWithTask:task];
    return YES;
}

+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withDistributionPlatform:(NSString *)platform {
    if ([task.currentDistributionPlatformType isEqualToString:platform]) { return NO; }
    
    [DHTaskConfiguration configureTask:task withDistributionPlatform:platform];
    return YES;
}

+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withDistributionNickname:(NSString *)nickname {
    if ([task.currentDistributionNickname isEqualToString:nickname]) { return NO; }
    
    [DHTaskConfiguration configureTask:task withDistributionNickname:nickname];
    return YES;
}

+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withDistributionAPIKey:(NSString *)apiKey {
    if ([task.currentDistributionPlatformApiKey isEqualToString:apiKey]) { return NO; }
    
    task.currentDistributionPlatformApiKey = apiKey;
    return NO;
}

+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withDistributionInstallPassword:(NSString *)password {
    if ([task.currentDistributionInstallPassword isEqualToString:password]) { return NO; }
    
    task.currentDistributionInstallPassword = password;
    return NO;
}

+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withDistributionChangeLog:(NSString *)changeLog {
    if ([task.currentDistributionChangeLog isEqualToString:changeLog]) { return NO; }
    
    task.currentDistributionChangeLog = changeLog;
    return NO;
}

+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withProfile:(NSString *)profile {
    if ([task.currentProfilePath isEqualToString:profile]) { return NO; }
    
    [DHTaskConfiguration configureTask:task withProfilePath:profile];
    return YES;
}

+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withProfileName:(NSString *)profileName {
    if ([task.currentProfileName isEqualToString:profileName]) { return NO; }
    
    [DHTaskConfiguration configureTask:task withProfileName:profileName];
    return YES;
}

@end
