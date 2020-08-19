//
//  DHSetterCacher.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHSetterCacher.h"
#import "DHCacherUtils.h"

@implementation DHSetterCacher

/// 缓存buildsetting key
static NSString *const kDHCacheCodecBuildSettingsKey = @"kDHCacheCodecBuildSettingsKey";

// 写缓存
+ (void)cacheBuildSettings:(NSDictionary <NSString *, NSDictionary *> *)buildSettings
         withXcodeprojFile:(NSString *)xcodeprojFile
                targetName:(NSString *)targetName
         configurationName:(DHConfigurationName)configurationName {
    if (![DHPathTools isPathExist:xcodeprojFile]) { return ; }
    if (![DHObjectTools isValidDictionary:buildSettings]) { return ; }
    if (![DHObjectTools isValidString:targetName]) { return ; }
    if (![DHObjectTools isValidString:configurationName]) { return ; }

    NSString *cacheKey = [self cacheKeyWithXcodeprojFile:xcodeprojFile];
    NSDictionary *cacheValue = @{targetName:@{configurationName:buildSettings}};

    // 保存缓存
    [DHCacherUtils cacheValue:cacheValue forKey:cacheKey];

}

// 读缓存
+ (NSDictionary *)readBuildSettingsCacheWithXcodeprojFile:(NSString *)xcodeprojFile
                                               targetName:(NSString *)targetName
                                        configurationName:(DHConfigurationName)configurationName {
    NSDictionary *cacheValue = [self readBuildSettingsCacheWithXcodeprojFile:xcodeprojFile];
    if (![[cacheValue objectForKey:targetName] isKindOfClass:[NSDictionary class]]) { return nil; }
    if (![[cacheValue[targetName] objectForKey:configurationName] isKindOfClass:[NSDictionary class]]) { return nil; }
    return cacheValue[targetName][configurationName];
}

// 读缓存
+ (NSDictionary *)readBuildSettingsCacheWithXcodeprojFile:(NSString *)xcodeprojFile {
    NSString *cacheKey = [self cacheKeyWithXcodeprojFile:xcodeprojFile];
    return [DHCacherUtils cacheValueForKey:cacheKey];
}
// 删缓存
+ (void)removeBuildSettingsCacheWithXcodeprojFile:(NSString *)xcodeprojFile {
    NSString *cacheKey = [self cacheKeyWithXcodeprojFile:xcodeprojFile];
    [DHCacherUtils removeCacheForKey:cacheKey];
}

// 删缓存
+ (void)removeBuildSettingsCacheWithXcodeprojFile:(NSString *)xcodeprojFile
                                       targetName:(NSString *)targetName
                                configurationName:(DHConfigurationName)configurationName {
    NSString *cacheKey = [self cacheKeyWithXcodeprojFile:xcodeprojFile];
    NSDictionary *cacheValue = [DHCacherUtils cacheValueForKey:cacheKey];
    if (![DHObjectTools isValidDictionary:cacheValue]) { return ; }

    NSMutableDictionary *result = [cacheValue mutableCopy];
    // 不存在该targetName的缓存
    if (![[result objectForKey:targetName] isKindOfClass:[NSDictionary class]]) { return ; }
    if ([[result objectForKey:targetName] count] == 0) { return ; }
    // 不存在targetName->Debug/Release的缓存
    if (![[result[targetName] objectForKey:configurationName] isKindOfClass:[NSDictionary class]]) { return ; }

    NSMutableDictionary *targets = [[result objectForKey:targetName] mutableCopy];
    // 移除Debug/Release的值
    [targets removeObjectForKey:configurationName];
    if ([targets count] == 0) {
        // 移除后targetName不存在其他值则整个移除
        [result removeObjectForKey:targetName];
    } else {
        // 还存在其他，则保存修改
        [result setValue:targets forKey:targetName];
    }
    // 缓存
    [DHCacherUtils cacheValue:result forKey:cacheKey];
}

/// 缓存key
+ (NSString *)cacheKeyWithXcodeprojFile:(NSString *)xcodeprojFile {
    return [DHCacherUtils cacheKeyForPath:xcodeprojFile
                                encodeKey:kDHCacheCodecBuildSettingsKey];
}
@end
