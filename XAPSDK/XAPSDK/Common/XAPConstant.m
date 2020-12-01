//
//  XAPConstant.m
//  XAPSDK
//
//  Created by Daniel on 2020/11/30.
//

#import "XAPConstant.h"


XAPBuildSettingsKey const kXAPBuildSettingsKeyName = @"name";
XAPBuildSettingsKey const kXAPBuildSettingsKeyProductName = @"PRODUCT_NAME";
XAPBuildSettingsKey const kXAPBuildSettingsKeyBundleIdentifier = @"PRODUCT_BUNDLE_IDENTIFIER";
XAPBuildSettingsKey const kXAPBuildSettingsKeyEnableBitcode = @"ENABLE_BITCODE";
XAPBuildSettingsKey const kXAPBuildSettingsKeyShortVersion = @"MARKETING_VERSION";
XAPBuildSettingsKey const kXAPBuildSettingsKeyVersion = @"CURRENT_PROJECT_VERSION";
XAPBuildSettingsKey const kXAPBuildSettingsKeyTeamIdentifier = @"DEVELOPMENT_TEAM";
XAPBuildSettingsKey const kXAPBuildSettingsKeyInfoPlistFile = @"INFOPLIST_FILE";


XAPPlistKey const kXAPPlistKeyDisplayName = @"CFBundleDisplayName";
XAPPlistKey const kXAPPlistKeyProductName = @"CFBundleName";
XAPPlistKey const kXAPPlistKeyBundleIdentifier = @"CFBundleIdentifier";
XAPPlistKey const kXAPPlistKeyVersion = @"CFBundleShortVersionString";
XAPPlistKey const kXAPPlistKeyBuildVersion = @"CFBundleVersion";
XAPPlistKey const kXAPPlistKeyTeamIdentifier = @"teamID";
XAPPlistKey const kXAPPlistKeyEnableBitcode = @"compileBitcode";
XAPPlistKey const kXAPPlistKeyMinimumOSVersion = @"MinimumOSVersion";
XAPPlistKey const kXAPPlistKeyExecutableFile = @"CFBundleExecutable";
XAPPlistKey const kXAPPlistKeyApplicationPath = @"ApplicationPath";
XAPPlistKey const kXAPPlistKeyApplicationProperties = @"ApplicationProperties";
XAPPlistKey const kXAPPlistKeyTeam = @"Team";
XAPPlistKey const kXAPPlistKeySigningIdentity = @"SigningIdentity";


XAPRelativeValue const kXAPRelativeValueTargetName = @"$(TARGET_NAME)";
XAPRelativeValue const kXAPRelativeValueProductName = @"$(PRODUCT_NAME)";
XAPRelativeValue const kXAPRelativeValueBundleIdentifier = @"$(PRODUCT_BUNDLE_IDENTIFIER)";
XAPRelativeValue const kXAPRelativeValueVersion = @"$(MARKETING_VERSION)";
XAPRelativeValue const kXAPRelativeValueBuildVersion = @"$(CURRENT_PROJECT_VERSION)";
XAPRelativeValue const kXAPRelativeValueExecutableFile = @"$(EXECUTABLE_NAME)";
XAPRelativeValue const kXAPRelativeValueSRCROOT = @"$(SRCROOT)";
XAPRelativeValue const kXAPRelativeValuePROJECT_DIR = @"$(PROJECT_DIR)";


XAPConfigurationName const kXAPConfigurationNameDebug = @"Debug";
XAPConfigurationName const kXAPConfigurationNameRelease = @"Release";


XAPEngineeringType const kXAPEngineeringTypeProject = @"project";
XAPEngineeringType const kXAPEngineeringTypeWorkspace = @"workspace";


XAPChannel const kXAPChannelUnknown = @"unknown";
XAPChannel const kXAPChannelDevelopment = @"development";
XAPChannel const kXAPChannelAdHoc = @"ad-hoc";
XAPChannel const kXAPChannelEnterprise = @"enterprise";
XAPChannel const kXAPChannelAppStore = @"app-store";


XAPEnableBitcode const kXAPEnableBitcodeYES = @"YES";
XAPEnableBitcode const kXAPEnableBitcodeNO = @"NO";


XAPXMLBoolean const kXAPXMLBooleanTrue = @"<true/>";
XAPXMLBoolean const kXAPXMLBooleanFalse = @"<false/>";


XAPDistributionPlatform const kXAPDistributionPlatformNone = @"daniel.distribute.none";
XAPDistributionPlatform const kXAPDistributionPlatformPgyer = @"daniel.distribute.pgyer";
XAPDistributionPlatform const kXAPDistributionPlatformFir = @"daniel.distribute.fir";
