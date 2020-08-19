//
//  DHDistributionProtocol.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHXcodeSDKConstant.h"

@class DHDistributer;
NS_ASSUME_NONNULL_BEGIN
/**
 发布平台必要属性协议
 */
@protocol DHDistributionProtocol <NSObject, NSCopying>
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
