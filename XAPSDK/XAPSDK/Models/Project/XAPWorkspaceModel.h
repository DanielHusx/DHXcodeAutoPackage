//
//  XAPWorkspaceModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XAPProjectModel;

@interface XAPWorkspaceModel : NSObject

/// .xcworkspace文件路径
@property (nonatomic, copy) NSString *xcworkspaceFilePath;
/// 关联项目
@property (nonatomic, strong) NSArray <XAPProjectModel *> *projects;

@end

NS_ASSUME_NONNULL_END
