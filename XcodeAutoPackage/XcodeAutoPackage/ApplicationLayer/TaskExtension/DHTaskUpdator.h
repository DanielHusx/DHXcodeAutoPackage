//
//  DHTaskUpdator.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHTaskModel;
@class DHPodModel;
@class DHGitModel;
@class DHAppModel;
@class DHProfileModel;
@class DHBuildConfigurationModel;
@protocol DHDistributionProtocol;
NS_ASSUME_NONNULL_BEGIN

@interface DHTaskUpdator : NSObject

+ (void)updateTask:(DHTaskModel *)task withPlatform:(id<DHDistributionProtocol>)platform;
+ (void)updateTask:(DHTaskModel *)task withConfiguration:(DHBuildConfigurationModel *)configuration;
+ (void)updateTask:(DHTaskModel *)task withApp:(DHAppModel *)app;
+ (void)updateTask:(DHTaskModel *)task withProfile:(DHProfileModel *)profile;
+ (void)updateTask:(DHTaskModel *)task withGit:(DHGitModel *)git;
+ (void)updateTask:(DHTaskModel *)task withPod:(DHPodModel *)pod;

@end

NS_ASSUME_NONNULL_END
