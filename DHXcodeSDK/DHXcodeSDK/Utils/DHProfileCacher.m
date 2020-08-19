//
//  DHProfileCacher.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHProfileCacher.h"
#import "DHProfileModel.h"
#import "DHCacherUtils.h"

@implementation DHProfileCacher

/// 缓存profiles key
static NSString *const kDHCacheCodecProfilesKey = @"kDHCacheCodecProfilesKey";

+ (NSDictionary *)profilesCaches {
    return [DHCacherUtils cachedMapForEncodeKey:kDHCacheCodecProfilesKey];
}

+ (BOOL)cacheProfiles:(NSDictionary *)profiles {
    // 将本地读取的缓存写入缓存
    BOOL ret = YES;
    for (NSString *cacheKey in profiles.allKeys) {
        BOOL cacheRet = [self cacheProfiles:profiles[cacheKey] forCacheKey:cacheKey];
        if (!cacheRet) { ret = NO; }
    }
    return ret;
}

+ (BOOL)cacheProfiles:(NSArray <DHProfileModel *> *)profiles forDirectory:(NSString *)directory {
    NSString *cacheKey = [self profileCacheKeyForDirectory:directory];
    return [self cacheProfiles:profiles forCacheKey:cacheKey];
}

+ (NSArray <DHProfileModel *> *)cacheProfilesForDirectory:(NSString *)directory {
    NSString *cacheKey = [self profileCacheKeyForDirectory:directory];
    return [self cacheProfilesForCacheKey:cacheKey];
}

+ (BOOL)removeProfilesCacheForDirectory:(NSString *)directory {
    NSString *cacheKey = [self profileCacheKeyForDirectory:directory];
    return [self removeProfilesCacheForCacheKey:cacheKey];
}

+ (NSArray <DHProfileModel *> *)cacheProfilesForCacheKey:(NSString *)cacheKey {
    return [DHCacherUtils cacheValueForKey:cacheKey];
}

+ (BOOL)cacheProfiles:(NSArray <DHProfileModel *> *)profiles forCacheKey:(NSString *)cacheKey {
    return [DHCacherUtils cacheValue:profiles forKey:cacheKey];
}

+ (BOOL)removeProfilesCacheForCacheKey:(NSString *)cacheKey {
    return [DHCacherUtils removeCacheForKey:cacheKey];
}

+ (NSString *)profileCacheKeyForDirectory:(NSString *)directory {
    NSString *cacheKey = [DHCacherUtils cacheKeyForPath:directory
                                              encodeKey:kDHCacheCodecProfilesKey];
    return cacheKey;
}

@end
