//
//  DHProfileUtils.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHProfileUtils.h"
#import "DHProfileModel.h"
#import "DHCoreGetter.h"
#import "DHProfileArchiver.h"
#import "DHProfileCacher.h"


@implementation DHProfileUtils
#pragma mark - singleton
+ (instancetype)sharedManager {
    static DHProfileUtils *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DHProfileUtils alloc] init];
    });
    return _instance;
}


#pragma mark - public method
+ (NSArray <DHProfileModel *> *)filterProfileWithDirectory:(NSString *)directory
                                                  bundleId:(NSString *)bundleId
                                                   channel:(DHChannel)channel {
    NSArray *profiles = [self fetchProfilesForDirectory:directory];
    if (![DHObjectTools isValidArray:profiles]) { return nil; }
    
    NSArray *result = [DHProfileUtils filterProfileWithProfileModels:profiles
                                                                bundleId:bundleId
                                                                 channel:channel];
    return result;
}

+ (NSArray <DHProfileModel *> *)filterProfileWithDirectory:(NSString *)directory
                                                    teamId:(NSString *)teamId {
    NSArray *profiles = [self fetchProfilesForDirectory:directory];
    if (![DHObjectTools isValidArray:profiles]) { return nil; }
    
    NSArray *result = [DHProfileUtils filterProfileWithProfileModels:profiles
                                                                  teamId:teamId];
    return result;
}

+ (NSArray<DHProfileModel *> *)filterProfilesForUniqueBundleIdsWithDirectory:(NSString *)directory {
    
    NSArray *profiles = [self fetchProfilesForDirectory:directory];
    if (![DHObjectTools isValidArray:profiles]) { return nil; }
    
    NSArray *result = [self filterProfilesForUniqueBundleIdsWithProfileModels:profiles];
    return result;
}

+ (NSArray<DHProfileModel *> *)filterProfilesForUniqueTeamIdsWithDirectory:(NSString *)directory {
    
    NSArray *profiles = [self fetchProfilesForDirectory:directory];
    if (![DHObjectTools isValidArray:profiles]) { return nil; }
    
    NSArray *result = [self filterProfilesForUniqueTeamIdsWithProfileModels:profiles];
    return result;
}

+ (NSArray<DHProfileModel *> *)filterProfilesForUniqueTeamIdsWithDirectory:(NSString *)directory
                                                                  bundleId:(NSString *)bundleId {
    NSArray *profiles = [self fetchProfilesForDirectory:directory];
    if (![DHObjectTools isValidArray:profiles]) { return nil; }
    
    NSArray *result = [self filterProfilesForUniqueTeamIdsWithProfileModels:profiles bundleId:bundleId];
    return result;
}

#pragma mark - filter method
/// 筛选满足bundleIe匹配、channel相等，且最新的profile
+ (NSArray <DHProfileModel *> *)filterProfileWithProfileModels:(NSArray <DHProfileModel *> *)profileModels
                                                      bundleId:(NSString *)bundleId
                                                       channel:(DHChannel)channel {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (DHProfileModel *model in profileModels) {
        if (![self checkBundleIdInProfile:model.bundleId equalOther:bundleId]) { continue; }
        if (![channel isEqualToString:model.channel]) { continue; }
        
        DHProfileModel *foundModel = result[model.name];
        if (!foundModel) {
            [result setValue:model forKey:model.name];
            continue;
        }
        
        // 已经有匹配的，获取最新的
        if ([model.expireTimestamp integerValue] > [foundModel.expireTimestamp integerValue]) {
            [result setValue:model forKey:model.name];
        }
    }
    return [result allValues];
}

/// 筛选满足bundleIe匹配、channel相等，且最新的profile
+ (NSArray <DHProfileModel *> *)filterProfileWithProfileModels:(NSArray <DHProfileModel *> *)profileModels
                                                        teamId:(NSString *)teamId {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (DHProfileModel *model in profileModels) {
        if (![model.teamId isEqualToString:teamId]) { continue; }
        // 第一次匹配
        DHProfileModel *foundModel = result[model.name];
        if (!foundModel) {
            [result setValue:model forKey:model.name];
            continue;
        }
        
        // 已经有匹配的，获取最新的
        if ([model.expireTimestamp integerValue] > [foundModel.expireTimestamp integerValue]) {
            [result setValue:model forKey:model.name];
        }
    }
    return [result allValues];
}


/// 筛选所有唯一的bundleId，且最新的profiles
+ (NSArray<DHProfileModel *> *)filterProfilesForUniqueBundleIdsWithProfileModels:(NSArray <DHProfileModel *> *)profileModels {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (DHProfileModel *model in profileModels) {
        if (![DHObjectTools isValidString:model.bundleId]) { continue; }
        
        DHProfileModel *foundModel = result[model.bundleId];
        if (!foundModel) {
            [result setValue:model forKey:model.bundleId];
            continue;
        }
        // 如果已找到同bundleId，那么求最新者
        if (model.expireTimestamp > foundModel.expireTimestamp) {
            [result setValue:model forKey:model.bundleId];
            continue;
        }
    }
    
    return [result allValues];
}

/// 筛选TeamId唯一且最新的profiles
+ (NSArray<DHProfileModel *> *)filterProfilesForUniqueTeamIdsWithProfileModels:(NSArray <DHProfileModel *> *)profileModels {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (DHProfileModel *model in profileModels) {
        if (![DHObjectTools isValidString:model.bundleId]) { continue; }
        
        DHProfileModel *foundModel = result[model.teamId];
        if (!foundModel) {
            [result setValue:model forKey:model.teamId];
            continue;
        }
        
        // 如果已找到同teamId，那么求最新者
        if (model.expireTimestamp > foundModel.expireTimestamp) {
            [result setValue:model forKey:model.teamId];
            continue;
        }
    }
    
    return [result allValues];
}

/// 筛选满足bundleId匹配、teamId唯一，且最新的profiles
+ (NSArray<DHProfileModel *> *)filterProfilesForUniqueTeamIdsWithProfileModels:(NSArray <DHProfileModel *> *)profileModels
                                                                      bundleId:(NSString *)bundleId {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSMutableDictionary *bundleIdMatchs = [NSMutableDictionary dictionary];
    for (DHProfileModel *model in profileModels) {
        if (![self checkBundleIdInProfile:model.bundleId equalOther:bundleId]) { continue; }
        
        DHProfileModel *matchedProfile = [bundleIdMatchs valueForKey:model.bundleId];
        // 第一次匹配
        if (!matchedProfile) {
            [result setValue:model forKey:model.teamId];
            [bundleIdMatchs setValue:model forKey:model.bundleId];
            continue;
        }
        // 已经有匹配的，获取最新的
        NSInteger matchedTimestamp = [matchedProfile.expireTimestamp integerValue];
        NSInteger timestamp = [model.expireTimestamp integerValue];
        if (timestamp > matchedTimestamp) {
            [bundleIdMatchs setValue:model forKey:model.bundleId];
            [result setValue:model forKey:model.teamId];
        }
    }
    
    return [result allValues];
}


#pragma mark - private method
+ (BOOL)checkBundleIdInProfile:(NSString *)b1 equalOther:(NSString *)b2 {
    if (![DHObjectTools isValidString:b1]) { return NO; }
    if (![DHObjectTools isValidString:b2]) { return NO; }
//    if ([b1 isEqualToString:@"*"]) {
//        // 本身就是通配符，那么都行
//        return YES;
//    }
//    if (![b1 containsString:@"*"]) {
//        // 不包含通配符时，必须完全相等
//        return [b1 isEqualToString:b2];
//    }
//    // 包含通配符时
    
    b1 = [b1 stringByReplacingOccurrencesOfString:@"." withString:@"\\."];
    b1 = [b1 stringByReplacingOccurrencesOfString:@"*" withString:@".*"];
    return [DHObjectTools validateWithRegExp:b1 text:b2];
}


#pragma mark - 缓存
/// 获取路径下所有可解析的描述文件——保持最新
+ (NSArray<DHProfileModel *> *)fetchProfilesForDirectory:(NSString *)directory {
    // 读取profiles缓存
    NSArray *profiles =  [DHProfileCacher cacheProfilesForDirectory:directory];
    if (profiles) {
        // 缓存更新机制：比较缓存的与同目录下的文件路径是否都一样，一致则不重新解析
        if (![self checkSubpathsChangedInDirectory:directory withProfiles:profiles]) {
            return profiles;
        }
    }
    
    // 不存在或者路径已经更新则自动重新解析
    profiles = [DHProfileUtils getProfilesWithDirectory:directory];
    
    if (![DHObjectTools isValidArray:profiles]) {
        // 路径下所有的描述文件都无法解析、或找不到描述文件，那么清除缓存
        [DHProfileCacher removeProfilesCacheForDirectory:directory];
        [DHProfileArchiver archiveCachedProfiles];
        return nil;
    }
    // 缓存
    [DHProfileCacher cacheProfiles:profiles forDirectory:directory];
    [DHProfileArchiver archiveCachedProfiles];
    
    return profiles;
}

// 判断路径下的所有profiles文件路径与预期的是否不一致
+ (BOOL)checkSubpathsChangedInDirectory:(NSString *)directory withProfiles:(NSArray *)profiles {
    NSSet *profilePaths = [NSSet setWithArray:[DHPathUtils findProfiles:directory]];
    NSMutableSet *currentProfilePaths = [profiles mutableSetValueForKey:@"profilePath"];
    return ![profilePaths isEqualToSet:[currentProfilePaths copy]];
}

/// 组装路径下所有的描述文件为模型
+ (NSArray <DHProfileModel *> *)getProfilesWithDirectory:(NSString *)directory {
    NSArray *profilePaths = [DHPathUtils findProfiles:directory];
    NSError *error;
    NSMutableArray *profiles = [NSMutableArray arrayWithCapacity:profilePaths.count];

    for (NSString *path in profilePaths) {
        DHProfileModel *profile = [DHCoreGetter fetchProfileWithProfile:path
                                                               error:&error];
        if (error) { continue; }
        
        [profiles addObject:profile];
    }
    
    return profiles;
}

@end
