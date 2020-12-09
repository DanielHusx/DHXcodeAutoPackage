//
//  XAPTargetModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import "XAPPBXObject.h"

NS_ASSUME_NONNULL_BEGIN
@class XAPBuildConfigurationListModel;

@interface XAPTargetModel : XAPPBXObject

/// scheme名
@property (nonatomic, copy) NSString *name;
/// scheme配置
@property (nonatomic, strong) XAPBuildConfigurationListModel *buildConfigurationList;

@end

NS_ASSUME_NONNULL_END
