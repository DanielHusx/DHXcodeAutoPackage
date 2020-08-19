//
//  DHScriptCommand.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/18.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 封装执行命令，不暴露脚本任何信息，且不做参数校验
 */
@interface DHScriptCommand : NSObject
// MARK: - other
+ (BOOL)cleanProjectWithXcworkspaceOrXcodeprojFile:(NSString *)xcworkspaceOrXcodeprojFile
                                   engineeringType:(DHEngineeringType)engineeringType
                                        targetName:(NSString *)targetName
                                 configurationName:(DHConfigurationName)configurationName
                                             error:(NSError * _Nullable __autoreleasing * _Nullable)error;

+ (BOOL)archiveProjectWithXcworkspaceOrXcodeprojFile:(NSString *)xcworkspaceOrXcodeprojFile
                                     engineeringType:(DHEngineeringType)engineeringType
                                          targetName:(NSString *)targetName
                                   configurationName:(DHConfigurationName)configurationName
                                       xcarchiveFile:(NSString *)xcarchiveFile
                                               error:(NSError * _Nullable __autoreleasing * _Nullable)error;

+ (BOOL)exportProjectIPAFileWithXcarchiveFile:(NSString *)xcarchiveFile
                           exportIPADirectory:(NSString *)exportIPADirectory
                           exportOptionsPlist:(NSString *)exportOptionsPlist
                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error;
/// 创建exportOptions.plist文件
+ (BOOL)createExportOptionsPlistFile:(NSString *)exportOptionsPlistFile
                        withBundleId:(NSString *)bundleId
                              teamId:(NSString *)teamId
                             channel:(DHChannel)channel
                         profileName:(NSString *)profileName
                       enableBitcode:(DHEnableBitcode)enableBitcode
                               error:(NSError * _Nullable __autoreleasing * _Nullable)error;

/// 导出
+ (BOOL)exportProjectIPAFileWithXcarchiveFile:(NSString *)xcarchiveFile
                           exportIPADirectory:(NSString *)exportIPADirectory
               createExportOptionsPlistAtPath:(nullable NSString *)exportOptionsPlist
                                     bundleId:(NSString *)bundleId
                                       teamId:(NSString *)teamId
                                      channel:(DHChannel)channel
                                  profileName:(NSString *)profileName
                                enableBitcode:(DHEnableBitcode)enableBitcode
                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error;

// MARK: - project相关
+ (BOOL)fetchProjectTargetIdListWithXcodeprojFile:(NSString *)xcodeprojFile
                                           output:(NSArray * _Nullable __autoreleasing * _Nullable)output
                                            error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProjectTargetNameWithXcodeprojFile:(NSString *)xcodeprojFile
                                       targetId:(NSString *)targetId
                                         output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProjectBuildConfigurationIdListWithXcodeprojFile:(NSString *)xcodeprojFile
                                                     targetId:(NSString *)targetId
                                                       output:(NSArray * _Nullable __autoreleasing * _Nullable)output
                                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProjectBuildConfigurationNameWithXcodeprojFile:(NSString *)xcodeprojFile
                                     buildConfigurationId:(NSString *)buildConfigurationId
                                                   output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error;
/// 获取的是PRODUCT_NAME，一般来说是$(TARGET_NAME)，并不是真正的展示名称，需要上层自行解析
+ (BOOL)fetchProjectProductNameWithXcodeprojFile:(NSString *)xcodeprojFile
                            buildConfigurationId:(NSString *)buildConfigurationId
                                          output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                           error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProjectBundleIdentifierWithXcodeprojFile:(NSString *)xcodeprojFile
                                 buildConfigurationId:(NSString *)buildConfigurationId
                                               output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                                error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProjectEnableBitcodeWithXcodeprojFile:(NSString *)xcodeprojFile
                              buildConfigurationId:(NSString *)buildConfigurationId
                                            output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                             error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProjectShortVersionWithXcodeprojFile:(NSString *)xcodeprojFile
                             buildConfigurationId:(NSString *)buildConfigurationId
                                           output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                            error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProjectBuildVersionWithXcodeprojFile:(NSString *)xcodeprojFile
                             buildConfigurationId:(NSString *)buildConfigurationId
                                           output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                            error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProjectTeamIdentifierWithXcodeprojFile:(NSString *)xcodeprojFile
                               buildConfigurationId:(NSString *)buildConfigurationId
                                             output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProjectInfoPlistFileWithXcodeprojFile:(NSString *)xcodeprojFile
                              buildConfigurationId:(NSString *)buildConfigurationId
                                            output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                             error:(NSError * _Nullable __autoreleasing * _Nullable)error;
/// 获取指定buildSettings内buildSettingsKey对应的值
+ (BOOL)fetchProjectBuildSettingsValueWithXcodeprojFile:(NSString *)xcodeprojFile
                                   buildConfigurationId:(NSString *)buildConfigurationId
                                       buildSettingsKey:(NSString *)buildSettingsKey
                                                 output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error;


// MARK: - profile相关
+ (BOOL)fetchProfileCreateTimestampWithProfile:(NSString *)profile
                                        output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProfileExpireTimestampWithProfile:(NSString *)profile
                                        output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProfileAppIdentifierWithProfile:(NSString *)profile
                                      output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                       error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProfileNameWithProfile:(NSString *)profile
                             output:(NSString * _Nullable __autoreleasing * _Nullable)output
                              error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProfileBundleIdentifierWithProfile:(NSString *)profile
                                         output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProfileTeamNameWithProfile:(NSString *)profile
                                 output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProfileTeamIdentifierWithProfile:(NSString *)profile
                                       output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProfileUUIDWithProfile:(NSString *)profile
                             output:(NSString * _Nullable __autoreleasing * _Nullable)output
                              error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchProfileChannelWithProfile:(NSString *)profile
                                output:(DHChannel _Nullable __autoreleasing * _Nullable)output
                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error;


// MARK: - git相关
+ (BOOL)gitCurrentBranchWithGitDirectory:(NSString *)gitDirectory
                                  output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                   error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)gitStatusWithGitDirectory:(NSString *)gitDirectory
                           output:(NSString * _Nullable __autoreleasing * _Nullable)output
                            error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)gitAddAllWithGitDirectory:(NSString *)gitDirectory
                           output:(NSString * _Nullable __autoreleasing * _Nullable)output
                            error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)gitStashWithGitDirectory:(NSString *)gitDirectory
                          output:(NSString * _Nullable __autoreleasing * _Nullable)output
                           error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)gitResetToHeadWithGitDirectory:(NSString *)gitDirectory
                                output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)gitPullWithGitDirectory:(NSString *)gitDirectory
                         output:(NSString * _Nullable __autoreleasing * _Nullable)output
                          error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)gitCheckoutBranchWithGitDirectory:(NSString *)gitDirectory
                               branchName:(NSString *)branchName
                                   output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchGitBranchListWithGitDirectory:(NSString *)gitDirectory
                                    output:(NSArray * _Nullable __autoreleasing * _Nullable)output
                                     error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchGitTagListWithGitDirectory:(NSString *)gitDirectory
                                 output:(NSArray * _Nullable __autoreleasing * _Nullable)output
                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error;


// MARK: - pod相关
+ (BOOL)podInstallWithPodfileDirectory:(NSString *)podfileDirectory
                                output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error;


// MARK: - plist相关
+ (BOOL)fetchInfoPlistProductNameWithInfoPlist:(NSString *)infoPlist
                                        output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchInfoPlistDisplayNameWithInfoPlist:(NSString *)infoPlist
                                        output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchInfoPlistBundleIdentifierWithInfoPlist:(NSString *)infoPlist
                                     output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                      error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchInfoPlistShortVersionWithInfoPlist:(NSString *)infoPlist
                                         output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchInfoPlistBuildVersionWithInfoPlist:(NSString *)infoPlist
                                         output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error;
/// .app文件内的info.plist才有，获取的是相对路径
+ (BOOL)fetchInfoPlistExecutableFileWithInfoPlist:(NSString *)infoPlist
                                           output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                            error:(NSError * _Nullable __autoreleasing * _Nullable)error;
/// .app文件内的info.plist才有
+ (BOOL)fetchInfoPlistMinimumOSVersionWithInfoPlist:(NSString *)infoPlist
                                             output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)plistFetchAttributeWithInfoPlist:(NSString *)infoPlist
                            attributeKey:(NSString *)attributeKey
                                  output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                   error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)plistAppendAttributeWithInfoPlist:(NSString *)infoPlist
                             attributeKey:(NSString *)attributeKey
                           attributeValue:(NSString *)attributeValue
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)plistDeleteAttributeWithInfoPlist:(NSString *)infoPlist
                             attributeKey:(NSString *)attributeKey
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)plistModifyAttributeWithInfoPlist:(NSString *)infoPlist
                             attributeKey:(NSString *)attributeKey
                           attributeValue:(NSString *)attributeValue
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error;

// MARK: - app相关
+ (BOOL)fetchAppEnableBitcodeWithExecutableFile:(NSString *)executableFile
                                         output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchAppCodesignIdentifierWithAppFile:(NSString *)appFile
                                       output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error;
+ (BOOL)fetchAppArchitecturesWithExecutableFile:(NSString *)executableFile
                                         output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error;

// MARK: -
+ (void)interrupt;

@end

NS_ASSUME_NONNULL_END
