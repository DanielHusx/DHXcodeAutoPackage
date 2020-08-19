//
//  DHProfileModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 描述文件信息
 */
@interface DHProfileModel : NSObject <NSSecureCoding, NSCoding, NSCopying>
/// 描述文件文件路径(.mobileprovision)
@property (nonatomic, copy) NSString *profilePath;
/// 名称
@property (nonatomic, copy) NSString *name;
/// bundleId
@property (nonatomic, copy) NSString *bundleId;
/// Appid
@property (nonatomic, copy) NSString *appId;
/// Team id
@property (nonatomic, copy) NSString *teamId;
/// Team名称
@property (nonatomic, copy) NSString *teamName;
/// UUID
@property (nonatomic, copy) NSString *uuid;
/// 创建时间戳
@property (nonatomic, copy) NSString *createTimestamp;
/// 过期时间戳
@property (nonatomic, copy) NSString *expireTimestamp;
/// 渠道类型
@property (nonatomic, copy) DHChannel channel;

@end

NS_ASSUME_NONNULL_END
