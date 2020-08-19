//
//  DHCacher.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 内存缓存各种信息
*/
@interface DHCacher : NSObject

/// 所有缓存
+ (NSDictionary *)allCachedMap;
/// 写缓存
+ (BOOL)cacheValue:(id)value forKey:(NSString *)key;
/// 读缓存
+ (nullable id)cacheValueForKey:(NSString *)key;

/// 移除缓存值
+ (BOOL)removeCacheForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
