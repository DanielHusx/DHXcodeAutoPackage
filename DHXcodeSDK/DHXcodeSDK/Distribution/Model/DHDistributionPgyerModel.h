//
//  DHDistributionPgyerModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHDistributionProtocol.h"

typedef NS_ENUM(NSInteger, DHDistributionPgyerInstallType) {
    /// 密码安装
    DHDistributionPgyerInstallTypePassword = 2,
    /// 邀请安装
    DHDistributionPgyerInstallTypeInvite = 3
};

typedef NS_ENUM(NSInteger, DHDistributionPgyerInstallDateLimitType) {
    /// 设置有效时间
    DHDistributionPgyerInstallDateLimitTypeLimit = 1,
    /// 长期有效
    DHDistributionPgyerInstallDateLimitTypeInfinite = 2
};

NS_ASSUME_NONNULL_BEGIN
/**
 蒲公英发布平台
 */
@interface DHDistributionPgyerModel : NSObject <DHDistributionProtocol, NSSecureCoding, NSCoding, NSCopying>
/// 唯一标识
@property (nonatomic, copy) NSString *identity;
/// 自定义名称
@property (nonatomic, copy) NSString *nickname;
/// 类型
@property (nonatomic, copy) DHDistributionPlatform platformType;
/// 平台秘钥
@property (nonatomic, copy) NSString *platformApiKey;
/// 更新日志
@property (nonatomic, copy, nullable) NSString *changeLog;
/// 安装密码
@property (nonatomic, copy, nullable) NSString *installPassword;

/// 应用包名称(display name)
@property (nonatomic, copy, nullable) NSString *appDisplayName;

/// 安装类型——暂不支持手动设置
@property (nonatomic, readonly) NSNumber *installType;
/// 设置安装有效期类型——暂不支持手动设置
@property (nonatomic, readonly, nullable) NSNumber *installDateLimitType;
/// 安装有效开始时间
@property (nonatomic, readonly, nullable) NSDate *installStartDate;
/// 安装有效结束时间
@property (nonatomic, readonly, nullable) NSDate *installEndDate;

/// 发布者
@property (nonatomic, strong) DHDistributer *distributer;

@end

NS_ASSUME_NONNULL_END
