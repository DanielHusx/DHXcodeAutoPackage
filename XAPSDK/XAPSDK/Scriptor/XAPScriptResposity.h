//
//  XAPScriptResposity.h
//  XAPSDK
//
//  Created by Daniel on 2020/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XAPScriptModel;

/**
 命令仓库
 */
@interface XAPScriptResposity : NSObject

// MARK: - xcodebuild相关命令
/// 清理工程命令
/// @param workspaceFileOrXcodeprojFile 工程文件路径(.xcodeproj/.xcworkspace)
/// @param engineeringType 工程类型(project/workspace)
/// @param scheme 对应工程的Target的名称
/// @param configuration 配置类型(Debug/Release)
/// @param verbose  是否需要详细信息
+ (XAPScriptModel *)fetchXcodebuildEngineeringCleanCommand:(NSString *)workspaceFileOrXcodeprojFile
                                          engineeringType:(XAPEngineeringType)engineeringType
                                                   scheme:(NSString *)scheme
                                            configuration:(XAPConfigurationName)configuration
                                                  verbose:(BOOL)verbose;

/// 归档工程命令
/// @param workspaceFileOrXcodeprojFile 工程文件路径(.xcodeproj/.xcworkspace)
/// @param engineeringType 工程类型(project/workspace)
/// @param scheme 对应工程的Target的名称
/// @param configuration 配置类型(Debug/Release)
/// @param archivePath  输出的归档文件路径(.xcarchive)
/// @param architecture 架构(arm64/armv7/arm64 armv7)
/// @param xcconfigFile 配置文件路径(.xcconfig)
/// @param verbose  是否需要详细信息
+ (XAPScriptModel *)fetchXcodebuildEngineeringArchiveCommand:(NSString *)workspaceFileOrXcodeprojFile
                                            engineeringType:(XAPEngineeringType)engineeringType
                                                     scheme:(NSString *)scheme
                                              configuration:(XAPConfigurationName)configuration
                                                archivePath:(NSString *)archivePath
                                               architecture:(nullable NSString *)architecture
                                                   xcconfig:(nullable NSString *)xcconfigFile
                                                    verbose:(BOOL)verbose;

/// 导出归档为IPA命令
/// @param archivePath 归档文件路径(.xcarchive)
/// @param exportIPADirectory 导出文件路径(.ipa)
/// @param exportOptionsPlist 导出时所需选项文件路径(.plist)
/// @param verbose  是否需要详细信息
+ (XAPScriptModel *)fetchXcodebuildExportArchiveCommand:(NSString *)archivePath
                                    exportIPADirectory:(NSString *)exportIPADirectory
                                    exportOptionsPlist:(NSString *)exportOptionsPlist
                                               verbose:(BOOL)verbose;

// MARK: - pbxproj相关命令
+ (XAPScriptModel *)fetchPBXProjRootObjectCommand:(NSString *)pbxprojFile;
+ (XAPScriptModel *)fetchPBXProjTargetIdListCommand:(NSString *)pbxprojFile
                                        rootObject:(NSString *)rootObject;
+ (XAPScriptModel *)fetchPBXProjTargetNameCommand:(NSString *)pbxprojFile
                                           targetId:(NSString *)targetId;
+ (XAPScriptModel *)fetchPBXProjBuildConfigureListIdCommand:(NSString *)pbxprojFile
                                                  targetId:(NSString *)targetId;
+ (XAPScriptModel *)fetchPBXProjBuildConfigureIdListCommand:(NSString *)pbxprojFile
                                      buildConfigureListId:(NSString *)buildConfigureListId;
+ (XAPScriptModel *)fetchPBXProjBuildConfigureNameCommand:(NSString *)pbxprojFile
                                        buildConfigureId:(NSString *)buildConfigureId;
/// 获取的是PRODUCT_NAME，一般来说是$(TARGET_NAME)，并不是真正的展示名称
+ (XAPScriptModel *)fetchPBXProjProductNameCommand:(NSString *)pbxprojFile
                                 buildConfigureId:(NSString *)buildConfigureId;
+ (XAPScriptModel *)fetchPBXProjBundleIdentifierCommand:(NSString *)pbxprojFile
                              buildConfigureId:(NSString *)buildConfigureId;
+ (XAPScriptModel *)fetchPBXProjEnableBitcodeCommand:(NSString *)pbxprojFile
                                   buildConfigureId:(NSString *)buildConfigureId;
+ (XAPScriptModel *)fetchPBXProjShortVersionCommand:(NSString *)pbxprojFile
                                   buildConfigureId:(NSString *)buildConfigureId;
+ (XAPScriptModel *)fetchPBXProjVersionCommand:(NSString *)pbxprojFile
                              buildConfigureId:(NSString *)buildConfigureId;
+ (XAPScriptModel *)fetchPBXProjTeamIdentifierCommand:(NSString *)pbxprojFile
                            buildConfigureId:(NSString *)buildConfigureId;
+ (XAPScriptModel *)fetchPBXProjInfoPlistFileCommand:(NSString *)pbxprojFile
                                   buildConfigureId:(NSString *)buildConfigureId;
+ (XAPScriptModel *)fetchPBXProjBuildSettingsValueCommand:(NSString *)pbxprojFile
                                    buildConfigurationId:(NSString *)buildConfigurationId
                                        buildSettingsKey:(NSString *)buildSettingsKey;
// MARK: - profile相关
/// 从profile中读取的时间转化为时间戳
+ (XAPScriptModel *)fetchTimestampCommand:(NSString *)time;
/// 解析profile为XML
+ (XAPScriptModel *)fetchProfileXMLCommand:(NSString *)profile;
+ (XAPScriptModel *)fetchProfileCreateTimeCommand:(NSString *)profile;
+ (XAPScriptModel *)fetchProfileExpireTimeCommand:(NSString *)profile;
+ (XAPScriptModel *)fetchProfileNameCommand:(NSString *)profile;
+ (XAPScriptModel *)fetchProfileUUIDCommand:(NSString *)profile;
+ (XAPScriptModel *)fetchProfileAppIdentifierCommand:(NSString *)profile;
+ (XAPScriptModel *)fetchProfileTeamIdentifierCommand:(NSString *)profile;
+ (XAPScriptModel *)fetchProfileTeamNameCommand:(NSString *)profile;
+ (XAPScriptModel *)fetchProfileProvisionedAllDevicesCommand:(NSString *)profile;
+ (XAPScriptModel *)fetchProfileGetTaskAllowCommand:(NSString *)profile;
+ (XAPScriptModel *)fetchProfileIsProvisionedDevicesExistedCommand:(NSString *)profile;
+ (XAPScriptModel *)fetchProfileIsProvisionedAllDevicesExistedCommand:(NSString *)profile;

// MARK: - git相关
+ (XAPScriptModel *)fetchGitCurrentBranchCommand:(NSString *)gitDirectory;
+ (XAPScriptModel *)fetchGitStatusCommand:(NSString *)gitDirectory;
+ (XAPScriptModel *)fetchGitAddAllCommand:(NSString *)gitDirectory;
+ (XAPScriptModel *)fetchGitStashCommand:(NSString *)gitDirectory;
+ (XAPScriptModel *)fetchGitResetToHeadCommand:(NSString *)gitDirectory;
+ (XAPScriptModel *)fetchGitPullCommand:(NSString *)gitDirectory;
+ (XAPScriptModel *)fetchGitBranchListCommand:(NSString *)gitDirectory;
+ (XAPScriptModel *)fetchGitTagListCommand:(NSString *)gitDirectory;
+ (XAPScriptModel *)fetchGitIsBranchNameExistedCommand:(NSString *)gitDirectory
                                            branchName:(NSString *)branchName;
+ (XAPScriptModel *)fetchGitCheckoutBranchCommand:(NSString *)gitDirectory
                                       branchName:(NSString *)branchName;


// MARK: - pod相关
+ (XAPScriptModel *)fetchPodInstallCommand:(NSString *)podfileDirectory;

// MARK: - info.plist解析
+ (XAPScriptModel *)fetchPlistAttibuteCommand:(NSString *)infoPlist
                               attributeName:(NSString *)attributeName;
+ (XAPScriptModel *)fetchPlistProductNameCommand:(NSString *)infoPlist;
+ (XAPScriptModel *)fetchPlistDisplayNameCommand:(NSString *)infoPlist;
+ (XAPScriptModel *)fetchPlistBundleIdentifierCommand:(NSString *)infoPlist;
+ (XAPScriptModel *)fetchPlistShortVersionCommand:(NSString *)infoPlist;
+ (XAPScriptModel *)fetchPlistVersionCommand:(NSString *)infoPlist;
/// 归档后的.app文件内的info.plist才有此值
+ (XAPScriptModel *)fetchPlistMinimumOSVersionCommand:(NSString *)infoPlist;
/// 归档后的.app文件内的info.plist才有此值
+ (XAPScriptModel *)fetchPlistExecutableFileCommand:(NSString *)infoPlist;

// MARK: - info.plist修改
+ (XAPScriptModel *)fetchPlistSetAttibuteCommand:(NSString *)infoPlist
                                  attributeName:(NSString *)attributeName
                                 attributeValue:(NSString *)attributeValue;
+ (XAPScriptModel *)fetchPlistSetProductNameCommand:(NSString *)infoPlist
                                       productName:(NSString *)productName;
+ (XAPScriptModel *)fetchPlistSetDisplaytNameCommand:(NSString *)infoPlist
                                        displayName:(NSString *)displayName;
+ (XAPScriptModel *)fetchPlistSetBundleIdCommand:(NSString *)infoPlist
                                       bundleId:(NSString *)bundleId;
+ (XAPScriptModel *)fetchPlistSetShortVersionCommand:(NSString *)infoPlist
                                        shortVersion:(NSString *)shortVersion;
+ (XAPScriptModel *)fetchPlistSetVersionCommand:(NSString *)infoPlist
                                        version:(NSString *)version;

// MARK: - info.plist增加
+ (XAPScriptModel *)fetchPlistAddAttibuteCommand:(NSString *)infoPlist
                                  attributeName:(NSString *)attributeName
                                 attributeValue:(NSString *)attributeValue;

// MARK: - info.plist删除
+ (XAPScriptModel *)fetchPlistDelAttibuteCommand:(NSString *)infoPlist
                                  attributeName:(NSString *)attributeName;


// MARK: - 上传IPA至AppStore
/// 验证ipa包的正确性
/// @discussion 上传前需要用此方法进行验证ipa文件
/// @attention 在生成密钥完成后可下载api密钥文件（只能下载一次），需放置 ~/.private_keys/ 下
///
/// @param ipaFile .ipa文件路径
/// @param apiKey itunesconnect.apple.com=>用户和访问=>密钥=>App Store Connect API=>密钥ID
/// @param apiIssuer itunesconnect.apple.com=>用户和访问=>密钥=>App Store Connect API=>IssuerID
/// @return 命令对象
+ (XAPScriptModel *)fetchXcrunValidateIPACommand:(NSString *)ipaFile
                                         apiKey:(NSString *)apiKey
                                      apiIssuer:(NSString *)apiIssuer;

/// 上传ipa包至AppStore
/// @discussion 必须使用验证ipa文件方法验证后才可调用此命令上传
/// @attention 在生成密钥完成后可下载api密钥文件（只能下载一次），需放置 ~/.private_keys/ 下
///
/// @param ipaFile .ipa文件路径
/// @param apiKey itunesconnect.apple.com=>用户和访问=>密钥=>App Store Connect API=>密钥ID
/// @param apiIssuer itunesconnect.apple.com=>用户和访问=>密钥=>App Store Connect API=>IssuerID
/// @return 命令对象
+ (XAPScriptModel *)fetchXcrunUploadIPACommand:(NSString *)ipaFile
                                       apiKey:(NSString *)apiKey
                                    apiIssuer:(NSString *)apiIssuer;


// MARK: - other
/// 归档后的.app文件内的可执行文件才可解析出来，只反馈得到数字：0：即NO; 其他：即YES
/// 单纯编译(command+b得到.app文件)后的是一定没有的，即无法正确解析
+ (XAPScriptModel *)fetchOtoolEnableBitcodeCommand:(NSString *)executableFile;
/// 对.app文件进行签名解析
+ (XAPScriptModel *)fetchCodesignAuthorityCommand:(NSString *)appFile;
/// 对可执行文件解析架构
+ (XAPScriptModel *)fetchLipoArchitecturesCommand:(NSString *)executableFile;
/// 创建exportOptionsPlist
+ (XAPScriptModel *)fetchCreateExportOptionsPlistCommand:(NSString *)exportOptionsPlistFile
                                               bundleId:(NSString *)bundleId
                                                 teamId:(NSString *)teamId
                                                channel:(XAPChannel)channel
                                            profileName:(NSString *)profileName
                                          enableBitcode:(XAPXMLBoolean)enableBitcode
                                      stripSwiftSymbols:(XAPXMLBoolean)stripSwiftSymbols;
/// 文件解压缩
+ (XAPScriptModel *)fetchUnzipCommand:(NSString *)sourceFile
                     destinationFile:(NSString *)destinationFile;
/// 删除文件/文件夹
+ (XAPScriptModel *)fetchRemovePathCommand:(NSString *)file;

@end

NS_ASSUME_NONNULL_END
