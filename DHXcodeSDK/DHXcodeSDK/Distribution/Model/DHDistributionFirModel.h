//
//  DHDistributionFirModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHDistributionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHDistributionFirModel : NSObject <DHDistributionProtocol, NSSecureCoding, NSCoding, NSCopying>
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

/// bundle Id
@property (nonatomic, copy) NSString *appBundleId;
/// 应用包名称(display name)
@property (nonatomic, copy) NSString *appDisplayName;
/// 版本号
@property (nonatomic, copy) NSString *appVersion;
/// 子版本号
@property (nonatomic, copy) NSString *appBuildVersion;

/// 安装密码——fir.im无法设置密码，只能在网页设置
@property (nonatomic, copy, nullable) NSString *installPassword;

/// 发布者
@property (nonatomic, strong) DHDistributer *distributer;

@end

NS_ASSUME_NONNULL_END
