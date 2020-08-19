//
//  DHSetterCacher.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHSetterCacher : NSObject

/// 写缓存
///
/// @param buildSettings 设置信息集合<key: 信息集合字典>
/// @param xcodeprojFile .xcodeproj文件路径
/// @param targetName scheme
/// @param configurationName Debug/Release
+ (void)cacheBuildSettings:(NSDictionary <NSString *, NSDictionary *> *)buildSettings
         withXcodeprojFile:(NSString *)xcodeprojFile
                targetName:(NSString *)targetName
         configurationName:(DHConfigurationName)configurationName;

/// 读缓存
/// @param xcodeprojFile .xcodeproj文件路径
/// @return 信息集合
+ (NSDictionary *)readBuildSettingsCacheWithXcodeprojFile:(NSString *)xcodeprojFile;

/// 删缓存
/// @param xcodeprojFile .xcodeproj文件路径
+ (void)removeBuildSettingsCacheWithXcodeprojFile:(NSString *)xcodeprojFile;

@end

NS_ASSUME_NONNULL_END
