//
//  DHScriptFactory.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/17.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHScriptModel;
NS_ASSUME_NONNULL_BEGIN
/**
 命令工厂
 */
@interface DHScriptFactory : NSObject
// MARK: - xcodebuild相关命令
/// 清理工程命令
/// @param workspaceFileOrXcodeprojFile 工程文件路径(.xcodeproj/.xcworkspace)
/// @param engineeringType 工程类型(project/workspace)
/// @param scheme 对应工程的Target的名称
/// @param configuration 配置类型(Debug/Release)
/// @param verbose  是否需要详细信息
+ (DHScriptModel *)fetchXcodebuildEngineeringCleanCommand:(NSString *)workspaceFileOrXcodeprojFile
                                          engineeringType:(DHEngineeringType)engineeringType
                                                   scheme:(NSString *)scheme
                                            configuration:(DHConfigurationName)configuration
                                                  verbose:(BOOL)verbose;

/// 归档工程命令
/// @param workspaceFileOrXcodeprojFile 工程文件路径(.xcodeproj/.xcworkspace)
/// @param engineeringType 工程类型(project/workspace)
/// @param scheme 对应工程的Target的名称
/// @param configuration 配置类型(Debug/Release)
/// @param archivePath 归档文件路径(.xcarchive)
/// @param architecture 架构(arm64/armv7/arm64 armv7)
/// @param xcconfigFile 配置文件路径(.xcconfig)
/// @param verbose  是否需要详细信息
+ (DHScriptModel *)fetchXcodebuildEngineeringArchiveCommand:(NSString *)workspaceFileOrXcodeprojFile
                                            engineeringType:(DHEngineeringType)engineeringType
                                                     scheme:(NSString *)scheme
                                              configuration:(DHConfigurationName)configuration
                                                archivePath:(NSString *)archivePath
                                               architecture:(nullable NSString *)architecture
                                                   xcconfig:(nullable NSString *)xcconfigFile
                                                    verbose:(BOOL)verbose;

/// 导出归档为IPA命令
/// @param archivePath 归档文件路径(.xcarchive)
/// @param exportIPADirectory 导出文件路径(.ipa)
/// @param exportOptionsPlist 导出时所需选项文件路径(.plist)
/// @param verbose  是否需要详细信息
+ (DHScriptModel *)fetchXcodebuildExportArchiveCommand:(NSString *)archivePath
                                    exportIPADirectory:(NSString *)exportIPADirectory
                                    exportOptionsPlist:(NSString *)exportOptionsPlist
                                               verbose:(BOOL)verbose;

// MARK: - pbxproj相关命令
+ (DHScriptModel *)fetchPBXProjRootObjectCommand:(NSString *)pbxprojFile;
+ (DHScriptModel *)fetchPBXProjTargetIdListCommand:(NSString *)pbxprojFile
                                        rootObject:(NSString *)rootObject;
+ (DHScriptModel *)fetchPBXProjTargetNameCommand:(NSString *)pbxprojFile
                                           targetId:(NSString *)targetId;
+ (DHScriptModel *)fetchPBXProjBuildConfigureListIdCommand:(NSString *)pbxprojFile
                                                  targetId:(NSString *)targetId;
+ (DHScriptModel *)fetchPBXProjBuildConfigureIdListCommand:(NSString *)pbxprojFile
                                      buildConfigureListId:(NSString *)buildConfigureListId;
+ (DHScriptModel *)fetchPBXProjBuildConfigureNameCommand:(NSString *)pbxprojFile
                                        buildConfigureId:(NSString *)buildConfigureId;
/// 获取的是PRODUCT_NAME，一般来说是$(TARGET_NAME)，并不是真正的展示名称
+ (DHScriptModel *)fetchPBXProjProductNameCommand:(NSString *)pbxprojFile
                                 buildConfigureId:(NSString *)buildConfigureId;
+ (DHScriptModel *)fetchPBXProjBundleIdentifierCommand:(NSString *)pbxprojFile
                              buildConfigureId:(NSString *)buildConfigureId;
+ (DHScriptModel *)fetchPBXProjEnableBitcodeCommand:(NSString *)pbxprojFile
                                   buildConfigureId:(NSString *)buildConfigureId;
+ (DHScriptModel *)fetchPBXProjShortVersionCommand:(NSString *)pbxprojFile
                                  buildConfigureId:(NSString *)buildConfigureId;
+ (DHScriptModel *)fetchPBXProjBuildVersionCommand:(NSString *)pbxprojFile
                                  buildConfigureId:(NSString *)buildConfigureId;
+ (DHScriptModel *)fetchPBXProjTeamIdentifierCommand:(NSString *)pbxprojFile
                            buildConfigureId:(NSString *)buildConfigureId;
+ (DHScriptModel *)fetchPBXProjInfoPlistFileCommand:(NSString *)pbxprojFile
                                   buildConfigureId:(NSString *)buildConfigureId;
+ (DHScriptModel *)fetchPBXProjBuildSettingsValueCommand:(NSString *)pbxprojFile
                                    buildConfigurationId:(NSString *)buildConfigurationId
                                        buildSettingsKey:(NSString *)buildSettingsKey;
// MARK: - profile相关
/// 从profile中读取的时间转化为时间戳
+ (DHScriptModel *)fetchTimestampCommand:(NSString *)time;
/// 解析profile为XML
+ (DHScriptModel *)fetchProfileXMLCommand:(NSString *)profile;
+ (DHScriptModel *)fetchProfileCreateTimeCommand:(NSString *)profile;
+ (DHScriptModel *)fetchProfileExpireTimeCommand:(NSString *)profile;
+ (DHScriptModel *)fetchProfileNameCommand:(NSString *)profile;
+ (DHScriptModel *)fetchProfileUUIDCommand:(NSString *)profile;
+ (DHScriptModel *)fetchProfileAppIdentifierCommand:(NSString *)profile;
+ (DHScriptModel *)fetchProfileTeamIdentifierCommand:(NSString *)profile;
+ (DHScriptModel *)fetchProfileTeamNameCommand:(NSString *)profile;
+ (DHScriptModel *)fetchProfileProvisionedAllDevicesCommand:(NSString *)profile;
+ (DHScriptModel *)fetchProfileGetTaskAllowCommand:(NSString *)profile;
+ (DHScriptModel *)fetchProfileIsProvisionedDevicesExistedCommand:(NSString *)profile;
+ (DHScriptModel *)fetchProfileIsProvisionedAllDevicesExistedCommand:(NSString *)profile;

// MARK: - git相关
+ (DHScriptModel *)fetchGitCurrentBranchCommand:(NSString *)gitDirectory;
+ (DHScriptModel *)fetchGitStatusCommand:(NSString *)gitDirectory;
+ (DHScriptModel *)fetchGitAddAllCommand:(NSString *)gitDirectory;
+ (DHScriptModel *)fetchGitStashCommand:(NSString *)gitDirectory;
+ (DHScriptModel *)fetchGitResetToHeadCommand:(NSString *)gitDirectory;
+ (DHScriptModel *)fetchGitPullCommand:(NSString *)gitDirectory;
+ (DHScriptModel *)fetchGitBranchListCommand:(NSString *)gitDirectory;
+ (DHScriptModel *)fetchGitTagListCommand:(NSString *)gitDirectory;
+ (DHScriptModel *)fetchGitIsBranchNameExistedCommand:(NSString *)gitDirectory
                                            branchName:(NSString *)branchName;
+ (DHScriptModel *)fetchGitCheckoutBranchCommand:(NSString *)gitDirectory
                                       branchName:(NSString *)branchName;


// MARK: - pod相关
+ (DHScriptModel *)fetchPodInstallCommand:(NSString *)podfileDirectory;

// MARK: - info.plist解析
+ (DHScriptModel *)fetchPlistAttibuteCommand:(NSString *)infoPlist
                               attributeName:(NSString *)attributeName;
+ (DHScriptModel *)fetchPlistProductNameCommand:(NSString *)infoPlist;
+ (DHScriptModel *)fetchPlistDisplayNameCommand:(NSString *)infoPlist;
+ (DHScriptModel *)fetchPlistBundleIdentifierCommand:(NSString *)infoPlist;
+ (DHScriptModel *)fetchPlistShortVersionCommand:(NSString *)infoPlist;
+ (DHScriptModel *)fetchPlistBuildVersionCommand:(NSString *)infoPlist;
/// 归档后的.app文件内的info.plist才有此值
+ (DHScriptModel *)fetchPlistMinimumOSVersionCommand:(NSString *)infoPlist;
/// 归档后的.app文件内的info.plist才有此值
+ (DHScriptModel *)fetchPlistExecutableFileCommand:(NSString *)infoPlist;

// MARK: - info.plist修改
+ (DHScriptModel *)fetchPlistSetAttibuteCommand:(NSString *)infoPlist
                                  attributeName:(NSString *)attributeName
                                 attributeValue:(NSString *)attributeValue;
+ (DHScriptModel *)fetchPlistSetProductNameCommand:(NSString *)infoPlist
                                       productName:(NSString *)productName;
+ (DHScriptModel *)fetchPlistSetDisplaytNameCommand:(NSString *)infoPlist
                                        displayName:(NSString *)displayName;
+ (DHScriptModel *)fetchPlistSetBundleIdCommand:(NSString *)infoPlist
                                       bundleId:(NSString *)bundleId;
+ (DHScriptModel *)fetchPlistSetVersionCommand:(NSString *)infoPlist
                                       version:(NSString *)version;
+ (DHScriptModel *)fetchPlistSetBuildVersionCommand:(NSString *)infoPlist
                                       buildVersion:(NSString *)buildVersion;

// MARK: - info.plist增加
+ (DHScriptModel *)fetchPlistAddAttibuteCommand:(NSString *)infoPlist
                                  attributeName:(NSString *)attributeName
                                 attributeValue:(NSString *)attributeValue;

// MARK: - info.plist删除
+ (DHScriptModel *)fetchPlistDelAttibuteCommand:(NSString *)infoPlist
                                  attributeName:(NSString *)attributeName;

// MARK: - other
/// 归档后的.app文件内的可执行文件才可解析出来，只反馈得到数字：0：即NO; 其他：即YES
/// 单纯编译(command+b得到.app文件)后的是一定没有的，即无法正确解析
+ (DHScriptModel *)fetchOtoolEnableBitcodeCommand:(NSString *)executableFile;
/// 对.app文件进行签名解析
+ (DHScriptModel *)fetchCodesignAuthorityCommand:(NSString *)appFile;
/// 对可执行文件解析架构
+ (DHScriptModel *)fetchLipoArchitecturesCommand:(NSString *)executableFile;
/// 创建exportOptionsPlist
+ (DHScriptModel *)fetchCreateExportOptionsPlistCommand:(NSString *)exportOptionsPlistFile
                                               bundleId:(NSString *)bundleId
                                                 teamId:(NSString *)teamId
                                                channel:(DHChannel)channel
                                            profileName:(NSString *)profileName
                                          enableBitcode:(DHXMLBoolean)enableBitcode
                                      stripSwiftSymbols:(DHXMLBoolean)stripSwiftSymbols;
/// 文件解压缩
+ (DHScriptModel *)fetchUnzipCommand:(NSString *)sourceFile
                     destinationFile:(NSString *)destinationFile;
/// 删除文件/文件夹
+ (DHScriptModel *)fetchRemovePathCommand:(NSString *)file;


// MARK: - 脚本路径
+ (DHScriptModel *)fetchGitScriptCommand;
+ (DHScriptModel *)fetchPodScriptCommand;
+ (DHScriptModel *)fetchXcodebuildScriptCommand;
+ (DHScriptModel *)fetchOtoolScriptCommand;
+ (DHScriptModel *)fetchSecurityScriptCommand;
+ (DHScriptModel *)fetchLipoScriptCommand;
+ (DHScriptModel *)fetchCodesignScriptCommand;
+ (DHScriptModel *)fetchRubyScriptCommand;


@end

NS_ASSUME_NONNULL_END
