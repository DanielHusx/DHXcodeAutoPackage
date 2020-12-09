//
//  XAPEngineerModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XAPWorkspaceModel;
@class XAPProjectModel;
@class XAPPodModel;
@class XAPGitModel;
@class XAPIPAModel;
@class XAPArchiveModel;

@interface XAPEngineerModel : NSObject

/// 工作空间
@property (nonatomic, strong) XAPWorkspaceModel *workspace;
/// 单项目
@property (nonatomic, strong) XAPProjectModel *project;
/// git
@property (nonatomic, strong) XAPGitModel *git;
/// pod
@property (nonatomic, strong) XAPPodModel *pod;
/// ipa
@property (nonatomic, strong) XAPIPAModel *ipa;
/// archive
@property (nonatomic, strong) XAPArchiveModel *archive;

@end

NS_ASSUME_NONNULL_END
