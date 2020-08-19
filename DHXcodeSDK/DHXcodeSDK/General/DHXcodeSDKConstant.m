//
//  DHXcodeSDKConstant.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/7/30.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHXcodeSDKConstant.h"

DHBuildSettingsKey const kDHBuildSettingsKeyName = @"name";
DHBuildSettingsKey const kDHBuildSettingsKeyProductName = @"PRODUCT_NAME";
DHBuildSettingsKey const kDHBuildSettingsKeyBundleIdentifier = @"PRODUCT_BUNDLE_IDENTIFIER";
DHBuildSettingsKey const kDHBuildSettingsKeyEnableBitcode = @"ENABLE_BITCODE";
DHBuildSettingsKey const kDHBuildSettingsKeyVersion = @"MARKETING_VERSION";
DHBuildSettingsKey const kDHBuildSettingsKeyBuildVersion = @"CURRENT_PROJECT_VERSION";
DHBuildSettingsKey const kDHBuildSettingsKeyTeamIdentifier = @"DEVELOPMENT_TEAM";
DHBuildSettingsKey const kDHBuildSettingsKeyInfoPlistFile = @"INFOPLIST_FILE";


DHPlistKey const kDHPlistKeyDisplayName = @"CFBundleDisplayName";
DHPlistKey const kDHPlistKeyProductName = @"CFBundleName";
DHPlistKey const kDHPlistKeyBundleIdentifier = @"CFBundleIdentifier";
DHPlistKey const kDHPlistKeyVersion = @"CFBundleShortVersionString";
DHPlistKey const kDHPlistKeyBuildVersion = @"CFBundleVersion";
DHPlistKey const kDHPlistKeyTeamIdentifier = @"teamID";
DHPlistKey const kDHPlistKeyEnableBitcode = @"compileBitcode";
DHPlistKey const kDHPlistKeyMinimumOSVersion = @"MinimumOSVersion";
DHPlistKey const kDHPlistKeyExecutableFile = @"CFBundleExecutable";
DHPlistKey const kDHPlistKeyApplicationPath = @"ApplicationPath";
DHPlistKey const kDHPlistKeyApplicationProperties = @"ApplicationProperties";
DHPlistKey const kDHPlistKeyTeam = @"Team";
DHPlistKey const kDHPlistKeySigningIdentity = @"SigningIdentity";


DHRelativeValue const kDHRelativeValueTargetName = @"$(TARGET_NAME)";
DHRelativeValue const kDHRelativeValueProductName = @"$(PRODUCT_NAME)";
DHRelativeValue const kDHRelativeValueBundleIdentifier = @"$(PRODUCT_BUNDLE_IDENTIFIER)";
DHRelativeValue const kDHRelativeValueVersion = @"$(MARKETING_VERSION)";
DHRelativeValue const kDHRelativeValueBuildVersion = @"$(CURRENT_PROJECT_VERSION)";
DHRelativeValue const kDHRelativeValueExecutableFile = @"$(EXECUTABLE_NAME)";
DHRelativeValue const kDHRelativeValueSRCROOT = @"$(SRCROOT)";
DHRelativeValue const kDHRelativeValuePROJECT_DIR = @"$(PROJECT_DIR)";


DHConfigurationName const kDHConfigurationNameDebug = @"Debug";
DHConfigurationName const kDHConfigurationNameRelease = @"Release";


DHEngineeringType const kDHEngineeringTypeProject = @"project";
DHEngineeringType const kDHEngineeringTypeWorkspace = @"workspace";


DHChannel const kDHChannelUnknown = @"unknown";
DHChannel const kDHChannelDevelopment = @"development";
DHChannel const kDHChannelAdHoc = @"ad-hoc";
DHChannel const kDHChannelEnterprise = @"enterprise";
DHChannel const kDHChannelAppStore = @"app-store";


DHEnableBitcode const kDHEnableBitcodeYES = @"YES";
DHEnableBitcode const kDHEnableBitcodeNO = @"NO";


DHXMLBoolean const kDHXMLBooleanTrue = @"<true/>";
DHXMLBoolean const kDHXMLBooleanFalse = @"<false/>";


DHDistributionPlatform const kDHDistributionPlatformNone = @"daniel.distribute.none";
DHDistributionPlatform const kDHDistributionPlatformPgyer = @"daniel.distribute.pgyer";
DHDistributionPlatform const kDHDistributionPlatformFir = @"daniel.distribute.fir";

