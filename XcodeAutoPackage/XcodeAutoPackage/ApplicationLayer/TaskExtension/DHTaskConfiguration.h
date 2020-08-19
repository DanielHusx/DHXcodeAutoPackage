//
//  DHTaskConfiguration.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/25.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHTaskModel;
NS_ASSUME_NONNULL_BEGIN

@interface DHTaskConfiguration : NSObject
// MARK: - 
+ (void)configureWorkspaceWithTask:(DHTaskModel *)task;
+ (void)configureProjectWithTask:(DHTaskModel *)task;
+ (void)configureArchiveWithTask:(DHTaskModel *)task;
+ (void)configureProfileWithTask:(DHTaskModel *)task;
+ (void)configureGitWithTask:(DHTaskModel *)task;
+ (void)configurePodWithTask:(DHTaskModel *)task;
+ (void)configureIPAWithTask:(DHTaskModel *)task;
// MARK: -
+ (void)configureTask:(DHTaskModel *)task withProfilePath:(NSString *)profilePath;
+ (void)configureTask:(DHTaskModel *)task withXcodeprojFile:(NSString *)xcodeprojFile;
+ (void)configureTask:(DHTaskModel *)task withTargetName:(NSString *)targetName;
+ (void)configureTask:(DHTaskModel *)task withDistributionPlatform:(NSString *)platform;
+ (void)configureTask:(DHTaskModel *)task withDistributionNickname:(NSString *)nickname;
+ (void)configureTask:(DHTaskModel *)task withProfileName:(NSString *)profileName;

@end

NS_ASSUME_NONNULL_END
