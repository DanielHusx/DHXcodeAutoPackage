//
//  DHPathUtils.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHPathUtils.h"
#import "DHZIPUtils.h"

@implementation DHPathUtils
// MARK: - xcworkspace
+ (NSString *)findXcworkspace:(NSString *)path {
    if (![DHPathTools isDirectoryPath:path]) {
        return nil;
    }
    // 遍历路径
    NSArray *contentsList = [DHPathTools absoluteSubpathsByBreathPriorityOfDirectory:path];
    
    for (NSString *subPath in contentsList) {
        if ([self isXcworkspaceFile:subPath]) {
            return subPath;
        }
    }
    
    return nil;
}

+ (NSArray *)findXcworkspaceFiles:(NSString *)path {
    if (![DHPathTools isDirectoryPath:path]) {
        return nil;
    }
    NSMutableArray *result = [NSMutableArray array];
    
    // 遍历路径
    NSArray *contentsList = [DHPathTools absoluteSubpathsByBreathPriorityOfDirectory:path];
    for (NSString *subPath in contentsList) {
        if ([self isXcworkspaceFile:subPath]) {
            [result addObject:subPath];
        }
    }
    
    return [result copy];
}

+ (BOOL)isXcworkspaceFile:(NSString *)path {
    if (![DHPathTools isDirectoryPath:path]) { return NO; }
    if (![path containsString:@".xcworkspace"]) { return NO; }
    if ([path containsString:@".xcodeproj"]) { return NO; }
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[path   stringByAppendingPathComponent:@"contents.xcworkspacedata"]
                                                        isDirectory:&isDir];
    return !isDir && isExist;
}

+ (NSString *)getXcworkspacedataFileWithXcworkspaceFile:(NSString *)xcworkspaceFile {
    return [xcworkspaceFile stringByAppendingPathComponent:@"contents.xcworkspacedata"];
}

// MARK: - xcodeproj
+ (NSString *)findXcodeproj:(NSString *)path {
    if (![DHPathTools isDirectoryPath:path]) {
        return nil;
    }
    
    NSArray *contentsList = [DHPathTools absoluteSubpathsByBreathPriorityOfDirectory:path];
    
    for (NSString *subPath in contentsList) {
        if ([self isXcodeprojFile:subPath]) {
            return subPath;
        }
    }
    
    return nil;
}

+ (NSArray *)findXcodeprojFiles:(NSString *)path {
    if (![DHPathTools isDirectoryPath:path]) { return nil; }
    
    NSMutableArray *result = [NSMutableArray array];
    // 遍历路径
    NSArray *contentsList = [DHPathTools absoluteSubpathsByBreathPriorityOfDirectory:path];
    for (NSString *subPath in contentsList) {
        if ([self isXcodeprojFile:subPath]) {
            [result addObject:subPath];
        }
    }
    
    return [result copy];
}

+ (BOOL)isXcodeprojFile:(NSString *)path {
    if (![DHPathTools isDirectoryPath:path]) { return NO; }
    if (![path containsString:@".xcodeproj"]) { return NO; }
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[self getPbxprojFileWithXcodeprojFile:path]
                                                        isDirectory:&isDir];
    return !isDir && isExist;
}

+ (NSString *)getXcodeprojDirectoryWithXcodeprojFile:(NSString *)xcodeprojFile {
    return [xcodeprojFile stringByDeletingLastPathComponent];
}

+ (NSString *)getPbxprojFileWithXcodeprojFile:(NSString *)xcodeprojFile {
    return [xcodeprojFile stringByAppendingPathComponent:@"project.pbxproj"];
}

+ (NSString *)getSRCROOTWithXcodeprojFile:(NSString *)xcodeprojFile {
    return [xcodeprojFile stringByDeletingLastPathComponent];
}

+ (NSString *)getPROJECT_DIRWithXcodeprojFile:(NSString *)xcodeprojFile {
    return [xcodeprojFile stringByDeletingLastPathComponent];
}

+ (NSString *)getAbsolutePathWithXcodeprojFile:(NSString *)xcodeprojFile
                                  relativePath:(NSString *)relativePath {
    NSString *directory = [self getXcodeprojDirectoryWithXcodeprojFile:xcodeprojFile];
    NSString *path = relativePath;
    if ([relativePath hasPrefix:kDHRelativeValueSRCROOT]) {
        path = [relativePath substringFromIndex:kDHRelativeValueSRCROOT.length+1];
    } else if ([relativePath hasPrefix:kDHRelativeValuePROJECT_DIR]) {
        path = [relativePath substringFromIndex:kDHRelativeValuePROJECT_DIR.length+1];
    }
    while ([path hasPrefix:@"../"]) {
        directory = [directory stringByDeletingLastPathComponent];
        path = [path substringFromIndex:3];
    }
    return [directory stringByAppendingPathComponent:path];
}

// MARK: - git
+ (NSString *)findGit:(NSString *)path {
    if (![DHPathTools isDirectoryPath:path]) {
        return nil;
    }
    // 遍历路径
    NSArray *contentsList = [DHPathTools absoluteSubpathsByBreathPriorityOfDirectory:path];
    
    for (NSString *subPath in contentsList) {
        if ([self isGitFile:subPath]) {
            return subPath;
        }
    }
    
    return nil;
}

+ (BOOL)isGitFile:(NSString *)path {
    if (![DHPathTools isDirectoryPath:path]) { return NO; }
    if (![path containsString:@".git"]) { return NO; }
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                        isDirectory:&isDir];
    return isDir && isExist;
}

+ (NSString *)getGitDirectoryWithGitFile:(NSString *)gitFile {
    return [gitFile stringByDeletingLastPathComponent];
}


// MARK: - pod
+ (NSString *)findPodfile:(NSString *)path {
    if (![DHPathTools isDirectoryPath:path]) {
        return nil;
    }
    // 遍历路径
    NSArray *contentsList = [DHPathTools absoluteSubpathsByBreathPriorityOfDirectory:path];
    
    for (NSString *subPath in contentsList) {
        if ([self isPodfileFile:subPath]) {
            return subPath;
        }
    }
    
    return nil;
}

+ (BOOL)isPodfileFile:(NSString *)path {
    if (![DHPathTools isFilePath:path]) { return NO; }
    if (![path.lastPathComponent isEqualToString:@"Podfile"]) { return NO; }
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                        isDirectory:&isDir];
    return !isDir && isExist;
}

+ (NSString *)getPodfileDirectoryWithPodfile:(NSString *)podfile {
    return [podfile stringByDeletingLastPathComponent];
}


// MARK: - mobileprovision
+ (NSArray<NSString *> *)findProfiles:(NSString *)path {
    if (![DHPathTools isDirectoryPath:path]) {
        return nil;
    }
    
    NSArray *contentsList = [DHPathTools absoluteSubpathsByBreathPriorityOfDirectory:path];
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *subPath in contentsList) {
        if ([self isProfile:subPath]) {
            [result addObject:subPath];
        }
    }
    
    return [result copy];
}

+ (BOOL)isProfile:(NSString *)path {
    if (![DHPathTools isFilePath:path]) { return NO; }
    if (![path.pathExtension isEqualToString:@"mobileprovision"]) { return NO; }
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                        isDirectory:&isDir];
    return !isDir && isExist;
}

// MARK: - archive
+ (NSString *)findXcarchive:(NSString *)path {
    if (![DHPathTools isDirectoryPath:path]) {
        return nil;
    }
    // 遍历路径
    NSArray *subpaths = [DHPathTools absoluteSubpathsOfDirectory:path];
    
    for (NSString *subPath in subpaths) {
        if ([self isXcarchiveFile:subPath]) {
            return subPath;
        }
    }
    
    return nil;
}

+ (BOOL)isXcarchiveFile:(NSString *)path {
    if (![DHPathTools isDirectoryPath:path]) { return NO; }
    if (![path.pathExtension isEqualToString:@"xcarchive"]) { return NO; }
    if (![self findAppFileWithXcarchiveFile:path]) { return NO; }
    
    return YES;
}

+ (NSString *)getAppFileDirectoryWithXcarchiveFile:(NSString *)xcarchiveFile {
    return [xcarchiveFile stringByAppendingPathComponent:@"Products/Applications"];
}

+ (NSString *)getInfoPlistWithXcarchiveFile:(NSString *)xcarchiveFile {
    return [xcarchiveFile stringByAppendingPathComponent:@"info.plist"];
}

+ (NSString *)findAppFileWithXcarchiveFile:(NSString *)xcarchiveFile {
    NSString *directory = [self getAppFileDirectoryWithXcarchiveFile:xcarchiveFile];
    if (![DHPathTools isDirectoryPath:directory]) { return nil; }
    
    NSArray *contents = [DHPathTools absoluteContentsOfDirectory:directory];
    
    for (NSString *path in contents) {
        if ([self isAppFile:path]) {
            return path;
        }
    }
    return nil;
}


// MARK: - app
+ (NSString *)findApp:(NSString *)path {
    if (![DHPathTools isDirectoryPath:path]) {
        return nil;
    }
    // 遍历路径
    NSArray *subpaths = [DHPathTools absoluteSubpathsOfDirectory:path];
    
    for (NSString *subPath in subpaths) {
        if ([self isAppFile:subPath]) {
            return subPath;
        }
    }
    
    return nil;
}

+ (BOOL)isAppFile:(NSString *)path {
    if (![DHPathTools isDirectoryPath:path]) { return NO; }
    if (![path.pathExtension isEqualToString:@"app"]) { return NO; }
    NSString *embeddedProfile = [self getEmbeddedProvisionFileWithAppFile:path];
    BOOL isDir = NO;
    BOOL isExist = NO;
    // 判定embedded.mobileprovision文件是否存在
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:embeddedProfile
                                                   isDirectory:&isDir];
    if (!(!isDir && isExist)) { return NO; }
    // 判定info.plist文件是否存在
    NSString *infoPlist = [self getInfoPlistFileWithAppFile:path];
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:infoPlist
                                                   isDirectory:&isDir];
    if (!(!isDir && isExist)) { return NO; }
    
    return YES;
}

+ (NSString *)getEmbeddedProvisionFileWithAppFile:(NSString *)appFile {
    return [appFile stringByAppendingPathComponent:@"embedded.mobileprovision"];
}

+ (NSString *)getInfoPlistFileWithAppFile:(NSString *)appFile {
    return [appFile stringByAppendingPathComponent:@"info.plist"];
}

+ (NSString *)getExecutableFileWithAppFile:(NSString *)appFile relativeExecutableFile:(NSString *)relativeExecutableFile {
    return [appFile stringByAppendingPathComponent:relativeExecutableFile];
}

// MARK: - ipa
+ (NSString *)findIPA:(NSString *)path {
    if (![DHPathTools isDirectoryPath:path]) {
        return nil;
    }
    // 遍历路径
    NSArray *subpaths = [DHPathTools absoluteSubpathsOfDirectory:path];
    
    for (NSString *subPath in subpaths) {
        if ([self isIPAFile:subPath]) {
            return subPath;
        }
    }
    
    return nil;
}

+ (BOOL)isIPAFile:(NSString *)path {
    if (![DHPathTools isFilePath:path]) { return NO; }
    if (![path.pathExtension isEqualToString:@"ipa"]) { return NO; }
    
    return YES;
}

+ (NSString *)getAppFileWithIPAFile:(NSString *)ipaFile unzippedPath:(NSString **)unzippedPath {
    if (![self isIPAFile:ipaFile]) { return nil; }
    // 解压ipa，只能拿到所在目录下的文件
    NSString *unzipPath = [DHZIPUtils unzipIPAFile:ipaFile];
    if (unzippedPath) { *unzippedPath = unzipPath; }
    if (!unzippedPath) { return nil; }
    if (![DHPathTools isDirectoryPath:unzipPath]) { return nil; }
    
    // 查找解压文件夹下.app文件
    NSArray *contents = [DHPathTools absoluteSubpathsByBreathPriorityOfDirectory:unzipPath];
    for (NSString *path in contents) {
        if ([self isAppFile:path]) {
            return path;
        }
    }
    return nil;
}


#pragma mark - plist
+ (BOOL)isPlistFile:(NSString *)path {
    if (![DHPathTools isFilePath:path]) { return NO; }
    if (![path.pathExtension isEqualToString:@"plist"]) { return NO; }
    return YES;
}

@end
