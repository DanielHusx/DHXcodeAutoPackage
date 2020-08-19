//
//  DHTaskFactory.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/25.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskFactory.h"
#import "DHTaskModel.h"
#import "DHTaskConfiguration.h"
#import "DHTaskModel+DHTaskParseInfo.h"
#import <DHXcodeSDK/DHXcodeSDK.h>

@implementation DHTaskFactory

+ (DHTaskModel *)getTaskWithPath:(NSString *)path
                           error:(NSError * _Nullable __autoreleasing * _Nonnull)error {
    DHTaskModel *model = [[DHTaskModel alloc] init];
    model.path = path;
    // task内的个性全局配置(DHConfigurationProtocol)，在初始化时，就默认将全局配置进行默认设置
    // git
    BOOL ret = NO;
    ret = [self checkToConfigureGitWithPath:path
                                       task:model
                                      error:error];
    if (*error) { return model; }
    
    // pod
    ret = [self checkToConfigurePodWithPath:path
                                       task:model
                                      error:error];
    if (*error) { return model; }
    
    // archive
    ret = [self checkToConfigureArchiveWithPath:path
                                           task:model
                                          error:error];
    if (ret || *error) { return model; }
    
    // ipa
    ret = [self checkToConfigureIPAWithPath:path
                                       task:model
                                      error:error];
    if (ret || *error) { return model; }
   
    // workspace
    ret = [self checkToConfigureWorkspaceWithPath:path
                                             task:model
                                            error:error];
    if (ret || *error) { return model; }
    
    // project
    ret = [self checkToConfigureProjectWithPath:path
                                           task:model
                                          error:error];
    if (ret || *error) { return model; }
    
    *error = [NSError errorWithDomain:kDHErrorDomain
                                 code:-1
                             userInfo:@{
                                 NSLocalizedFailureReasonErrorKey:@"path无法识别有效内容"
                             }];
    return model;
}


// MARK: - private method
+ (BOOL)checkToConfigureGitWithPath:(NSString *)path
                               task:(DHTaskModel *)task
                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSString *gitFile = [DHPathUtils findGit:path];
    if (!gitFile) { return NO; }
    
    task.git = [DHGetterUtils fetchGitWithGitFile:gitFile error:error];
    if (*error) { return NO; }
        
    [DHTaskConfiguration configureGitWithTask:task];
    return YES;
}

+ (BOOL)checkToConfigurePodWithPath:(NSString *)path
                               task:(DHTaskModel *)task
                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSString *podfile = [DHPathUtils findPodfile:path];
    if (!podfile) { return NO; }
    
    task.pod = [DHGetterUtils fetchPodWithPodfile:podfile error:error];
    if (*error) { return NO; }
    
    [DHTaskConfiguration configurePodWithTask:task];
    
    return YES;
}

+ (BOOL)checkToConfigureArchiveWithPath:(NSString *)path
                                   task:(DHTaskModel *)task
                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL isXcarchiveFile = [DHPathUtils isXcarchiveFile:path];
    if (!isXcarchiveFile) { return NO; }
    
    task.archive = [DHGetterUtils fetchArchiveWithXcarchiveFile:path
                                                      error:error];
    if (*error) { return NO; }
    
    [DHTaskConfiguration configureArchiveWithTask:task];
    
    return YES;
}

+ (BOOL)checkToConfigureIPAWithPath:(NSString *)path
                               task:(DHTaskModel *)task
                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL isIPA = [DHPathUtils isIPAFile:path];
    if (!isIPA) { return NO; }
    
    task.ipa = [DHGetterUtils fetchIPAWithIPAFile:path
                                        error:error];
    if (*error) { return NO; }
        
    [DHTaskConfiguration configureIPAWithTask:task];
    
    return YES;
}

+ (BOOL)checkToConfigureWorkspaceWithPath:(NSString *)path
                                     task:(DHTaskModel *)task
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSString *workspace = [DHPathUtils findXcworkspace:path];
    if (!workspace) { return NO; }
    // 多工程
    task.workspace = [DHGetterUtils fetchWorkspaceWithXcworkspaceFile:workspace
                                                            error:error];
    if (*error) { return NO; }

    [DHTaskConfiguration configureWorkspaceWithTask:task];
    
    return YES;
}

+ (BOOL)checkToConfigureProjectWithPath:(NSString *)path
                                   task:(DHTaskModel *)task
                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSString *project = [DHPathUtils findXcodeproj:path];
    if (!project) { return NO; }
    // 单工程
    task.project = [DHGetterUtils fetchProjectWithXcodeprojFile:project
                                                      error:error];
    if (*error) { return NO; }

    [DHTaskConfiguration configureProjectWithTask:task];
    
    return YES;
}

+ (BOOL)checkToConfigureWorkspaceAndProjectWithPath:(NSString *)path
                                               task:(DHTaskModel *)task
                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    // workspace & project
       NSArray *workspaceFiles = [DHPathUtils findXcworkspaceFiles:path];
       NSArray *projectFiles = [DHPathUtils findXcodeprojFiles:path];
       
       NSMutableSet *combinedProjectFiles = [NSMutableSet setWithArray:projectFiles];
       if ([DHCommonTools isValidArray:workspaceFiles]) {
           NSMutableArray *workpaces = [NSMutableArray arrayWithCapacity:workspaceFiles.count];
           for (NSString *file in workspaceFiles) {
               DHWorkspaceModel *item = [DHGetterUtils fetchWorkspaceWithXcworkspaceFile:file
                                                                               error:error];
               if (*error) { return NO; }
               [workpaces addObject:item];
               
               for (DHProjectModel *project in item.projects) {
                   [combinedProjectFiles addObject:project.xcodeprojFile];
               }
           }
           task.workspaces = workpaces;
       }
       if ([DHCommonTools isValidArray:[combinedProjectFiles allObjects]]) {
           NSMutableArray *projects = [NSMutableArray arrayWithCapacity:combinedProjectFiles.count];
           
           task.projects = projects;
       }
    return NO;
}

@end
