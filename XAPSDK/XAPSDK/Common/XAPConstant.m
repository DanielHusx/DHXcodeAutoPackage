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


XAPKey const kXAPKeyDisplayName = @"CFBundleDisplayName";
XAPKey const kXAPKeyBundleName = @"CFBundleName";
XAPKey const kXAPKeySchemeName = @"SchemeName";
XAPKey const kXAPKeyBundleIdentifier = @"CFBundleIdentifier";
XAPKey const kXAPKeyShortVersion = @"CFBundleShortVersionString";
XAPKey const kXAPKeyVersion = @"CFBundleVersion";
XAPKey const kXAPKeyExecutableFile = @"CFBundleExecutable";
XAPKey const kXAPKeyApplicationPath = @"ApplicationPath";
XAPKey const kXAPKeyApplicationProperties = @"ApplicationProperties";
XAPKey const kXAPKeyName = @"Name";
XAPKey const kXAPKeyTeam = @"Team";
XAPKey const kXAPKeyUUID = @"UUID";
XAPKey const kXAPKeySigningIdentity = @"SigningIdentity";
XAPKey const kXAPKeyArchitectures = @"Architectures";
XAPKey const kXAPKeyCreationDate = @"CreationDate";
XAPKey const kXAPKeyExpirationDate = @"ExpirationDate";
XAPKey const kXAPKeyEntitlements = @"Entitlements";
XAPKey const kXAPKeyTeamName = @"TeamName";
XAPKey const kXAPKeyApplicationIdentifier = @"application-identifier";
XAPKey const kXAPKeyTeamIdentifier = @"com.apple.developer.team-identifier";
XAPKey const kXAPKeyProvisionedDevices = @"ProvisionedDevices";
XAPKey const kXAPKeyGetTaskAllow = @"get-task-allow";
XAPKey const kXAPKeyProvisionsAllDevices = @"ProvisionsAllDevices";

XAPRelativeValue const kXAPRelativeValueTargetName = @"$(TARGET_NAME)";
XAPRelativeValue const kXAPRelativeValueProductName = @"$(PRODUCT_NAME)";
XAPRelativeValue const kXAPRelativeValueBundleIdentifier = @"$(PRODUCT_BUNDLE_IDENTIFIER)";
XAPRelativeValue const kXAPRelativeValueShortVersion = @"$(MARKETING_VERSION)";
XAPRelativeValue const kXAPRelativeValueVersion = @"$(CURRENT_PROJECT_VERSION)";
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
