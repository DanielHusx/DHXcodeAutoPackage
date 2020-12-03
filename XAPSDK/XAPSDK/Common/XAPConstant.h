//
//  XAPConstant.h
//  XAPSDK
//
//  Created by Daniel on 2020/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NSString * XAPBuildSettingsKey NS_STRING_ENUM;

/// 配置名称标识——一般值为Debug/Release
FOUNDATION_EXTERN XAPBuildSettingsKey const kXAPBuildSettingsKeyName;
/// 配置productName标识
FOUNDATION_EXTERN XAPBuildSettingsKey const kXAPBuildSettingsKeyProductName;
/// 配置BundleId标识
FOUNDATION_EXTERN XAPBuildSettingsKey const kXAPBuildSettingsKeyBundleIdentifier;
/// 配置EnableBitcode标识——一般值为YES/NO
FOUNDATION_EXTERN XAPBuildSettingsKey const kXAPBuildSettingsKeyEnableBitcode;
/// 配置版本号标识
FOUNDATION_EXTERN XAPBuildSettingsKey const kXAPBuildSettingsKeyShortVersion;
/// 配置Build号标识
FOUNDATION_EXTERN XAPBuildSettingsKey const kXAPBuildSettingsKeyVersion;
/// 配置TeamId标识
FOUNDATION_EXTERN XAPBuildSettingsKey const kXAPBuildSettingsKeyTeamIdentifier;
/// 配置info.plist的路径
FOUNDATION_EXTERN XAPBuildSettingsKey const kXAPBuildSettingsKeyInfoPlistFile;

typedef NSString * XAPPlistKey NS_STRING_ENUM;
/// plist 展示名称
FOUNDATION_EXTERN XAPPlistKey const kXAPPlistKeyDisplayName;
/// plist productName标识
FOUNDATION_EXTERN XAPPlistKey const kXAPPlistKeyProductName;
/// plist BundleId标识
FOUNDATION_EXTERN XAPPlistKey const kXAPPlistKeyBundleIdentifier;
/// plist 版本号标识
FOUNDATION_EXTERN XAPPlistKey const kXAPPlistKeyShortVersion;
/// plist Build号标识
FOUNDATION_EXTERN XAPPlistKey const kXAPPlistKeyVersion;

/// plist EnableBitcode标识 —— 只能用于创建
FOUNDATION_EXTERN XAPPlistKey const kXAPPlistKeyEnableBitcode;
/// plist TeamId标识 —— 只能用于创建
FOUNDATION_EXTERN XAPPlistKey const kXAPPlistKeyTeamIdentifier;

/// plist 最小支持系统版本 —— 一般只在.app文件的info.plist中
FOUNDATION_EXTERN XAPPlistKey const kXAPPlistKeyMinimumOSVersion;
/// plist 可执行文件相对路径 —— 理论上只在.app文件的info.plist中有意义
FOUNDATION_EXTERN XAPPlistKey const kXAPPlistKeyExecutableFile;

/// plist .app文件相对路径 —— 只在.xcarchive的info.plist
FOUNDATION_EXTERN XAPPlistKey const kXAPPlistKeyApplicationPath;
/// plist 程序参数 —— 只在.xcarchive的info.plist
FOUNDATION_EXTERN XAPPlistKey const kXAPPlistKeyApplicationProperties;
/// plist team id —— 只在.xcarchive的info.plist
FOUNDATION_EXTERN XAPPlistKey const kXAPPlistKeyTeam;
/// plist uuid —— 只在解析的profile中
FOUNDATION_EXTERN XAPPlistKey const kXAPPlistKeyUUID;
/// plist 签名 —— 只在xcarchive的info.plist
FOUNDATION_EXTERN XAPPlistKey const kXAPPlistKeySigningIdentity;

/// 关联值，类似$(TARGET_NAME)
typedef NSString * XAPRelativeValue NS_STRING_ENUM;
FOUNDATION_EXTERN XAPRelativeValue const kXAPRelativeValueTargetName;
FOUNDATION_EXTERN XAPRelativeValue const kXAPRelativeValueProductName;
FOUNDATION_EXTERN XAPRelativeValue const kXAPRelativeValueBundleIdentifier;
FOUNDATION_EXTERN XAPRelativeValue const kXAPRelativeValueShortVersion;
FOUNDATION_EXTERN XAPRelativeValue const kXAPRelativeValueVersion;
FOUNDATION_EXTERN XAPRelativeValue const kXAPRelativeValueExecutableFile;
FOUNDATION_EXTERN XAPRelativeValue const kXAPRelativeValueSRCROOT;
FOUNDATION_EXTERN XAPRelativeValue const kXAPRelativeValuePROJECT_DIR;

typedef NSString * XAPConfigurationName NS_STRING_ENUM;

FOUNDATION_EXTERN XAPConfigurationName const kXAPConfigurationNameDebug;
FOUNDATION_EXTERN XAPConfigurationName const kXAPConfigurationNameRelease;

typedef NSString * XAPEngineeringType NS_STRING_ENUM;

FOUNDATION_EXTERN XAPEngineeringType const kXAPEngineeringTypeProject;
FOUNDATION_EXTERN XAPEngineeringType const kXAPEngineeringTypeWorkspace;

typedef NSString * XAPChannel NS_STRING_ENUM;

FOUNDATION_EXTERN XAPChannel const kXAPChannelUnknown;
FOUNDATION_EXTERN XAPChannel const kXAPChannelDevelopment;
FOUNDATION_EXTERN XAPChannel const kXAPChannelAdHoc;
FOUNDATION_EXTERN XAPChannel const kXAPChannelEnterprise;
FOUNDATION_EXTERN XAPChannel const kXAPChannelAppStore;

typedef NSString * XAPEnableBitcode NS_STRING_ENUM;

FOUNDATION_EXTERN XAPEnableBitcode const kXAPEnableBitcodeYES;
FOUNDATION_EXTERN XAPEnableBitcode const kXAPEnableBitcodeNO;

typedef NSString * XAPXMLBoolean NS_STRING_ENUM;

FOUNDATION_EXTERN XAPXMLBoolean const kXAPXMLBooleanTrue;
FOUNDATION_EXTERN XAPXMLBoolean const kXAPXMLBooleanFalse;

typedef NSString * XAPDistributionPlatform NS_STRING_ENUM;

FOUNDATION_EXTERN XAPDistributionPlatform const kXAPDistributionPlatformNone;
FOUNDATION_EXTERN XAPDistributionPlatform const kXAPDistributionPlatformPgyer;
FOUNDATION_EXTERN XAPDistributionPlatform const kXAPDistributionPlatformFir;



NS_ASSUME_NONNULL_END
