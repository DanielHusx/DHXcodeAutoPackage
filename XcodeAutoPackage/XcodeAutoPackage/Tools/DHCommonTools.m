//
//  DHCommonTools.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHCommonTools.h"
//#import "SSZipArchive.h"
#import <objc/runtime.h>
#import <DHXcodeSDK/DHXcodeSDK.h>
#import "DHGlobalConfigration.h"
//#import "DHWorkspaceModel.h"
//#import "DHProjectModel.h"
//#import "DHTargetModel.h"
//#import "DHDistributionModel.h"
//#import "DHDistributionFirModel.h"
//#import "DHDistributionPgyerModel.h"

@implementation DHCommonTools
#pragma mark - *** 有效性判断 ***
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

+ (BOOL)isPathExist:(NSString *)path {
    BOOL isDir = NO;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                       isDirectory:&isDir];
    return result;
}

/// 路径是否是目录
+ (BOOL)isDirectoryPath:(NSString *)path {
    if (![DHCommonTools isValidString:path]) { return NO; }
    BOOL isDir = NO;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                       isDirectory:&isDir];
    return isDir && result;
}

/// 路径是否是文件
+ (BOOL)isFilePath:(NSString *)path {
    if (![DHCommonTools isValidString:path]) { return NO; }
    BOOL isDir = NO;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                       isDirectory:&isDir];
    return !isDir && result;
}

+ (BOOL)removePath:(NSString *)path {
    if (![self isPathExist:path]) { return NO; }
    NSError *error;
    BOOL ret = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    return ret;
}

+ (BOOL)removePath:(NSString *)path error:(NSError **)error {
    if (![self isPathExist:path]) { return NO; }
    BOOL ret = [[NSFileManager defaultManager] removeItemAtPath:path error:error];
    return ret;
}

#pragma mark - *** 遍历路径 ***
/// 递归遍历子绝对路径——深度优先
/// @param path 遍历路径
/// @param list 存储数组
+ (void)traverseDeepPriorityByDirectory:(NSString *)path
                             saveInList:(NSMutableArray *__autoreleasing *)list  {
    BOOL isDir = NO;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                       isDirectory:&isDir];
    if (!result) { return ; }
    // 添加当前的路径
    if (list) { [*list addObject:path]; }
    // 非文档则中断
    if (!isDir) { return ; }
    // 获取一级目录子路径
    NSError *error;
    NSArray *dirArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                            error:&error];
    if (error) { return ; }
    // 遍历文档
    for (NSString *str in dirArray) {
        [self traverseDeepPriorityByDirectory:[path stringByAppendingPathComponent:str]
                                   saveInList:list];
    }
}

/// 递归遍历子绝对路径——广度优先
/// @param path 遍历路径
/// @param list 存储数组
+ (void)traverseBreadthPriorityByDirectory:(NSString *)path
                                saveInList:(NSMutableArray *__autoreleasing *)list {
    BOOL isDir = NO;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                       isDirectory:&isDir];
    if (!isDir || !result) { return ; }
    
    // 获取一级目录子路径
    NSError *error;
    NSArray *dirArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                            error:&error];
    if (error) { return ; }

    for (NSString *contents in dirArray) {
        [*list addObject:[path stringByAppendingPathComponent:contents]];
    }
    
    for (NSString *contens in dirArray) {
        NSString *absoluteContents = [path stringByAppendingPathComponent:contens];
        result = [[NSFileManager defaultManager] fileExistsAtPath:absoluteContents
                                                      isDirectory:&isDir];
        if (!isDir || !result) { continue ; }
        [self traverseBreadthPriorityByDirectory:absoluteContents
                                      saveInList:list];
    }
}

// 文件夹下所有文件绝对路径——广度优先
+ (NSArray *)absoluteSubpathsByBreathPriorityOfDirectory:(NSString *)path {
    NSMutableArray *result = [NSMutableArray array];
    [self traverseBreadthPriorityByDirectory:path
                                  saveInList:&result];
    return [result copy];
}

// 文件夹下所有文件相对路径——广度优先
+ (NSArray *)subpathsOfDirectory:(NSString *)path {
    NSError *error;
    NSArray *subpaths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:&error];
    
    if (error) { return nil; }
    
    return subpaths;
}

+ (NSArray *)contentsOfDirectory:(NSString *)path {
    NSError *error;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    
    if (error) { return nil; }
    
    return contents;
}

+ (NSArray *)absoluteSubpathsOfDirectory:(NSString *)path {
    NSArray *subpaths = [self subpathsOfDirectory:path];
    if (!subpaths) { return nil; }
    
    NSMutableArray *mutableSubpath = [NSMutableArray arrayWithArray:subpaths];
    for (NSInteger i = 0; i < [mutableSubpath count]; i++) {
        // 全路径拼接
        [mutableSubpath setObject:[path stringByAppendingPathComponent:mutableSubpath[i]] atIndexedSubscript:i];
    }
    return [mutableSubpath copy];
}

+ (NSArray *)absoluteContentsOfDirectory:(NSString *)path {
    NSArray *contents = [self contentsOfDirectory:path];
    if (!contents) { return nil; }
    
    NSMutableArray *mutableSubpath = [NSMutableArray arrayWithArray:contents];
    for (NSInteger i = 0; i < [mutableSubpath count]; i++) {
        // 全路径拼接
        [mutableSubpath setObject:[path stringByAppendingPathComponent:mutableSubpath[i]] atIndexedSubscript:i];
    }
    return [mutableSubpath copy];
}


#pragma mark - *** 默认文件夹路径 ***
+ (NSString *)systemUserDirectory {
    if ([[NSHomeDirectory() componentsSeparatedByString:@"/"] count] > 3) {
        return [@"/Users/" stringByAppendingString:NSUserName()];
    }
    
    return NSHomeDirectory();
}

+ (NSString *)systemUserDesktopDirectory {
    return [[self systemUserDirectory] stringByAppendingPathComponent:@"Desktop"];
}

+ (NSString *)systemUserDocumentsDirectory {
    return [[self systemUserDirectory] stringByAppendingPathComponent:@"Documents"];
}

+ (NSString *)systemUserCachesDirectory {
    return [[self systemUserDirectory] stringByAppendingPathComponent:@"Library/Caches"];
}

+ (NSString *)systemAppCachesDirectory {
//    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [[self systemUserCachesDirectory] stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]];
}

// MARK: - *** 工具 ***
+ (BOOL)validateWithRegExp:(NSString *)regExp text:(NSString *)text {
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:text];

}



@end
