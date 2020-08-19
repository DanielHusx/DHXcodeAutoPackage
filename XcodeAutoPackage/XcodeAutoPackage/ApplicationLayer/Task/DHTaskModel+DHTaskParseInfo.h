//
//  DHTaskModel+DHTaskParseInfo.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/25.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskModel.h"

@class DHWorkspaceModel;
@class DHProjectModel;
@class DHPodModel;
@class DHGitModel;
@class DHArchiveModel;
@class DHIPAModel;
@class DHProfileModel;
@protocol DHDistributionProtocol;
NS_ASSUME_NONNULL_BEGIN

@interface DHTaskModel ()

/// 工作空间信息
@property (nonatomic, strong, nullable) DHWorkspaceModel *workspace;
/// 项目信息（单工程）
@property (nonatomic, strong, nullable) DHProjectModel *project;


/// 工作空间信息
@property (nonatomic, strong, nullable) NSArray <DHWorkspaceModel *> *workspaces;
/// 项目信息（单工程）
@property (nonatomic, strong, nullable) NSArray <DHProjectModel *> *projects;
/// Pod信息
@property (nonatomic, strong, nullable) DHPodModel *pod;
/// Git信息
@property (nonatomic, strong, nullable) DHGitModel *git;
/// 归档
@property (nonatomic, strong, nullable) DHArchiveModel *archive;
/// ipa
@property (nonatomic, strong, nullable) DHIPAModel *ipa;
/// 匹配的profile
@property (nonatomic, strong, nullable) NSArray<DHProfileModel *> *profiles;

/// 当前分发平台信息
@property (nonatomic, strong) id<DHDistributionProtocol> distributionPlatform;
/// 已经存储的可选的分发平台
//@property (nonatomic, strong) NSMutableArray <id<DHDistributionProtocol>> *distributionPlatforms;

@end

NS_ASSUME_NONNULL_END
