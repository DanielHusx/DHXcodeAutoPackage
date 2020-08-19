//
//  DHCoreGetter.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHProjectModel;
@class DHPodModel;
@class DHGitModel;
@class DHProfileModel;
@class DHTargetModel;
@class DHWorkspaceModel;
@class DHBuildConfigurationModel;
@class DHArchiveModel;
@class DHIPAModel;
@class DHAppModel;
@protocol DHDistributionProtocol;
NS_ASSUME_NONNULL_BEGIN

@interface DHCoreGetter : NSObject

/// 组装工作空间信息
/// @param xcworkspaceFile 工作空间文件(.xcworkspace)
+ (nullable DHWorkspaceModel *)fetchWorkspaceWithXcworkspaceFile:(NSString *)xcworkspaceFile
                                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error;

/// 组装项目信息
/// @param xcodeprojFile 项目文件(.xcodeproj)
+ (nullable DHProjectModel *)fetchProjectWithXcodeprojFile:(NSString *)xcodeprojFile
                                                   error:(NSError * _Nullable __autoreleasing * _Nullable)error;

/// 组装项目关联Target信息
/// @param xcodeprojFile 项目文件(.xcodeproj)
/// @param targetName scheme
+ (nullable DHTargetModel *)fetchTargetWithXcodeprojFile:(NSString *)xcodeprojFile
                                            targetName:(NSString *)targetName
                                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error;

/// 组装Target配置信息
/// @param xcodeprojFile 项目文件(.xcodeproj)
/// @param targetName scheme
/// @param configurationName Debug/Release
+ (nullable DHBuildConfigurationModel *)fetchBuildConfigurationWithXcodeprojFile:(NSString *)xcodeprojFile
                                                                    targetName:(NSString *)targetName
                                                             configurationName:(DHConfigurationName)configurationName
                                                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error;

/// 组装描述文件信息
/// @param profile .mobileprovision路径
+ (nullable DHProfileModel *)fetchProfileWithProfile:(NSString *)profile
                                             error:(NSError * _Nullable __autoreleasing * _Nullable)error;

/// 组装Git信息
/// @param gitFile .git路径
+ (nullable DHGitModel *)fetchGitWithGitFile:(NSString *)gitFile
                                     error:(NSError * _Nullable __autoreleasing * _Nullable)error;

/// 组装Podfile信息
/// @param podfile Podfile路径
+ (nullable DHPodModel *)fetchPodWithPodfile:(NSString *)podfile
                                     error:(NSError * _Nullable __autoreleasing * _Nullable)error;

/// 组装Archive信息
/// @param xcarchiveFile .xcarchiveFile路径
+ (nullable DHArchiveModel *)fetchArchiveWithXcarchiveFile:(NSString *)xcarchiveFile
                                                   error:(NSError * _Nullable __autoreleasing * _Nullable)error;

/// 组装IPA信息
/// @param ipaFile .ipa路径
+ (nullable DHIPAModel *)fetchIPAWithIPAFile:(NSString *)ipaFile
                                     error:(NSError * _Nullable __autoreleasing * _Nullable)error;

/// 组装App信息
/// @param appFile .app路径
+ (nullable DHAppModel *)fetchAppWithAppFile:(NSString *)appFile
                                     error:(NSError * _Nullable __autoreleasing * _Nullable)error;

/// 获取初始化的发布信息
/// @param platform 平台类型
+ (id<DHDistributionProtocol>)fetchDistributeWithPlatform:(DHDistributionPlatform)platform;

@end

NS_ASSUME_NONNULL_END
