//
//  DHDistributionModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/18.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHDistributionProtocol.h"

NS_ASSUME_NONNULL_BEGIN
/**
 未知类型的发布平台
 */
@interface DHDistributionModel : NSObject <DHDistributionProtocol, NSSecureCoding, NSCoding, NSCopying>
/// 唯一标识
@property (nonatomic, copy) NSString *identity;
/// 自定义名称
@property (nonatomic, copy) NSString *nickname;
/// 平台类型
@property (nonatomic, copy) DHDistributionPlatform platformType;
/// 平台接口秘钥
@property (nonatomic, copy) NSString *platformApiKey;
/// 更新日志
@property (nonatomic, copy, nullable) NSString *changeLog;
/// 安装密码
@property (nonatomic, copy, nullable) NSString *installPassword;

/// 发布者
@property (nonatomic, strong) DHDistributer *distributer;

@end

NS_ASSUME_NONNULL_END
