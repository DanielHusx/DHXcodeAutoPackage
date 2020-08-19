//
//  DHZIPTools.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHZIPTools : NSObject
/// 解压缩
///
/// @param path 压缩文件路径
/// @param destination 期望解压目标文件夹
/// @param unzippedPath out 解压路径
/// @param error 错误
+ (DHERROR_CODE)unzipFileAtPath:(NSString *)path
                  toDestination:(NSString *)destination
                   unzippedPath:(NSString * _Nullable __autoreleasing * _Nullable)unzippedPath
                          error:(NSError * _Nullable __autoreleasing * _Nullable)error;
/// 压缩
///
/// @param path 压缩文件存储路径
/// @param directory 需要压缩的文档路径
+ (DHERROR_CODE)createZipFileAtPath:(NSString *)path
            withContentsOfDirectory:(NSString *)directory;

@end

NS_ASSUME_NONNULL_END
