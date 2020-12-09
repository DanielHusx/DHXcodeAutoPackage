//
//  XAPBuildConfigurationModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import "XAPPBXObject.h"

NS_ASSUME_NONNULL_BEGIN
@class XAPInfoPlistModel;

@interface XAPBuildConfigurationModel : XAPPBXObject

/// 配置类型
@property (nonatomic, copy) XAPConfigurationName name;
/// 编译设置
@property (nonatomic, copy) NSDictionary *buildSettings;
/// info.plist信息
@property (nonatomic, strong) XAPInfoPlistModel *infoPlist;

@end

NS_ASSUME_NONNULL_END
