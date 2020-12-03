//
//  XAPTools.h
//  XAPSDK
//
//  Created by 菲凡数据 on 2020/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XAPTools : NSObject

/// 是否是有效的字符串
+ (BOOL)isValidString:(NSString *)string;
/// 是否是有效的数组
+ (BOOL)isValidArray:(NSArray *)object;
/// 是否是有效的字典
+ (BOOL)isValidDictionary:(NSDictionary *)object;

/// 判断路径是否存在
+ (BOOL)isPathExist:(NSString *)path;
/// 路径是否是目录
+ (BOOL)isDirectoryPath:(NSString *)path;
/// 路径是否是文件
+ (BOOL)isFilePath:(NSString *)path;

/// 根据文件路径获取文档路径
+ (NSString *)directoryPathWithFilePath:(NSString *)filePath;

/// 正则表达式匹配
+ (BOOL)validateWithRegExp:(NSString *)regExp text:(NSString *)text;

@end

#pragma mark - 工程路径文件类型验证
@interface XAPTools (FileTypeValidate)

/// .xcworkspace
+ (BOOL)isXcworkspaceFile:(NSString *)path;
/// .xcodeproj
+ (BOOL)isXcodeprojFile:(NSString *)path;
/// .git
+ (BOOL)isGitFile:(NSString *)path;
/// podfile
+ (BOOL)isPodfileFile:(NSString *)path;
/// .mobileprovision
+ (BOOL)isProvisioningProfile:(NSString *)path;
/// .xcarchive
+ (BOOL)isXcarchiveFile:(NSString *)path;
/// .ipa
+ (BOOL)isIPAFile:(NSString *)path;
/// .app
+ (BOOL)isAppFile:(NSString *)path;
/// .plist
+ (BOOL)isPlistFile:(NSString *)path;

@end

@interface XAPTools (FindExtension)

/// 查找.mobileprovision文件
+ (NSArray <NSString *> *)findProvisionProfiles:(NSString *)path;
/// 查找路径下所有xcworkspace文件路径
+ (nullable NSArray *)findXcworkspaceFiles:(NSString *)path;
/// 查找路径下所有的xcodeproj文件路径
+ (nullable NSArray *)findXcodeprojFiles:(NSString *)path;

@end


@interface XAPTools (EngineerExtension)

/// 获取.xcworkspacedata文件路径
+ (NSString *)xcworkspacedataFileWithXcworkspaceFile:(NSString *)xcworkspaceFile;
/// 获取.pbxproj文件路径
+ (NSString *)pbxprojFileWithXcodeprojFile:(NSString *)xcodeprojFile;
/// 获取PROJECT_DIR路径
+ (NSString *)PROJECT_DIRWithXcodeprojFile:(NSString *)xcodeprojFile;
/// 获取SRCROOT路径
+ (NSString *)SRCROOTWithXcodeprojFile:(NSString *)xcodeprojFile;
/// 通过相对路径(SRCROOT, PROJECT_DIR, ../)，获取绝对路径
+ (NSString *)absolutePathWithXcodeprojFile:(NSString *)xcodeprojFile
                               relativePath:(NSString *)relativePath;

/// 获取.xcarchive下.app的文档路径
+ (NSString *)appFileWithXcarchiveFile:(NSString *)xcarchiveFile;
/// 获取.xcarchive下info.plist文件路径
+ (NSString *)infoPlistFileWithXcarchiveFile:(NSString *)xcarchiveFile;

/// 获取.app文件下info.plist文件路径
+ (NSString *)infoPlistFileWithAppFile:(NSString *)appFile;
/// 获取.app文件下可执行文件路径
/// @param relativeExecutableFile 可执行文件相对路径
+ (NSString *)executableFileAbsolutePathWithAppFile:(NSString *)appFile
                             relativeExecutableFile:(NSString *)relativeExecutableFile;
/// 获取embedded.mobileprovision文件路径
+ (NSString *)embeddedProvisionFileWithAppFile:(NSString *)appFile;

/// 获取.ipa解压缩后的.app文件
/// @param ipaFile .ipa文件
/// @param unzippedPath out 解压路径
+ (nullable NSString *)appFileWithIPAFile:(NSString *)ipaFile
                             unzippedPath:(NSString * __autoreleasing _Nullable * _Nullable)unzippedPath;

@end

@interface XAPTools (TraverseExtension)

/// 文件夹下所有文件绝对路径——深度优先
+ (nullable NSArray *)absoluteSubpathsOfDirectory:(NSString *)path;
/// 文件夹下一级目录文件绝对路径
+ (nullable NSArray *)absoluteContentsOfDirectory:(NSString *)path;

@end


@interface XAPTools (DirectoryExtension)

/// 系统用户路径
+ (NSString *)systemUserDirectory;
/// Desktop
+ (NSString *)systemUserDesktopDirectory;
/// Documents
+ (NSString *)systemUserDocumentsDirectory;
/// Library/Caches
+ (NSString *)systemUserCachesDirectory;

/// 沙盒 Documents
+ (NSString *)systemSandboxDocumentDirectory;
/// 沙盒 Desktop
+ (NSString *)systemSandboxDesktopDirectory;
/// 沙盒 Library/Caches
+ (NSString *)systemSandboxCachesDirectory;

/// 系统默认存储.mobileprovision的文档
+ (NSString *)systemProvisioningProfilesDirectory;

@end




NS_ASSUME_NONNULL_END
