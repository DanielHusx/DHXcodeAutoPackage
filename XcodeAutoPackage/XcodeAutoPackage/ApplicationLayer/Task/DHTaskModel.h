//
//  DHTaskModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHConfigurationProtocol.h"

typedef NS_OPTIONS(NSInteger, DHTaskType) {
    DHTaskTypeUnknown       = 0,
    /// 多工程
    DHTaskTypeXcworkspace   = 1 << 0,
    /// 单工程
    DHTaskTypeXcodeproj     = 1 << 1,
    /// .xcarchive导出
    DHTaskTypeXcarchive     = 1 << 2,
    /// ipa任务
    DHTaskTypeIPA           = 1 << 3,
    /// 发布
    DHTaskTypeDistribute    = 1 << 4,
    /// git
    DHTaskTypeGit           = 1 << 5,
    /// pod
    DHTaskTypePod           = 1 << 6,
};

@class DHDistributer;

NS_ASSUME_NONNULL_BEGIN

/**
 任务模型，装载一个任务的所有相关信息
*/
@interface DHTaskModel : NSObject <NSCopying, NSSecureCoding, NSCoding, DHConfigurationProtocol>
// MARK: - *** 任务基本信息 ***
/// 唯一标识，初始化时创建
@property (nonatomic, copy) NSString *identity;
/// 任务名称
@property (nonatomic, copy) NSString *taskName;
/// 任务类型
@property (nonatomic, assign) DHTaskType taskType;
/// 任务类型名称
@property (nonatomic, readonly) DHTaskTypeName taskTypeName;

#pragma mark - *** DHConfigurationProtocol ***
/// 配置类型
@property (nonatomic, copy) NSString *configurationName;
/// 分发渠道
@property (nonatomic, copy) NSString *channel;
/// 导出.xcarchive路径
@property (nonatomic, copy, nullable) NSString *exportArchiveDirectory;
/// 导出.ipa路径
@property (nonatomic, copy, nullable) NSString *exportIPADirectory;
/// 描述文件搜索路径
@property (nonatomic, copy) NSString *profilesDirectory;
/// 是否保留归档文件
@property (nonatomic, assign, getter=isKeepXcarchive) BOOL keepXcarchive;
/// 是否需要Podfile install
@property (nonatomic, assign, getter=isNeedPodInstall) BOOL needPodInstall;
/// 是否需要更新
@property (nonatomic, assign, getter=isNeedGitPull) BOOL needGitPull;
/// 当当前分支并非目标分支时，是否需要强制切分支，默认NO
@property (nonatomic, assign, getter=isForceGitSwitch) BOOL forceGitSwitch;


#pragma mark *** DHConfigurationProtocol扩展 ***
/// 默认导出的文件路径
@property (nonatomic, readonly) NSString *exportArchiveFile;
/// 默认导出的ipa文件路径
@property (nonatomic, copy) NSString *exportIPAFile;

#pragma mark - *** 记录当前任务选择的信息 ***
/// 路径
@property (nonatomic, copy) NSString *path;

#pragma mark *** Podfile相关 ***
/// Podfile路径
@property (nonatomic, copy) NSString *podfilePath;

#pragma mark *** git相关 ***
/// git地址
@property (nonatomic, copy) NSString *gitFile;
/// 切换分支
@property (nonatomic, copy) NSString *currentBranch;
/// 所有可切换的分支名
@property (nonatomic, nullable) NSArray *branchNameOptions;

#pragma mark *** Archive相关 ***
/// .xcarchive路径
@property (nonatomic, copy) NSString *xcarchiveFile;

#pragma mark *** 工程相关 ***
/// xcodeproj
@property (nonatomic, copy) NSString *currentXcodeprojFile;
/// 可选的xcodeproj
@property (nonatomic, copy) NSArray *xcodeprojFileOptions;
/// xcworkspace
@property (nonatomic, copy) NSString *currentXcworkspaceFile;
/// 当前工程产品名
@property (nonatomic, copy) NSString *currentProductName;
/// 当前工程对应App展示名称
@property (nonatomic, copy) NSString *currentDisplayName;

/// 对应工程scheme
@property (nonatomic, copy) NSString *currentTargetName;
/// 可选的scheme名称
@property (nonatomic, copy) NSArray *targetNameOptions;

/// 工程当前Bundle Id
@property (nonatomic, copy) NSString *currentBundleId;

/// 工程当前TeamId
@property (nonatomic, copy) NSString *currentTeamId;
/// 工程当前TeamName
@property (nonatomic, readonly) NSString *currentTeamName;
/// 可选的teamName
@property (nonatomic, readonly) NSArray *teamNameOptions;
/// 可选的teamId
@property (nonatomic, readonly) NSArray *teamIdOptions;
/// 工程当前版本号
@property (nonatomic, copy) NSString *currentVersion;
/// 工程build版本号
@property (nonatomic, copy) NSString *currentBuildVersion;

/// 工程enable bitcode
@property (nonatomic, copy) NSString *currentEnableBitcode;

#pragma mark *** 工程扩展 ***
/// 工程类型
@property (nonatomic, copy) NSString *engineeringType;
/// 强制设置displayName
@property (nonatomic, assign, getter=isForceSetDisplayName) BOOL forceSetDisplayName;
/// 强制设置ProductName
@property (nonatomic, assign, getter=isForceSetProductName) BOOL forceSetProductName;
/// 强制设置bundleId
@property (nonatomic, assign, getter=isForceSetBundleId) BOOL forceSetBundleId;
/// 强制设置version
@property (nonatomic, assign, getter=isForceSetVersion) BOOL forceSetVersion;
/// 强制设置buildVersion
@property (nonatomic, assign, getter=isForceSetBuildVersion) BOOL forceSetBuildVersion;
/// 强制设置TeamId
@property (nonatomic, assign, getter=isForceSetTeamId) BOOL forceSetTeamId;
/// 强制设置enableBitcode
@property (nonatomic, assign, getter=isForceSetEnableBitcode) BOOL forceSetEnableBitcode;

#pragma mark *** profile相关 ***
/// 描述文件文件路径(.mobileprovision)
@property (nonatomic, copy) NSString *currentProfilePath;
/// 名称
@property (nonatomic, copy) NSString *currentProfileName;
/// bundleId
@property (nonatomic, copy) NSString *currentProfileBundleId;
/// Appid
@property (nonatomic, copy) NSString *currentProfileAppId;
/// Team id
@property (nonatomic, copy) NSString *currentProfileTeamId;
/// Team名称
@property (nonatomic, copy) NSString *currentProfileTeamName;
/// UUID
@property (nonatomic, copy) NSString *currentProfileUUID;
/// 创建时间戳
@property (nonatomic, copy) NSString *currentProfileCreateTimestamp;
/// 过期时间戳
@property (nonatomic, copy) NSString *currentProfileExpireTimestamp;
/// 渠道类型 参考DHChannel
@property (nonatomic, copy) NSString *currentProfileChannel;
/// 可选的profile名称
@property (nonatomic, readonly) NSArray *profileNameOptions;
/// 过期日
@property (nonatomic, readonly, nullable) NSString *currentProfileExpireDays;
/// 期间
@property (nonatomic, readonly, nullable) NSString *currentProfileCreatToExpireTime;

#pragma mark - *** Distribution相关 ***
/// 自定义名称
@property (nonatomic, copy) NSString *currentDistributionNickname;
/// 平台类型
@property (nonatomic, copy) NSString *currentDistributionPlatformType;
/// 平台接口秘钥
@property (nonatomic, copy) NSString *currentDistributionPlatformApiKey;
/// 更新日志
@property (nonatomic, copy, nullable) NSString *currentDistributionChangeLog;
/// 安装密码
@property (nonatomic, copy, nullable) NSString *currentDistributionInstallPassword;
/// 发布者
@property (nonatomic, strong) DHDistributer *currentDistributer;
/// 可选的发布信息
@property (nonatomic, readonly) NSArray *distributionNicknameOptions;

@end

NS_ASSUME_NONNULL_END
