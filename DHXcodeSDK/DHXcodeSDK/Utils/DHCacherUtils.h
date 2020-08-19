//
//  DHCacherUtils.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHCacherUtils : NSObject
/// 写缓存
+ (BOOL)cacheValue:(id)value forKey:(NSString *)key;
/// 读缓存
+ (nullable id)cacheValueForKey:(NSString *)key;
/// 移除缓存值
+ (BOOL)removeCacheForKey:(NSString *)key;

/// 读取某类的所有缓存
+ (NSDictionary *)cachedMapForEncodeKey:(NSString *)key;
/// 加密path
+ (NSString *)cacheKeyForPath:(NSString *)path encodeKey:(NSString *)key;
/// 解密path
+ (NSString *)pathWithCacheKey:(NSString *)cacheKey decodeKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
