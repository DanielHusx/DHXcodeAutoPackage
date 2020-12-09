//
//  XAPFirDistributor.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import "XAPDistributorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XAPFirDistributor : NSObject <XAPDistributorProtocol>
/// 标识
@property (nonatomic, copy) NSString *identifier;
/// 名称
@property (nonatomic, copy) NSString *name;
/// 接口key
@property (nonatomic, copy) NSString *apiKey;
/// 更新日志
@property (nonatomic, copy) NSString *changeLog;

/// 应用包标识
@property (nonatomic, copy) NSString *applicationBundleIdentifier;
/// 应用显示名称
@property (nonatomic, copy) NSString *applicationDisplayName;
/// 应用短版本号
@property (nonatomic, copy) NSString *applicationShortVersion;
/// 应用版本号
@property (nonatomic, copy) NSString *applicationVersion;

@end

NS_ASSUME_NONNULL_END
