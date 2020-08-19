//
//  DHPathUtils.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHPathUtils : NSObject

/// 查找xcworkspace路径
+ (nullable NSString *)findXcworkspace:(NSString *)path;
/// 查找xcodeproj路径
+ (nullable NSString *)findXcodeproj:(NSString *)path;
/// 查找.git路径
+ (nullable NSString *)findGit:(NSString *)path;
/// 查找Podfile路径
+ (nullable NSString *)findPodfile:(NSString *)path;
/// 查找.mobileprovision文件
+ (NSArray <NSString *> *)findProfiles:(NSString *)path;
/// 查找.xcarchive路径
+ (nullable NSString *)findXcarchive:(NSString *)path;
/// 查找.ipa路径
+ (nullable NSString *)findIPA:(NSString *)path;
/// 查找.app路径
+ (nullable NSString *)findApp:(NSString *)path;
/// 从.xcarchive文件路径下查找.app文件
+ (nullable NSString *)findAppFileWithXcarchiveFile:(NSString *)xcarchiveFile;
/// 查找路径下所有xcworkspace文件路径
+ (nullable NSArray *)findXcworkspaceFiles:(NSString *)path;
/// 查找路径下所有的xcodeproj文件路径
+ (nullable NSArray *)findXcodeprojFiles:(NSString *)path;

/// .xcworkspace
+ (BOOL)isXcworkspaceFile:(NSString *)path;
/// .xcodeproj
+ (BOOL)isXcodeprojFile:(NSString *)path;
/// .git
+ (BOOL)isGitFile:(NSString *)path;
/// podfile
+ (BOOL)isPodfileFile:(NSString *)path;
/// .mobileprovision
+ (BOOL)isProfile:(NSString *)path;
/// .xcarchive
+ (BOOL)isXcarchiveFile:(NSString *)path;
/// .ipa
+ (BOOL)isIPAFile:(NSString *)path;
/// .app
+ (BOOL)isAppFile:(NSString *)path;
/// .plist
+ (BOOL)isPlistFile:(NSString *)path;


/// 获取.xcworkspacedata文件路径
+ (NSString *)getXcworkspacedataFileWithXcworkspaceFile:(NSString *)xcworkspaceFile;
/// 获取.xcodeproj文档路径
+ (NSString *)getXcodeprojDirectoryWithXcodeprojFile:(NSString *)xcodeprojFile;
/// 获取.pbxproj文件路径
+ (NSString *)getPbxprojFileWithXcodeprojFile:(NSString *)xcodeprojFile;
/// 获取PROJECT_DIR路径
+ (NSString *)getPROJECT_DIRWithXcodeprojFile:(NSString *)xcodeprojFile;
/// 获取SRCROOT路径
+ (NSString *)getSRCROOTWithXcodeprojFile:(NSString *)xcodeprojFile;
/// 通过相对路径(SRCROOT, PROJECT_DIR, ../)，获取绝对路径
+ (NSString *)getAbsolutePathWithXcodeprojFile:(NSString *)xcodeprojFile
                                  relativePath:(NSString *)relativePath;
/// 获取embedded.mobileprovision文件路径
+ (NSString *)getEmbeddedProvisionFileWithAppFile:(NSString *)appFile;
/// 获取.xcarchive下.app的文档路径
+ (NSString *)getAppFileDirectoryWithXcarchiveFile:(NSString *)xcarchiveFile;
/// 获取.xcarchive下info.plist文件路径
+ (NSString *)getInfoPlistWithXcarchiveFile:(NSString *)xcarchiveFile;
/// 获取.app文件下info.plist文件路径
+ (NSString *)getInfoPlistFileWithAppFile:(NSString *)appFile;
/// 获取.app文件下可执行文件路径
/// @param relativeExecutableFile 可执行文件相对路径
+ (NSString *)getExecutableFileWithAppFile:(NSString *)appFile relativeExecutableFile:(NSString *)relativeExecutableFile;
/// 获取.ipa解压缩后的.app文件
+ (nullable NSString *)getAppFileWithIPAFile:(NSString *)ipaFile unzippedPath:(NSString * __autoreleasing _Nullable * _Nullable)unzippedPath;
/// 获取.git文档路径
+ (NSString *)getGitDirectoryWithGitFile:(NSString *)gitFile;
/// 获取Podfile文档路径
+ (NSString *)getPodfileDirectoryWithPodfile:(NSString *)podfile;

@end

NS_ASSUME_NONNULL_END
