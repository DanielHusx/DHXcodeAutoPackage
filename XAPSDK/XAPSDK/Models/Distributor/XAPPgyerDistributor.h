//
//  XAPPgyerDistributor.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import "XAPDistributorProtocol.h"

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
@interface XAPPgyerDistributor : NSObject <XAPDistributorProtocol>
/// 标识
@property (nonatomic, copy) NSString *identifier;
/// 名称
@property (nonatomic, copy) NSString *name;
/// 接口key
@property (nonatomic, copy) NSString *apiKey;
/// 更新日志
@property (nonatomic, copy) NSString *changeLog;

/// 应用显示名称
@property (nonatomic, copy) NSString *applicationDisplayName;
/// 安装密码
@property (nonatomic, copy) NSString *installPassword;

/// 安装类型——暂不支持手动设置
@property (nonatomic, readonly) NSNumber *installType;
/// 设置安装有效期类型——暂不支持手动设置
@property (nonatomic, readonly) NSNumber *installDateLimitType;
/// 安装有效开始时间
@property (nonatomic, readonly) NSDate *installStartDate;
/// 安装有效结束时间
@property (nonatomic, readonly) NSDate *installEndDate;

@end

NS_ASSUME_NONNULL_END
