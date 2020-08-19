//
//  DHProfileCacher.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHProfileModel;
NS_ASSUME_NONNULL_BEGIN

@interface DHProfileCacher : NSObject


/// 缓存描述文件字典
/// @param profiles 路径缓存key:描述文件数组 <directoryCacheKey:[DHProfileModel. ...]>
+ (BOOL)cacheProfiles:(NSDictionary *)profiles;

/// 缓存路径下的描述文件数组
/// @param profiles 描述文件数组
/// @param directory 路径
+ (BOOL)cacheProfiles:(NSArray <DHProfileModel *> *)profiles forDirectory:(NSString *)directory;

/// 获取缓存路径下的描述文件数组
/// @param directory 路径
+ (nullable NSArray <DHProfileModel *> *)cacheProfilesForDirectory:(NSString *)directory;

/// 删除缓存
/// @param directory 路径
+ (BOOL)removeProfilesCacheForDirectory:(NSString *)directory;


/// 读取所有缓存的描述文件字典
/// @return 路径缓存key:描述文件数组 <directoryCacheKey:[DHProfileModel. ...]>
+ (NSDictionary *)profilesCaches;

@end

NS_ASSUME_NONNULL_END
