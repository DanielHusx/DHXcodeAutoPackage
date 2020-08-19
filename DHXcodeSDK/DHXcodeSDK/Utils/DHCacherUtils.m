//
//  DHCacherUtils.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHCacherUtils.h"
#import "DHCacher.h"

@implementation DHCacherUtils
+ (NSString *)cacheKeyForPath:(NSString *)path encodeKey:(NSString *)key {
    // 自问自答
    // 或许用散列表或者对称加密比较好
    // 没必要，本身就是缓存到内存的东西越简单越好，减少计算
    return [path stringByAppendingPathComponent:key];
}

+ (NSString *)pathWithCacheKey:(NSString *)cacheKey decodeKey:(NSString *)key {
    return [cacheKey stringByReplacingOccurrencesOfString:key withString:@""];
}

+ (NSDictionary *)cachedMapForEncodeKey:(NSString *)key {
    NSMutableDictionary *maps = [NSMutableDictionary dictionary];
    NSDictionary *cachedMap = [DHCacher allCachedMap];
    for (NSString *cacheKey in cachedMap.allKeys) {
        if ([cacheKey containsString:key]) {
            [maps setValue:cachedMap[cacheKey] forKey:cacheKey];
        }
    }
    return maps;
}

+ (BOOL)cacheValue:(id)value forKey:(NSString *)key {
    return [DHCacher cacheValue:value forKey:key];
}

+ (BOOL)removeCacheForKey:(NSString *)key {
    return [DHCacher removeCacheForKey:key];
}

+ (id)cacheValueForKey:(NSString *)key {
    return [DHCacher cacheValueForKey:key];
}
@end
