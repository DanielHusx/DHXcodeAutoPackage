//
//  XAPBuildConfigurationListModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import "XAPPBXObject.h"

NS_ASSUME_NONNULL_BEGIN
@class XAPBuildConfigurationModel;

@interface XAPBuildConfigurationListModel : XAPPBXObject

/// 配置列表
@property (nonatomic, strong) NSArray <XAPBuildConfigurationModel *> *buildConfigurations;

@end

NS_ASSUME_NONNULL_END
