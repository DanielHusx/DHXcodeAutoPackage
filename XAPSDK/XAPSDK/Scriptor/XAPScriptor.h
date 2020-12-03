//
//  XAPScriptor.h
//  XAPSDK
//
//  Created by Daniel on 2020/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XAPScriptModel;
/**
 脚本接口封装类
 */
@interface XAPScriptor : NSObject

// MARK: - inialization
+ (instancetype)sharedInstance;

// MARK: - script
- (void)interrupt;



// MARK: - 编译项目相关
- (void)cleanProjectWithXcworkspaceOrXcodeprojFile:(NSString *)xcworkspaceOrXcodeprojFile
                                   engineeringType:(XAPEngineeringType)engineeringType
                                        targetName:(NSString *)targetName
                                 configurationName:(XAPConfigurationName)configurationName
                                           verbose:(BOOL)verbose
                                             error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (void)archiveProjectWithXcworkspaceOrXcodeprojFile:(NSString *)xcworkspaceOrXcodeprojFile
                                     engineeringType:(XAPEngineeringType)engineeringType
                                          targetName:(NSString *)targetName
                                   configurationName:(XAPConfigurationName)configurationName
                                       xcarchiveFile:(NSString *)xcarchiveFile
                                        architecture:(NSString * _Nullable)architecture
                                            xcconfig:(NSString * _Nullable)xcconfig
                                             verbose:(BOOL)verbose
                                               error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (void)exportProjectIPAFileWithXcarchiveFile:(NSString *)xcarchiveFile
                           exportIPADirectory:(NSString *)exportIPADirectory
                           exportOptionsPlist:(NSString *)exportOptionsPlist
                                      verbose:(BOOL)verbose
                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (void)createExportOptionsPlistFile:(NSString *)exportOptionsPlistFile
                        withBundleId:(NSString *)bundleId
                              teamId:(NSString *)teamId
                             channel:(XAPChannel)channel
                         profileName:(NSString *)profileName
                       enableBitcode:(XAPEnableBitcode)enableBitcode
                               error:(NSError * _Nullable __autoreleasing *)error;

/// 导出
- (void)exportProjectIPAFileWithXcarchiveFile:(NSString *)xcarchiveFile
                           exportIPADirectory:(NSString *)exportIPADirectory
               createExportOptionsPlistAtPath:(NSString *)exportOptionsPlist
                                     bundleId:(NSString *)bundleId
                                       teamId:(NSString *)teamId
                                      channel:(XAPChannel)channel
                                  profileName:(NSString *)profileName
                                enableBitcode:(XAPEnableBitcode)enableBitcode
                                      verbose:(BOOL)verbose
                                        error:(NSError **)error;


// MARK: - project相关
- (NSArray * _Nullable)fetchProjectTargetIdListWithPBXProjFile:(NSString *)pbxprojFile
                                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProjectTargetNameWithPBXProjFile:(NSString *)pbxprojFile
                                                     targetId:(NSString *)targetId
                                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSArray * _Nullable)fetchProjectBuildConfigurationIdListWithPBXProjFile:(NSString *)pbxprojFile
                                                                  targetId:(NSString *)targetId
                                                                     error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProjectBuildConfigurationNameWithPBXProjFile:(NSString *)pbxprojFile
                                                     buildConfigurationId:(NSString *)buildConfigurationId
                                                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error;


- (NSString * _Nullable)fetchProjectProductNameWithPBXProjFile:(NSString *)pbxprojFile
                                          buildConfigurationId:(NSString *)buildConfigurationId
                                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProjectBundleIdentifierWithPBXProjFile:(NSString *)pbxprojFile
                                               buildConfigurationId:(NSString *)buildConfigurationId
                                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProjectEnableBitcodeWithPBXProjFile:(NSString *)pbxprojFile
                                            buildConfigurationId:(NSString *)buildConfigurationId
                                                           error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProjectShortVersionWithPBXProjFile:(NSString *)pbxprojFile
                                           buildConfigurationId:(NSString *)buildConfigurationId
                                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProjectVersionWithPBXProjFile:(NSString *)pbxprojFile
                                      buildConfigurationId:(NSString *)buildConfigurationId
                                                     error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProjectTeamIdentifierWithPBXProjFile:(NSString *)pbxprojFile
                                             buildConfigurationId:(NSString *)buildConfigurationId
                                                            error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProjectInfoPlistFileWithPBXProjFile:(NSString *)pbxprojFile
                                            buildConfigurationId:(NSString *)buildConfigurationId
                                                           error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProjectBuildSettingsValueWithPBXProjFile:(NSString *)pbxprojFile
                                                 buildConfigurationId:(NSString *)buildConfigurationId
                                                     buildSettingsKey:(NSString *)buildSettingsKey
                                                                error:(NSError * _Nullable __autoreleasing * _Nullable)error;


// MARK: - profile相关
- (NSDictionary * _Nullable)fetchProfileInfoWithProfile:(NSString *)profile
                                            profileName:(NSString * _Nullable __autoreleasing * _Nullable)profileName
                                       bundleIdentifier:(NSString * _Nullable __autoreleasing * _Nullable)bundleIdentifier
                                         teamIdentifier:(NSString * _Nullable __autoreleasing * _Nullable)teamIdentifier
                                  applicationIdentifier:(NSString * _Nullable __autoreleasing * _Nullable)applicationIdentifier
                                                   uuid:(NSString * _Nullable __autoreleasing * _Nullable)uuid
                                               teamName:(NSString * _Nullable __autoreleasing * _Nullable)teamName
                                                channel:(NSString * _Nullable __autoreleasing * _Nullable)channel
                                        createTimestamp:(NSString * _Nullable __autoreleasing * _Nullable)createTimestamp
                                        expireTimestamp:(NSString * _Nullable __autoreleasing * _Nullable)expireTimestamp
                                           entitlements:(NSDictionary * _Nullable __autoreleasing * _Nullable)entitlements
                                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProfileCreateTimestampWithProfile:(NSString *)profile
                                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProfileExpireTimestampWithProfile:(NSString *)profile
                                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProfileNameWithProfile:(NSString *)profile
                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProfileAppIdentifierWithProfile:(NSString *)profile
                                                       error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProfileBundleIdentifierWithProfile:(NSString *)profile
                                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProfileTeamIdentifierWithProfile:(NSString *)profile
                                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProfileTeamNameWithProfile:(NSString *)profile
                                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchProfileUUIDWithProfile:(NSString *)profile
                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (XAPChannel)fetchProfileChannelWithProfile:(NSString *)profile
                                       error:(NSError * _Nullable __autoreleasing * _Nullable)error;


// MARK: - git相关
- (NSString * _Nullable)gitCurrentBranchWithGitDirectory:(NSString *)gitDirectory
                                                   error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)gitStatusWithGitDirectory:(NSString *)gitDirectory
                                            error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (BOOL)gitAddAllWithGitDirectory:(NSString *)gitDirectory
                            error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (BOOL)gitStashWithGitDirectory:(NSString *)gitDirectory
                           error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (BOOL)gitResetToHeadWithGitDirectory:(NSString *)gitDirectory
                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)gitPullWithGitDirectory:(NSString *)gitDirectory
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)gitCheckoutBranchWithGitDirectory:(NSString *)gitDirectory
                                               branchName:(NSString *)branchName
                                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSArray * _Nullable)fetchGitBranchListWithGitDirectory:(NSString *)gitDirectory
                                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSArray * _Nullable)fetchGitTagListWithGitDirectory:(NSString *)gitDirectory
                                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSArray * _Nullable)fetchGitBranchsWithGitDirectory:(NSString *)gitDirectory
                                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error;


// MARK: - pod相关
- (BOOL)podInstallWithPodfileDirectory:(NSString *)podfileDirectory
                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error;


// MARK: - info.plist相关
- (NSString * _Nullable)fetchInfoPlistProductNameWithInfoPlist:(NSString *)infoPlist
                                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchInfoPlistDisplayNameWithInfoPlist:(NSString *)infoPlist
                                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchInfoPlistBundleIdentifierWithInfoPlist:(NSString *)infoPlist
                                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchInfoPlistShortVersionWithInfoPlist:(NSString *)infoPlist
                                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchInfoPlistVersionWithInfoPlist:(NSString *)infoPlist
                                                     error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchInfoPlistExecutableFileWithInfoPlist:(NSString *)infoPlist
                                                            error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)plistFetchAttributeWithInfoPlist:(NSString *)infoPlist
                                            attributeKey:(NSString *)attributeKey
                                                   error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (BOOL)plistAppendAttributeWithInfoPlist:(NSString *)infoPlist
                             attributeKey:(NSString *)attributeKey
                           attributeValue:(NSString *)attributeValue
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (BOOL)plistDeleteAttributeWithInfoPlist:(NSString *)infoPlist
                             attributeKey:(NSString *)attributeKey
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (BOOL)plistModifyAttributeWithInfoPlist:(NSString *)infoPlist
                             attributeKey:(NSString *)attributeKey
                           attributeValue:(NSString *)attributeValue
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error;


#pragma mark - app相关
- (XAPEnableBitcode)fetchAppEnableBitcodeWithExecutableFile:(NSString *)executableFile
                                                      error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchAppCodesignIdentifierWithAppFile:(NSString *)appFile
                                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error;

- (NSString * _Nullable)fetchAppArchitecturesWithExecutableFile:(NSString *)executableFile
                                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
