//
//  XAPAppStoreDistributor.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import "XAPDistributorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface XAPAppStoreDistributor : NSObject <XAPDistributorProtocol>
/// 标识
@property (nonatomic, copy) NSString *identifier;
/// 名称
@property (nonatomic, copy) NSString *name;
/// 接口key
@property (nonatomic, copy) NSString *apiKey;
/// 更新日志
@property (nonatomic, copy) NSString *changeLog;

/// issuer接口key
@property (nonatomic, copy) NSString *issuerApiKey;

@end

NS_ASSUME_NONNULL_END
