//
//  XAPTools.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/2.
//

#import "XAPTools.h"
#import "XAPZipTools.h"

@implementation XAPTools

+ (BOOL)isPathExist:(NSString *)path {
    if (![self isValidString:path]) { return NO; }
    BOOL isDir = NO;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                       isDirectory:&isDir];
    return result;
}

/// 路径是否是目录
+ (BOOL)isDirectoryPath:(NSString *)path {
    if (![self isValidString:path]) { return NO; }
    BOOL isDir = NO;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                       isDirectory:&isDir];
    return isDir && result;
}

/// 路径是否是文件
+ (BOOL)isFilePath:(NSString *)path {
    if (![self isValidString:path]) { return NO; }
    BOOL isDir = NO;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                       isDirectory:&isDir];
    return !isDir && result;
}

+ (BOOL)isValidString:(NSString *)string {
    if ([string isKindOfClass:[NSString class]]) {
        return string.length != 0;
    }
    return NO;
}

+ (BOOL)isValidArray:(NSArray *)object {
    if ([object isKindOfClass:[NSArray class]]) {
        return [object count] != 0;
    }
    return NO;
}

+ (BOOL)isValidDictionary:(NSDictionary *)object {
    if ([object isKindOfClass:[NSDictionary class]]) {
        return [object count] != 0;
    }
    return NO;
}

+ (NSString *)directoryPathWithFilePath:(NSString *)filePath {
    return [filePath stringByDeletingLastPathComponent];
}

+ (BOOL)validateWithRegExp:(NSString *)regExp text:(NSString *)text {
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:text];
}

@end


@implementation XAPTools (FileTypeValidate)
+ (BOOL)isXcworkspaceFile:(NSString *)path {
    if (![self isDirectoryPath:path]) { return NO; }
    if (![path containsString:@".xcworkspace"]) { return NO; }
    if ([path containsString:@".xcodeproj"]) { return NO; }
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[self xcworkspacedataFileWithXcworkspaceFile:path]
                                                        isDirectory:&isDir];
    return !isDir && isExist;
}

+ (BOOL)isXcodeprojFile:(NSString *)path {
    if (![self isDirectoryPath:path]) { return NO; }
    if (![path containsString:@".xcodeproj"]) { return NO; }
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[self pbxprojFileWithXcodeprojFile:path]
                                                        isDirectory:&isDir];
    return !isDir && isExist;
}

+ (BOOL)isGitFile:(NSString *)path {
    if (![self isDirectoryPath:path]) { return NO; }
    if (![path containsString:@".git"]) { return NO; }
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                        isDirectory:&isDir];
    return isDir && isExist;
}

+ (BOOL)isPodfileFile:(NSString *)path {
    if (![self isFilePath:path]) { return NO; }
    if (![path.lastPathComponent isEqualToString:@"Podfile"]) { return NO; }
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                        isDirectory:&isDir];
    return !isDir && isExist;
}

+ (BOOL)isProvisioningProfile:(NSString *)path {
    if (![self isFilePath:path]) { return NO; }
    if (![path.pathExtension isEqualToString:@"mobileprovision"]) { return NO; }
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                        isDirectory:&isDir];
    return !isDir && isExist;
}

+ (BOOL)isXcarchiveFile:(NSString *)path {
    if (![self isDirectoryPath:path]) { return NO; }
    if (![path.pathExtension isEqualToString:@"xcarchive"]) { return NO; }
    // 获取.app文件路径
    NSString *appFile = [self appFileWithXcarchiveFile:path];
    if (![self isAppFile:appFile]) { return NO; }
    
    return YES;
}

+ (BOOL)isIPAFile:(NSString *)path {
    if (![self isFilePath:path]) { return NO; }
    if (![path.pathExtension isEqualToString:@"ipa"]) { return NO; }
    NSString *unzippedPath;
    // 解压ipa文件获取.app文件路径，得到返回即存在
    NSString *appFile = [self appFileWithIPAFile:path
                                    unzippedPath:&unzippedPath];
    // 验证后移除已解压文件
    if (unzippedPath) {
        [[NSFileManager defaultManager] removeItemAtPath:unzippedPath error:nil];
    }
    if (!appFile) { return NO; }
    
    return YES;
}

+ (BOOL)isAppFile:(NSString *)path {
    if (![self isDirectoryPath:path]) { return NO; }
    if (![path.pathExtension isEqualToString:@"app"]) { return NO; }
    BOOL isDir = NO;
    BOOL isExist = NO;
    // 判定embedded.mobileprovision文件是否存在
    NSString *embeddedProfile = [self embeddedProvisionFileWithAppFile:path];
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:embeddedProfile
                                                   isDirectory:&isDir];
    if (!(!isDir && isExist)) { return NO; }
    // 判定info.plist文件是否存在
    NSString *infoPlist = [self infoPlistFileWithAppFile:path];
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:infoPlist
                                                   isDirectory:&isDir];
    if (!(!isDir && isExist)) { return NO; }
    
    return YES;
}

+ (BOOL)isPlistFile:(NSString *)path {
    if (![self isFilePath:path]) { return NO; }
    if (![path.pathExtension isEqualToString:@"plist"]) { return NO; }
    return YES;
}

@end


@implementation XAPTools (FindExtension)

/// 查找.mobileprovision文件
+ (NSArray <NSString *> *)findProvisionProfiles:(NSString *)path {
    if (![self isDirectoryPath:path]) {
        if ([self isProvisioningProfile:path]) {
            return @[path];
        }
        return nil;
    }
    
    NSArray *subpaths = [self absoluteSubpathsOfDirectory:path];
    __block NSMutableArray *result = [NSMutableArray array];
    __weak typeof(self) weakself = self;
    [subpaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([weakself isProvisioningProfile:obj]) {
            [result addObject:obj];
        }
    }];
    
    return [result copy];
}

/// 查找路径下所有xcworkspace文件路径
+ (nullable NSArray *)findXcworkspaceFiles:(NSString *)path {
    if (![self isDirectoryPath:path]) {
        if ([self isXcworkspaceFile:path]) {
            return @[path];
        }
        return nil;
    }
    
    NSArray *subpaths = [self absoluteSubpathsOfDirectory:path];
    __block NSMutableArray *result = [NSMutableArray array];
    __weak typeof(self) weakself = self;
    [subpaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([weakself isXcworkspaceFile:obj]) {
            [result addObject:obj];
        }
    }];
    
    return [result copy];
}

/// 查找路径下所有的xcodeproj文件路径
+ (nullable NSArray *)findXcodeprojFiles:(NSString *)path {
    if (![self isDirectoryPath:path]) {
        if ([self isXcodeprojFile:path]) {
            return @[path];
        }
        return nil;
    }
    
    NSArray *subpaths = [self absoluteSubpathsOfDirectory:path];
    __block NSMutableArray *result = [NSMutableArray array];
    __weak typeof(self) weakself = self;
    [subpaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([weakself isXcodeprojFile:obj]) {
            [result addObject:obj];
        }
    }];
    
    return [result copy];
}

@end

#import "XAPXMLTools.h"
@implementation XAPTools (EngineerExtension)
#pragma mark XCWORKSPACE/XCODEPROJ
+ (NSString *)xcworkspacedataFileWithXcworkspaceFile:(NSString *)xcworkspaceFile {
    return [xcworkspaceFile stringByAppendingPathComponent:@"contents.xcworkspacedata"];
}

+ (NSString *)pbxprojFileWithXcodeprojFile:(NSString *)xcodeprojFile {
    return [xcodeprojFile stringByAppendingPathComponent:@"project.pbxproj"];
}

+ (NSString *)PROJECT_DIRWithXcodeprojFile:(NSString *)xcodeprojFile {
    return [self directoryPathWithFilePath:xcodeprojFile];
}

+ (NSString *)SRCROOTWithXcodeprojFile:(NSString *)xcodeprojFile {
    return [self directoryPathWithFilePath:xcodeprojFile];
}

+ (NSString *)absolutePathWithXcodeprojFile:(NSString *)xcodeprojFile
                               relativePath:(NSString *)relativePath {
    NSString *directory = [self directoryPathWithFilePath:xcodeprojFile];
    NSString *path = relativePath;
    if ([relativePath hasPrefix:kXAPRelativeValueSRCROOT]) {
        path = [relativePath substringFromIndex:kXAPRelativeValueSRCROOT.length+1];
    } else if ([relativePath hasPrefix:kXAPRelativeValuePROJECT_DIR]) {
        path = [relativePath substringFromIndex:kXAPRelativeValuePROJECT_DIR.length+1];
    }
    while ([path hasPrefix:@"../"]) {
        directory = [directory stringByDeletingLastPathComponent];
        path = [path substringFromIndex:3];
    }
    return [directory stringByAppendingPathComponent:path];
}

+ (NSArray <NSString *> *)xcodeprojVirtualFilesWithWorkspaceFile:(NSString *)xcworkspaceFile {
    if (![self isXcworkspaceFile:xcworkspaceFile]) { return nil; }
    
    NSString *xcworkspacedataFile = [self xcworkspacedataFileWithXcworkspaceFile:xcworkspaceFile];
    // 从contents.xcworkspacedata文件中获取关联的项目路径
    NSArray *projectFiles = [self getXcodeprojFilesWithXcworkspaceFile:xcworkspaceFile
                                                   xcworkspacedataFile:xcworkspacedataFile
                                                               virtual:YES];
    return projectFiles;
}

+ (NSArray <NSString *> *)xcodeprojFilesWithWorkspaceFile:(NSString *)xcworkspaceFile {
    if (![self isXcworkspaceFile:xcworkspaceFile]) { return nil; }
    
    NSString *xcworkspacedataFile = [self xcworkspacedataFileWithXcworkspaceFile:xcworkspaceFile];
    // 从contents.xcworkspacedata文件中获取关联的项目路径
    NSArray *projectFiles = [self getXcodeprojFilesWithXcworkspaceFile:xcworkspaceFile
                                                   xcworkspacedataFile:xcworkspacedataFile
                                                               virtual:NO];
    return projectFiles;
}

/// 解析contents.xcworkspacedata文件
+ (NSArray <NSString *> *)getXcodeprojFilesWithXcworkspaceFile:(NSString *)xcworkspaceFile
                                           xcworkspacedataFile:(NSString *)xcworkspacedataFile
                                                       virtual:(BOOL)virtual {
    
    // 解析XML
    NSDictionary *dict = [XAPXMLTools dictionaryWithXMLFile:xcworkspacedataFile];
    if (!dict) { return nil; }
    
    NSDictionary *workspaceDict = [dict objectForKey:@"Workspace"];
    if (![workspaceDict isKindOfClass:[NSDictionary class]]) { return nil; }
    
    NSMutableArray *projectFiles = [NSMutableArray array];
    // 解析FileRef
    id fileRef = [workspaceDict objectForKey:@"FileRef"];
    if ([fileRef isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in fileRef) {
            if (![item isKindOfClass:[NSDictionary class]]) { continue ; }
            
            NSString *location = item[@"location"];
            NSString *xcodeprojFile = virtual ? [self xcodeprojVirtualFileWithXcworkspaceFile:xcworkspaceFile location:location] : [self xcodeprojFileWithXcworkspaceFile:xcworkspaceFile location:location];
            if ([self isValidString:xcodeprojFile]) {
                [projectFiles addObject:xcodeprojFile];
            }
        }
        
    } else if ([fileRef isKindOfClass:[NSDictionary class]]) {
        NSString *location = fileRef[@"location"];
        NSString *xcodeprojFile = virtual ? [self xcodeprojVirtualFileWithXcworkspaceFile:xcworkspaceFile location:location] : [self xcodeprojFileWithXcworkspaceFile:xcworkspaceFile location:location];
        if ([self isValidString:xcodeprojFile]) {
            [projectFiles addObject:xcodeprojFile];
        }
    } else { return nil; }
    
    return [projectFiles copy];
}

/// 解析location键值，得到虚拟路径
+ (NSString *)xcodeprojVirtualFileWithXcworkspaceFile:(NSString *)xcworkspaceFile
                                             location:(NSString *)location {
    if (![location isKindOfClass:[NSString class]]) { return nil; }
    if (![location containsString:@"group:"]) { return nil; }
    
    NSString *xcodeprojFileRelativePath = [location substringFromIndex:@"group:".length];
    // 虚拟路径
    NSString *xcodeprojFile = [xcworkspaceFile stringByAppendingPathComponent:[NSString stringWithFormat:@"../%@", xcodeprojFileRelativePath]];
    if ([xcodeprojFile.lastPathComponent isEqualToString:@"Pods.xcodeproj"]) { return nil; }
    
    return xcodeprojFile;
}

// 解析location键值，得到真实路径
+ (NSString *)xcodeprojFileWithXcworkspaceFile:(NSString *)xcworkspaceFile
                                      location:(NSString *)location {
    if (![location isKindOfClass:[NSString class]]) { return nil; }
    if (![location containsString:@"group:"]) { return nil; }
    NSString *directory = [xcworkspaceFile stringByDeletingLastPathComponent];
    NSString *xcodeprojFileRelativePath = [location substringFromIndex:@"group:".length];
    while ([xcodeprojFileRelativePath hasPrefix:@"../"]) {
        directory = [directory stringByDeletingLastPathComponent];
        xcodeprojFileRelativePath = [xcodeprojFileRelativePath substringFromIndex:3];
    }
    // 真实路径
    NSString *xcodeprojFile = [directory stringByAppendingPathComponent:xcodeprojFileRelativePath];
    if ([xcodeprojFile.lastPathComponent isEqualToString:@"Pods.xcodeproj"]) { return nil; }
    
    return xcodeprojFile;
}


#pragma mark XCARCHIVE FILE
+ (NSString *)infoPlistFileWithXcarchiveFile:(NSString *)xcarchiveFile {
    return [xcarchiveFile stringByAppendingPathComponent:@"info.plist"];
}

+ (NSString *)appFileWithXcarchiveFile:(NSString *)xcarchiveFile {
    BOOL isDir = NO;
    BOOL isExist = NO;
    // 判定info.plist文件是否存在
    NSString *infoPlistFile = [self infoPlistFileWithXcarchiveFile:xcarchiveFile];
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:infoPlistFile
                                                   isDirectory:&isDir];
    if (!(!isDir && isExist)) { return nil; }
    // 解析info.plist内的ApplicationProperties=>ApplicationPath的值得到.app文件路径
    NSDictionary *infoPlistDictionary = [NSDictionary dictionaryWithContentsOfFile:infoPlistFile];
    NSDictionary *applicationProperties = [infoPlistDictionary objectForKey:kXAPKeyApplicationProperties];
    if (![applicationProperties isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSString *applicationPath = [applicationProperties objectForKey:kXAPKeyApplicationPath];
    if (![applicationPath isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString *products = [xcarchiveFile stringByAppendingPathComponent:@"Products"];
    NSString *appFile = [products stringByAppendingPathComponent:applicationPath];
    // FIXME: 其实也有可能不存在~，可以考虑在该路径下继续查找，如果还没有才宣布失败
    return appFile;
}

#pragma mark APP FILE
+ (NSString *)embeddedProvisionFileWithAppFile:(NSString *)appFile {
    return [appFile stringByAppendingPathComponent:@"embedded.mobileprovision"];
}

+ (NSString *)infoPlistFileWithAppFile:(NSString *)appFile {
    return [appFile stringByAppendingPathComponent:@"info.plist"];
}

+ (NSString *)executableFileAbsolutePathWithAppFile:(NSString *)appFile
                             relativeExecutableFile:(NSString *)relativeExecutableFile {
    return [appFile stringByAppendingPathComponent:relativeExecutableFile];
}

#pragma mark IPA FILE
+ (NSString *)appFileWithIPAFile:(NSString *)ipaFile
                    unzippedPath:(NSString *__autoreleasing  _Nullable *)unzippedPath {
    BOOL isDir = NO;
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:ipaFile
                                                   isDirectory:&isDir];
    if (!(!isDir && isExist)) { return nil; }
    
    // 解压ipa，只能拿到所在目录下的文件
    NSString *unzipPath = [XAPZipTools unzipIPAFile:ipaFile];
    if (!unzipPath) { return nil; }
    if (unzippedPath) { *unzippedPath = unzipPath; }
    if (![self isDirectoryPath:unzipPath]) { return nil; }

    // 查找解压文件夹下.app文件
    NSArray *contents = [self absoluteContentsOfDirectory:unzipPath];
    for (NSString *path in contents) {
        if ([self isAppFile:path]) {
            return path;
        }
    }
    return nil;
}

@end


@implementation XAPTools (TraverseExtension)

/// 文件夹下所有文件绝对路径——深度优先
+ (nullable NSArray *)absoluteSubpathsOfDirectory:(NSString *)path {
    NSError *error;
    NSArray *subpaths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path
                                                                            error:&error];
    if (error) { return nil; }
    if ([subpaths count] == 0) { return nil; }
    
    __block NSMutableArray *result = [NSMutableArray array];
    [subpaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            [result addObject:[path stringByAppendingPathComponent:obj]];
        }
    }];
    
    return result;
}

/// 文件夹下一级目录文件绝对路径
+ (nullable NSArray *)absoluteContentsOfDirectory:(NSString *)path {
    NSError *error;
    NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                            error:&error];
    if (error) { return nil; }
    if ([subpaths count] == 0) { return nil; }
    
    __block NSMutableArray *result = [NSMutableArray array];
    [subpaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            [result addObject:[path stringByAppendingPathComponent:obj]];
        }
    }];
    
    return result;
}

@end

@implementation XAPTools (DirectoryExtension)

/// 是否开启沙盒模式
+ (BOOL)isSandboxMode {
    NSString *home = NSHomeDirectory();
    // 沙盒模式下：/Users/用户名/Library/Containers/com.daniel.DHXcodeAutoPackage/Data
    // 非沙盒模式下：/Users/用户名
    if ([[home componentsSeparatedByString:@"/"] count] > 3) {
        return YES;
    }
    return NO;
}

+ (NSString *)systemUserDirectory {
    if ([self isSandboxMode]) {
        return [@"/Users/" stringByAppendingString:NSUserName()];
    }
    return NSHomeDirectory();
}

+ (NSString *)systemUserDirectoryAppendingPath:(NSString *)path {
    return [[self systemUserDirectory] stringByAppendingPathComponent:path];
}

+ (NSString *)systemSandboxDirectory {
    if (![self isSandboxMode]) {
        NSString *relativePath = [NSString stringWithFormat:@"Library/Containers/%@/Data",[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"]];
        return [NSHomeDirectory() stringByAppendingPathComponent:relativePath];
    }
    return NSHomeDirectory();
}

+ (NSString *)systemSandboxDirectoryAppendingPath:(NSString *)path {
    return [[self systemSandboxDirectory] stringByAppendingPathComponent:path];
}

+ (NSString *)systemSandboxDocumentDirectory {
        return [self systemSandboxDirectoryAppendingPath:@"Documents"];
}

+ (NSString *)systemUserDocumentsDirectory {
    return [self systemUserDirectoryAppendingPath:@"Documents"];
}

+ (NSString *)systemSandboxCachesDirectory {
    return [self systemSandboxDirectoryAppendingPath:@"Library/Caches"];
}

+ (NSString *)systemUserCachesDirectory {
    return [self systemUserDirectoryAppendingPath:@"Library/Caches"];
}

+ (NSString *)systemUserDesktopDirectory {
    return [self systemUserDirectoryAppendingPath:@"Desktop"];
}

+ (NSString *)systemSandboxDesktopDirectory {
    return [self systemSandboxDirectoryAppendingPath:@"Desktop"];
}

+ (NSString *)systemProvisioningProfilesDirectory {
    return [self systemUserDirectoryAppendingPath:@"Library/MobileDevice/Provisioning Profiles"];
}

@end
