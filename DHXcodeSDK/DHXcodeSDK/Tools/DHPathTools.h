//
//  DHPathTools.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHPathTools : NSObject
/// 判断路径是否存在
+ (BOOL)isPathExist:(NSString *)path;
/// 路径是否是目录
+ (BOOL)isDirectoryPath:(NSString *)path;
/// 路径是否是文件
+ (BOOL)isFilePath:(NSString *)path;
/// 删除路径文件或文件夹
+ (BOOL)removePath:(NSString *)path;
/// 删除路径文件或文件夹
+ (BOOL)removePath:(NSString *)path error:(NSError *__autoreleasing _Nullable * _Nullable)error;

/// 文件夹下所有文件相对路径——深度优先
+ (nullable NSArray *)subpathsOfDirectory:(NSString *)path;
/// 文件夹下所有文件绝对路径——深度优先
+ (nullable NSArray *)absoluteSubpathsOfDirectory:(NSString *)path;
/// 文件夹下所有文件绝对路径——广度优先
+ (nullable NSArray *)absoluteSubpathsByBreathPriorityOfDirectory:(NSString *)path;

/// 文件夹下一级目录文件相对路径
+ (nullable NSArray *)contentsOfDirectory:(NSString *)path;
/// 文件夹下一级目录文件绝对路径
+ (nullable NSArray *)absoluteContentsOfDirectory:(NSString *)path;

/// 系统用户路径
+ (NSString *)systemUserDirectory;
/// 系统用户桌面路径
+ (NSString *)systemUserDesktopDirectory;
/// 系统用户文档路径
+ (NSString *)systemUserDocumentsDirectory;
/// 一般系统存储App缓存内容
+ (NSString *)systemAppCachesDirectory;

@end

NS_ASSUME_NONNULL_END
