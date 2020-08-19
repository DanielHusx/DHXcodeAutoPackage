//
//  DHGetterUtils.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHGetterUtils.h"
#import "DHCoreGetter.h"
@implementation DHGetterUtils
/// 组装工作空间信息
/// @param xcworkspaceFile 工作空间文件(.xcworkspace)
+ (DHWorkspaceModel *)fetchWorkspaceWithXcworkspaceFile:(NSString *)xcworkspaceFile
                                                error:(NSError **)error {
    return [DHCoreGetter fetchWorkspaceWithXcworkspaceFile:xcworkspaceFile
                                                       error:error];
}

/// 组装项目信息
/// @param xcodeprojFile 项目文件(.xcodeproj)
+ (DHProjectModel *)fetchProjectWithXcodeprojFile:(NSString *)xcodeprojFile
                                          error:(NSError **)error {
    return [DHCoreGetter fetchProjectWithXcodeprojFile:xcodeprojFile
                                                   error:error];
}

/// 组装项目关联Target信息
/// @param xcodeprojFile 项目文件(.xcodeproj)
/// @param targetName scheme
+ (DHTargetModel *)fetchTargetWithXcodeprojFile:(NSString *)xcodeprojFile
                                   targetName:(NSString *)targetName
                                        error:(NSError **)error {
    return [DHCoreGetter fetchTargetWithXcodeprojFile:xcodeprojFile
                                             targetName:targetName
                                                  error:error];
}

/// 组装Target配置信息
/// @param xcodeprojFile 项目文件(.xcodeproj)
/// @param targetName scheme
/// @param configurationName Debug/Release
+ (DHBuildConfigurationModel *)fetchBuildConfigurationWithXcodeprojFile:(NSString *)xcodeprojFile
                                                           targetName:(NSString *)targetName
                                                    configurationName:(DHConfigurationName)configurationName
                                                                error:(NSError **)error {
    return [DHCoreGetter fetchBuildConfigurationWithXcodeprojFile:xcodeprojFile
                                                         targetName:targetName
                                                  configurationName:configurationName
                                                              error:error];
}

/// 组装描述文件信息
+ (DHProfileModel *)fetchProfileWithProfile:(NSString *)profile
                                    error:(NSError **)error {
    return [DHCoreGetter fetchProfileWithProfile:profile
                                              error:error];
}


/// 组装Git信息
/// @param gitFile .git路径
+ (DHGitModel *)fetchGitWithGitFile:(NSString *)gitFile
                            error:(NSError **)error {
    return [DHCoreGetter fetchGitWithGitFile:gitFile
                                          error:error];
}

/// 组装Podfile信息
/// @param podfile Podfile路径
+ (DHPodModel *)fetchPodWithPodfile:(NSString *)podfile
                            error:(NSError **)error {
    return [DHCoreGetter fetchPodWithPodfile:podfile
                                          error:error];
}

/// 组装Archive信息
/// @param xcarchiveFile .xcarchiveFile路径
+ (DHArchiveModel *)fetchArchiveWithXcarchiveFile:(NSString *)xcarchiveFile
                                          error:(NSError **)error {
    return [DHCoreGetter fetchArchiveWithXcarchiveFile:xcarchiveFile
                                                    error:error];
}

/// 组装IPA信息
/// @param ipaFile .ipa路径
+ (DHIPAModel *)fetchIPAWithIPAFile:(NSString *)ipaFile
                            error:(NSError **)error {
    return [DHCoreGetter fetchIPAWithIPAFile:ipaFile
                                          error:error];
}

/// 组装App信息
/// @param appFile .app路径
+ (DHAppModel *)fetchAppWithAppFile:(NSString *)appFile
                            error:(NSError **)error {
    return [DHCoreGetter fetchAppWithAppFile:appFile
                                          error:error];
}

/// 获取初始化的发布信息
/// @param platform 平台类型
+ (id<DHDistributionProtocol>)fetchDistributeWithPlatform:(DHDistributionPlatform)platform {
    return [DHCoreGetter fetchDistributeWithPlatform:platform];
}

@end
