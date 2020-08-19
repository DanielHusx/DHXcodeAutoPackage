//
//  DHProfileArchiver.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHProfileArchiver : NSObject
/// 归档描述文件集合及其路径的字典
/// @param profiles 路径缓存key:描述文件数组 <directoryCacheKey:[DHProfileModel. ...]>
+ (BOOL)archiveProfiles:(NSDictionary *)profiles;

/// 归档内存缓存的内容
+ (BOOL)archiveCachedProfiles;

/// 解档本地归档的集合
+ (BOOL)unarchiveProfiles;

@end

NS_ASSUME_NONNULL_END
