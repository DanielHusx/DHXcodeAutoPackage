//
//  DHXcodeSDKConstant.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/7/30.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * DHBuildSettingsKey NS_STRING_ENUM;

/// 配置名称标识——一般值为Debug/Release
FOUNDATION_EXTERN DHBuildSettingsKey const kDHBuildSettingsKeyName;
/// 配置productName标识
FOUNDATION_EXTERN DHBuildSettingsKey const kDHBuildSettingsKeyProductName;
/// 配置BundleId标识
FOUNDATION_EXTERN DHBuildSettingsKey const kDHBuildSettingsKeyBundleIdentifier;
/// 配置EnableBitcode标识——一般值为YES/NO
FOUNDATION_EXTERN DHBuildSettingsKey const kDHBuildSettingsKeyEnableBitcode;
/// 配置版本号标识
FOUNDATION_EXTERN DHBuildSettingsKey const kDHBuildSettingsKeyVersion;
/// 配置Build号标识
FOUNDATION_EXTERN DHBuildSettingsKey const kDHBuildSettingsKeyBuildVersion;
/// 配置TeamId标识
FOUNDATION_EXTERN DHBuildSettingsKey const kDHBuildSettingsKeyTeamIdentifier;
/// 配置info.plist的路径
FOUNDATION_EXTERN DHBuildSettingsKey const kDHBuildSettingsKeyInfoPlistFile;

typedef NSString * DHPlistKey NS_STRING_ENUM;
/// plist 展示名称
FOUNDATION_EXTERN DHPlistKey const kDHPlistKeyDisplayName;
/// plist productName标识
FOUNDATION_EXTERN DHPlistKey const kDHPlistKeyProductName;
/// plist BundleId标识
FOUNDATION_EXTERN DHPlistKey const kDHPlistKeyBundleIdentifier;
/// plist 版本号标识
FOUNDATION_EXTERN DHPlistKey const kDHPlistKeyVersion;
/// plist Build号标识
FOUNDATION_EXTERN DHPlistKey const kDHPlistKeyBuildVersion;

/// plist EnableBitcode标识 —— 只能用于创建
FOUNDATION_EXTERN DHPlistKey const kDHPlistKeyEnableBitcode;
/// plist TeamId标识 —— 只能用于创建
FOUNDATION_EXTERN DHPlistKey const kDHPlistKeyTeamIdentifier;

/// plist 最小支持系统版本 —— 一般只在.app文件的info.plist中
FOUNDATION_EXTERN DHPlistKey const kDHPlistKeyMinimumOSVersion;
/// plist 可执行文件相对路径 —— 理论上只在.app文件的info.plist中有意义
FOUNDATION_EXTERN DHPlistKey const kDHPlistKeyExecutableFile;

/// plist .app文件相对路径 —— 只在.xcarchive的info.plist
FOUNDATION_EXTERN DHPlistKey const kDHPlistKeyApplicationPath;
/// plist 程序参数 —— 只在.xcarchive的info.plist
FOUNDATION_EXTERN DHPlistKey const kDHPlistKeyApplicationProperties;
/// plist team id —— 只在.xcarchive的info.plist
FOUNDATION_EXTERN DHPlistKey const kDHPlistKeyTeam;
/// plist 签名 —— 只在xcarchive的info.plist
FOUNDATION_EXTERN DHPlistKey const kDHPlistKeySigningIdentity;

/// 关联值，类似$(TARGET_NAME)
typedef NSString * DHRelativeValue NS_STRING_ENUM;
FOUNDATION_EXTERN DHRelativeValue const kDHRelativeValueTargetName;
FOUNDATION_EXTERN DHRelativeValue const kDHRelativeValueProductName;
FOUNDATION_EXTERN DHRelativeValue const kDHRelativeValueBundleIdentifier;
FOUNDATION_EXTERN DHRelativeValue const kDHRelativeValueVersion;
FOUNDATION_EXTERN DHRelativeValue const kDHRelativeValueBuildVersion;
FOUNDATION_EXTERN DHRelativeValue const kDHRelativeValueExecutableFile;
FOUNDATION_EXTERN DHRelativeValue const kDHRelativeValueSRCROOT;
FOUNDATION_EXTERN DHRelativeValue const kDHRelativeValuePROJECT_DIR;

typedef NSString * DHConfigurationName NS_STRING_ENUM;

FOUNDATION_EXTERN DHConfigurationName const kDHConfigurationNameDebug;
FOUNDATION_EXTERN DHConfigurationName const kDHConfigurationNameRelease;

typedef NSString * DHEngineeringType NS_STRING_ENUM;

FOUNDATION_EXTERN DHEngineeringType const kDHEngineeringTypeProject;
FOUNDATION_EXTERN DHEngineeringType const kDHEngineeringTypeWorkspace;

typedef NSString * DHChannel NS_STRING_ENUM;

FOUNDATION_EXTERN DHChannel const kDHChannelUnknown;
FOUNDATION_EXTERN DHChannel const kDHChannelDevelopment;
FOUNDATION_EXTERN DHChannel const kDHChannelAdHoc;
FOUNDATION_EXTERN DHChannel const kDHChannelEnterprise;
FOUNDATION_EXTERN DHChannel const kDHChannelAppStore;

typedef NSString * DHEnableBitcode NS_STRING_ENUM;

FOUNDATION_EXTERN DHEnableBitcode const kDHEnableBitcodeYES;
FOUNDATION_EXTERN DHEnableBitcode const kDHEnableBitcodeNO;

typedef NSString * DHXMLBoolean NS_STRING_ENUM;

FOUNDATION_EXTERN DHXMLBoolean const kDHXMLBooleanTrue;
FOUNDATION_EXTERN DHXMLBoolean const kDHXMLBooleanFalse;

typedef NSString * DHDistributionPlatform NS_STRING_ENUM;

FOUNDATION_EXTERN DHDistributionPlatform const kDHDistributionPlatformNone;
FOUNDATION_EXTERN DHDistributionPlatform const kDHDistributionPlatformPgyer;
FOUNDATION_EXTERN DHDistributionPlatform const kDHDistributionPlatformFir;





NS_ASSUME_NONNULL_END
