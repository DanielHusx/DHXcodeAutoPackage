//
//  XAPConfigurationModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import "XAPPBXObject.h"

NS_ASSUME_NONNULL_BEGIN
@class XAPProjectExtraConfigurationModel;
@class XAPArchiveExtraConfigurationModel;
@protocol XAPDistributorProtocol;

@interface XAPConfigurationModel : XAPPBXObject

/// 源路径
@property (nonatomic, copy) NSString *path;
/// 需要设置的编译配置
@property (nonatomic, strong) NSMutableDictionary *buildSettings;
/// 项目扩展配置
@property (nonatomic, strong) XAPProjectExtraConfigurationModel *projectExtraConfiguration;
/// 导包扩展配置
@property (nonatomic, strong) XAPArchiveExtraConfigurationModel *archiveExtraConfiguration;
/// 发布者
@property (nonatomic, strong) id<XAPDistributorProtocol> distributor;

@end

NS_ASSUME_NONNULL_END
