//
//  XAPProvisioningProfileModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XAPProvisioningProfileModel : NSObject

/// 描述文件文件路径(.mobileprovision)
@property (nonatomic, copy) NSString *profilePath;
/// 名称
@property (nonatomic, copy) NSString *name;
/// bundleId
@property (nonatomic, copy) NSString *bundleIdentifier;
/// Appid
@property (nonatomic, copy) NSString *applicationIdentifier;
/// Team id
@property (nonatomic, copy) NSString *teamIdentifier;
/// Team名称
@property (nonatomic, copy) NSString *teamName;
/// UUID
@property (nonatomic, copy) NSString *uuid;
/// 创建时间戳
@property (nonatomic, copy) NSString *createTimestamp;
/// 过期时间戳
@property (nonatomic, copy) NSString *expireTimestamp;
/// 渠道类型
@property (nonatomic, copy) XAPChannel channel;

@end

NS_ASSUME_NONNULL_END
