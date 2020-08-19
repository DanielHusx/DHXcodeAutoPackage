//
//  DHTaskSetter.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/25.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class DHTaskModel;
@interface DHTaskSetter : NSObject

+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withXcodeprojFile:(NSString *)xcodeprojFile;
+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withTargetName:(NSString *)targetName;
+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withTeamName:(NSString *)teamName;
+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withBundleId:(NSString *)bundleId;
+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withChannel:(NSString *)channel;
+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withDistributionPlatform:(NSString *)platform;
+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withDistributionNickname:(NSString *)nickname;
+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withDistributionAPIKey:(NSString *)apiKey;
+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withDistributionInstallPassword:(NSString *)password;
+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withDistributionChangeLog:(NSString *)changeLog;
+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withProfile:(NSString *)profile;
+ (BOOL)checkForUpdateTask:(DHTaskModel *)task withProfileName:(NSString *)profileName;

@end

NS_ASSUME_NONNULL_END
