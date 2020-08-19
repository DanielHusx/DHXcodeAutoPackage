//
//  DHProfileUtils.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHProfileModel;
NS_ASSUME_NONNULL_BEGIN

@interface DHProfileUtils : NSObject

/// 筛选匹配描述文件配置信息
///
/// @param directory 存储.mobileprovision的文档路径
/// @param channel 分发渠道
/// @param bundleId bundle id
+ (nullable NSArray <DHProfileModel *> *)filterProfileWithDirectory:(NSString *)directory
                                                           bundleId:(NSString *)bundleId
                                                            channel:(DHChannel)channel;

/// 筛选匹配描述文件配置信息
///
/// @param profileModels DHProfileModel数组
/// @param channel 分发渠道
/// @param bundleId bundle id
+ (nullable NSArray <DHProfileModel *> *)filterProfileWithProfileModels:(NSArray <DHProfileModel *> *)profileModels
                                                               bundleId:(NSString *)bundleId
                                                                channel:(DHChannel)channel;
/// 筛选匹配描述文件配置信息
///
/// @param directory 存储.mobileprovision的文档路径
/// @param teamId teamId
+ (nullable NSArray <DHProfileModel *> *)filterProfileWithDirectory:(NSString *)directory
                                                             teamId:(NSString *)teamId;
/// 筛选所有的BundleId且最新的描述文件模型数组
+ (nullable NSArray <DHProfileModel *> *)filterProfilesForUniqueBundleIdsWithDirectory:(NSString *)directory;
/// 筛选所有的TeamId且最新的描述文件模型数组
+ (nullable NSArray <DHProfileModel *> *)filterProfilesForUniqueTeamIdsWithDirectory:(NSString *)directory;
/// 筛选所有的满足bundle匹配，TeamId唯一且最新的描述文件模型数组
+ (nullable NSArray <DHProfileModel *> *)filterProfilesForUniqueTeamIdsWithDirectory:(NSString *)directory
                                                                            bundleId:(NSString *)bundleId;
@end

NS_ASSUME_NONNULL_END
