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

typedef NSString * XAPKey NS_STRING_ENUM;
/// plist 展示名称
FOUNDATION_EXTERN XAPKey const kXAPKeyDisplayName;
/// plist productName标识
FOUNDATION_EXTERN XAPKey const kXAPKeyBundleName;
/// plist Xcarchive下的产品名称
FOUNDATION_EXTERN XAPKey const kXAPKeySchemeName;
/// plist BundleId标识
FOUNDATION_EXTERN XAPKey const kXAPKeyBundleIdentifier;
/// plist 版本号标识
FOUNDATION_EXTERN XAPKey const kXAPKeyShortVersion;
/// plist Build号标识
FOUNDATION_EXTERN XAPKey const kXAPKeyVersion;

/// plist 可执行文件相对路径 —— 理论上只在.app文件的info.plist中有意义
FOUNDATION_EXTERN XAPKey const kXAPKeyExecutableFile;

/// plist .app文件相对路径 —— 只在.xcarchive的info.plist
FOUNDATION_EXTERN XAPKey const kXAPKeyApplicationPath;
/// plist 程序参数 —— 只在.xcarchive的info.plist
FOUNDATION_EXTERN XAPKey const kXAPKeyApplicationProperties;
/// plist team id —— 只在.xcarchive的info.plist
FOUNDATION_EXTERN XAPKey const kXAPKeyTeam;
/// plist uuid —— 只在解析的profile中
FOUNDATION_EXTERN XAPKey const kXAPKeyUUID;
/// plist 签名 —— 只在xcarchive的info.plist
FOUNDATION_EXTERN XAPKey const kXAPKeySigningIdentity;
FOUNDATION_EXTERN XAPKey const kXAPKeyArchitectures;
FOUNDATION_EXTERN XAPKey const kXAPKeyCreationDate;
FOUNDATION_EXTERN XAPKey const kXAPKeyExpirationDate;
FOUNDATION_EXTERN XAPKey const kXAPKeyEntitlements;
FOUNDATION_EXTERN XAPKey const kXAPKeyTeamName;
FOUNDATION_EXTERN XAPKey const kXAPKeyName;
FOUNDATION_EXTERN XAPKey const kXAPKeyApplicationIdentifier;
FOUNDATION_EXTERN XAPKey const kXAPKeyTeamIdentifier;
FOUNDATION_EXTERN XAPKey const kXAPKeyProvisionedDevices;
FOUNDATION_EXTERN XAPKey const kXAPKeyGetTaskAllow;
FOUNDATION_EXTERN XAPKey const kXAPKeyProvisionsAllDevices;

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
