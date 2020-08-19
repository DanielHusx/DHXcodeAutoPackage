//
//  DHXcworkspaceUtils.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHXcworkspaceUtils : NSObject

/// 从Workspace文件中得到关联项目路径（虚拟路径）
+ (nullable NSArray <NSString *> *)getXcodeprojVirtualFilesWithWorkspaceFile:(NSString *)xcworkspaceFile;
/// 从Workspace文件中得到关联项目路径（真实路径）
+ (nullable NSArray <NSString *> *)getXcodeprojFilesWithWorkspaceFile:(NSString *)xcworkspaceFile;

@end

NS_ASSUME_NONNULL_END
