//
//  DHTaskConfiguration.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/25.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskConfiguration.h"
#import <DHXcodeSDK/DHXcodeSDK.h>
#import "DHGlobalConfigration.h"
#import "DHTaskModel+DHTaskParseInfo.h"
#import "DHTaskUpdator.h"

@implementation DHTaskConfiguration


+ (void)configureWorkspaceWithTask:(DHTaskModel *)task {
    task.taskName = @"Workspace Task";
    task.engineeringType = kDHEngineeringTypeWorkspace;
    task.currentXcworkspaceFile = task.workspace.xcworkspaceFile;
    task.xcodeprojFileOptions = [task.workspace.projects mutableArrayValueForKey:@"xcodeprojFile"];
    
    // 多工程多Target都默认选择第一个
    DHProjectModel *project = task.workspace.projects.firstObject;
    
    [self configureTask:task withProject:project];
    [self configureProfileWithTask:task];
}

+ (void)configureProjectWithTask:(DHTaskModel *)task {
    task.taskName = @"Project Task";
    DHProjectModel *project = task.project;
    task.xcodeprojFileOptions = @[project.xcodeprojFile];
    
    [self configureTask:task withProject:project];
    [self configureProfileWithTask:task];
}

+ (void)configureArchiveWithTask:(DHTaskModel *)task {
    task.taskName = @"Archive Task";
    task.xcarchiveFile = task.archive.xcarchiveFile;
    task.exportArchiveDirectory = [task.archive.xcarchiveFile stringByDeletingLastPathComponent];
    task.exportIPADirectory = [task.archive.xcarchiveFile stringByDeletingLastPathComponent];
    
    [DHTaskUpdator updateTask:task withApp:task.archive.app];
    
    // .xcarchive内.app的embedded.mobileprovision文件不可作为打包用的profile
    // 必须是手动设置的profile
    [self configureProfileWithTask:task];
}

+ (void)configureIPAWithTask:(DHTaskModel *)task {
    task.taskName = @"IPA Task";
    task.exportIPAFile = task.ipa.ipaFile;
    task.profiles = @[task.ipa.app.embeddedProfile];
    
    [DHTaskUpdator updateTask:task withApp:task.ipa.app];
}

+ (void)configureGitWithTask:(DHTaskModel *)task {
    [DHTaskUpdator updateTask:task withGit:task.git];
}

+ (void)configurePodWithTask:(DHTaskModel *)task {
    [DHTaskUpdator updateTask:task withPod:task.pod];
}

+ (void)configureProfileWithTask:(DHTaskModel *)task {
    // 查找匹配的profile
    NSArray *profiles = [DHProfileUtils filterProfileWithDirectory:task.profilesDirectory
                                                              bundleId:task.currentBundleId
                                                               channel:task.channel];
    task.profiles = profiles;

    [DHTaskUpdator updateTask:task withProfile:profiles.firstObject];
}

// MARK: - extension
+ (void)configureTask:(DHTaskModel *)task withProfilePath:(NSString *)profilePath {
    if (![DHPathUtils isProfile:profilePath]) { return ; }
    // 组装
    NSError *error;
    DHProfileModel *profile = [DHGetterUtils fetchProfileWithProfile:profilePath
                                                           error:&error];
    if (error) { return ; }
    
    // 筛选
    task.profiles = [DHProfileUtils filterProfileWithProfileModels:[task.profiles arrayByAddingObject:profile]
                                                              bundleId:task.currentBundleId
                                                               channel:task.channel];
    // 选择用于更新的profile，优先传进来的
    DHProfileModel *updateProfile = task.profiles.firstObject;
    NSInteger index = [task.profiles indexOfObject:profile];
    if (index != NSNotFound) {
        updateProfile = task.profiles[index];
    }
    [DHTaskUpdator updateTask:task withProfile:updateProfile];
}


+ (void)configureTask:(DHTaskModel *)task withDistributionPlatform:(NSString *)platform {
    
    id<DHDistributionProtocol> p = [DHGetterUtils fetchDistributeWithPlatform:platform];
    // 检测可选的内容里面是否存在
    for (id<DHDistributionProtocol> storagedPlatform in [DHGlobalConfigration configuration].distributionPlatforms) {
        if ([storagedPlatform.platformType isEqualToString:platform]) {
            p = storagedPlatform;
            break;
        }
    }
    
    [DHTaskUpdator updateTask:task withPlatform:p];
}

+ (void)configureTask:(DHTaskModel *)task withDistributionNickname:(NSString *)nickname {
    // 检测可选的内容里面是否存在
    if ([task.distributionNicknameOptions containsObject:nickname]) {
        for (id<DHDistributionProtocol> p in [DHGlobalConfigration configuration].distributionPlatforms) {
            
            if ([p.nickname isEqualToString:nickname]) {
                [DHTaskUpdator updateTask:task withPlatform:p];
                return ;
            }
        }
    } else {
        // 不存在存储的，则更新即可
        task.currentDistributionNickname = nickname;
    }
}

+ (void)configureTask:(DHTaskModel *)task withProfileName:(NSString *)profileName {
    // 匹配可选的内容
    for (DHProfileModel *profile in task.profiles) {
        if ([profile.name isEqualToString:profileName]) {
            [DHTaskUpdator updateTask:task withProfile:profile];
            break;
        }
    }
}

+ (void)configureTask:(DHTaskModel *)task withXcodeprojFile:(NSString *)xcodeprojFile {
    if (![DHPathUtils isXcodeprojFile:xcodeprojFile]) { return ; }
    
    NSString *configurationName = task.configurationName;
     
     [self configureTask:task
       withXcodeprojFile:xcodeprojFile
              targetName:nil
       configurationName:configurationName];
}

+ (void)configureTask:(DHTaskModel *)task withTargetName:(NSString *)targetName {
    NSString *configurationName = task.configurationName;
    
    [self configureTask:task
      withXcodeprojFile:nil
             targetName:targetName
      configurationName:configurationName];
}


// MARK: - private method
+ (void)configureTask:(DHTaskModel *)task withProject:(DHProjectModel *)project {
    task.targetNameOptions = [project.targets mutableArrayValueForKey:@"name"];
    
    NSString *configurationName = task.configurationName;
    DHTargetModel *target = project.targets.firstObject;
    
    [self configureTask:task
            withProject:project
                 target:target
      configurationName:configurationName];
}


// MARK: - core
+ (void)configureTask:(DHTaskModel *)task
          withProject:(DHProjectModel *)project
               target:(DHTargetModel *)target
    configurationName:(DHConfigurationName)configurationName {
    task.currentXcodeprojFile = project.xcodeprojFile;
    task.currentTargetName = target.name;

    for (DHBuildConfigurationModel *buildConfiguration in target.buildConfigurations) {
        if ([buildConfiguration.name isEqualToString:configurationName]) {
            [DHTaskUpdator updateTask:task withConfiguration:buildConfiguration];
            break;
        }
    }
}

+ (void)configureTask:(DHTaskModel *)task
    withXcodeprojFile:(NSString *)xcodeprojFile
           targetName:(NSString *)targetName
    configurationName:(DHConfigurationName)configurationName {
    DHProjectModel *project;
    if (!xcodeprojFile) { xcodeprojFile = task.currentXcodeprojFile; }

    if (task.workspace) {
        for (DHProjectModel *p in task.workspace.projects) {
            if ([p.xcodeprojFile isEqualToString:xcodeprojFile]) {
                project = p;
                break;
            }
        }
    } else if (task.project) {
        project = task.project;
    }

    // 未找到对应的工程
    if (!project) { return ; }

    DHTargetModel *target;
    if (!targetName) { target = project.targets.firstObject; }
    else {
        for (DHTargetModel *t in project.targets) {
            if ([t.name isEqualToString:targetName]) {
                target = t;
                break;
            }
        }
    }

    // 未找到对应target
    if (!target) { return ; }
    
    task.targetNameOptions = [project.targets mutableArrayValueForKey:@"name"];
    
    [self configureTask:task
            withProject:project
                 target:target
      configurationName:configurationName];
}
@end
