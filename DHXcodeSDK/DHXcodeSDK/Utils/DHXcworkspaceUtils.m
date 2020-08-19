//
//  DHXcworkspaceUtils.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHXcworkspaceUtils.h"
#import "DHXMLTools.h"

@implementation DHXcworkspaceUtils

+ (NSArray <NSString *> *)getXcodeprojVirtualFilesWithWorkspaceFile:(NSString *)xcworkspaceFile {
    if (![DHPathUtils isXcworkspaceFile:xcworkspaceFile]) { return nil; }
    
    NSString *xcworkspacedataFile = [DHPathUtils getXcworkspacedataFileWithXcworkspaceFile:xcworkspaceFile];
    // 从contents.xcworkspacedata文件中获取关联的项目路径
    NSArray *projectFiles = [self getXcodeprojFilesWithXcworkspaceFile:xcworkspaceFile
                                                   xcworkspacedataFile:xcworkspacedataFile
                                                               virtual:YES];
    return projectFiles;
}


+ (NSArray <NSString *> *)getXcodeprojFilesWithWorkspaceFile:(NSString *)xcworkspaceFile {
    if (![DHPathUtils isXcworkspaceFile:xcworkspaceFile]) { return nil; }
    
    NSString *xcworkspacedataFile = [DHPathUtils getXcworkspacedataFileWithXcworkspaceFile:xcworkspaceFile];
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
    NSError *error = nil;
    NSString *xmlString = [NSString stringWithContentsOfFile:xcworkspacedataFile
                                                    encoding:NSUTF8StringEncoding
                                                       error:&error];
    if (error) { return nil; }
    // 解析XML
    NSDictionary *dict = [DHXMLTools dictionaryForXMLString:xmlString];
    
    NSDictionary *workspaceDict = [dict objectForKey:@"Workspace"];
    if (![workspaceDict isKindOfClass:[NSDictionary class]]) { return nil; }
    NSMutableArray *projectFiles = [NSMutableArray array];
    // 解析FileRef
    id fileRef = [workspaceDict objectForKey:@"FileRef"];
    if ([fileRef isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in fileRef) {
            if (![item isKindOfClass:[NSDictionary class]]) { continue ; }
            
            NSString *location = item[@"location"];
            
            NSString *xcodeprojFile = virtual ? [self getXcodeprojVirtualFileWithXcworkspaceFile:xcworkspaceFile location:location] : [self getXcodeprojFileWithXcworkspaceFile:xcworkspaceFile
                                                                       location:location];
            if ([DHObjectTools isValidString:xcodeprojFile]) {
                [projectFiles addObject:xcodeprojFile];
            }
        }
    } else if ([fileRef isKindOfClass:[NSDictionary class]]) {
        NSString *location = fileRef[@"location"];
        NSString *xcodeprojFile = virtual ? [self getXcodeprojVirtualFileWithXcworkspaceFile:xcworkspaceFile location:location] : [self getXcodeprojFileWithXcworkspaceFile:xcworkspaceFile
        location:location];
        if ([DHObjectTools isValidString:xcodeprojFile]) {
            [projectFiles addObject:xcodeprojFile];
        }
    } else { return nil; }
    
    return [projectFiles copy];
}

// 解析location键值
+ (NSString *)getXcodeprojVirtualFileWithXcworkspaceFile:(NSString *)xcworkspaceFile
                                                location:(NSString *)location {
    if (![location isKindOfClass:[NSString class]]) { return nil; }
    if (![location containsString:@"group:"]) { return nil; }
    
    NSString *xcodeprojFileRelativePath = [location substringFromIndex:@"group:".length];
    // 虚拟路径
    NSString *xcodeprojFile = [xcworkspaceFile stringByAppendingPathComponent:[NSString stringWithFormat:@"../%@", xcodeprojFileRelativePath]];
    if ([xcodeprojFile.lastPathComponent isEqualToString:@"Pods.xcodeproj"]) { return nil; }
    
    return xcodeprojFile;
}

// 解析location键值
+ (NSString *)getXcodeprojFileWithXcworkspaceFile:(NSString *)xcworkspaceFile
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

@end
