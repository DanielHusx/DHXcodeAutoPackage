//
//  XAPProjectModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import "XAPPBXObject.h"

NS_ASSUME_NONNULL_BEGIN
@class XAPTargetModel;
@class XAPBuildConfigurationListModel;

@interface XAPProjectModel : XAPPBXObject

/// .xcodeproj文件路径
@property (nonatomic, copy) NSString *xcodeprojFilePath;
/// .pbxproj文件路径
@property (nonatomic, copy) NSString *pbxprojFilePath;
/// 关联scheme列表
@property (nonatomic, strong) NSArray <XAPTargetModel *> *targets;
/// 项目配置
@property (nonatomic, strong) XAPBuildConfigurationListModel *buildConfiguraionList;

@end

NS_ASSUME_NONNULL_END
