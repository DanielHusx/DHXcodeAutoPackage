//
//  DHScriptFactory.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/17.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHScriptFactory.h"
#import "DHScriptConfig.h"
#import "DHScriptModel.h"

@implementation DHScriptFactory
// MARK: - initialization class
/*
 以下或者脚本路径，出现错误不用管，执行时必然抛出参数异常
 */
+ (DHScriptModel *)scriptModelForXcodebuild {
    DHScriptModel *model = [[DHScriptModel alloc] init];
    
    NSString *xcodebuildScript = nil;
    NSError *error = nil;
    BOOL asAdministrator = NO;
    BOOL ret = [DHScriptConfig fetchXcodebuildScript:&xcodebuildScript
                                               error:&error
                                     asAdministrator:&asAdministrator];
    if (ret) {
        model.scriptCommand = xcodebuildScript;
        model.asAdministrator = asAdministrator;
    }
    
    return model;
}

+ (DHScriptModel *)scriptModelForGit {
    DHScriptModel *model = [[DHScriptModel alloc] init];
    
    NSString *gitScript = nil;
    NSError *error = nil;
    BOOL asAdministrator = NO;
    BOOL ret = [DHScriptConfig fetchGitScript:&gitScript
                                        error:&error
                              asAdministrator:&asAdministrator];
    if (ret) {
        model.scriptCommand = gitScript;
        model.asAdministrator = asAdministrator;
    }
    
    return model;
}

+ (DHScriptModel *)scriptModelForSecurity {
    DHScriptModel *model = [[DHScriptModel alloc] init];
    
    NSString *securityScript = nil;
    NSError *error = nil;
    BOOL asAdministrator = NO;
    BOOL ret = [DHScriptConfig fetchSecurityScript:&securityScript
                                             error:&error
                                   asAdministrator:&asAdministrator];
    if (ret) {
        model.scriptCommand = securityScript;
        model.asAdministrator = asAdministrator;
    }
    
    return model;
}

+ (DHScriptModel *)scriptModelForPod {
    DHScriptModel *model = [[DHScriptModel alloc] init];
    
    NSString *podScript = nil;
    NSError *error = nil;
    BOOL asAdministrator = NO;
    BOOL ret = [DHScriptConfig fetchPodScript:&podScript
                                        error:&error
                              asAdministrator:&asAdministrator];
    if (ret) {
        model.scriptCommand = podScript;
        model.asAdministrator = asAdministrator;
    }
    
    return model;
}

+ (DHScriptModel *)scriptModelForPlistBuddy {
    DHScriptModel *model = [[DHScriptModel alloc] init];
    
    NSString *plistbuddyScript = nil;
    NSError *error = nil;
    BOOL asAdministrator = NO;
    BOOL ret = [DHScriptConfig fetchPlistbuddyScript:&plistbuddyScript
                                               error:&error
                                     asAdministrator:&asAdministrator];
    if (ret) {
        model.scriptCommand = plistbuddyScript;
        model.asAdministrator = asAdministrator;
    }
    
    return model;
}

+ (DHScriptModel *)scriptModelForOtool {
    DHScriptModel *model = [[DHScriptModel alloc] init];
    
    NSString *otoolScript = nil;
    NSError *error = nil;
    BOOL asAdministrator = NO;
    BOOL ret = [DHScriptConfig fetchOtoolScript:&otoolScript
                                          error:&error
                                asAdministrator:&asAdministrator];
    if (ret) {
        model.scriptCommand = otoolScript;
        model.asAdministrator = asAdministrator;
    }
    
    return model;
}

+ (DHScriptModel *)scriptModelForCodesign {
    DHScriptModel *model = [[DHScriptModel alloc] init];
    
    NSString *codesignScript = nil;
    NSError *error = nil;
    BOOL asAdministrator = NO;
    BOOL ret = [DHScriptConfig fetchCodesignScript:&codesignScript
                                             error:&error
                                   asAdministrator:&asAdministrator];
    if (ret) {
        model.scriptCommand = codesignScript;
        model.asAdministrator = asAdministrator;
    }
    
    return model;
}

+ (DHScriptModel *)scriptModelForLipo {
    DHScriptModel *model = [[DHScriptModel alloc] init];
    
    NSString *lipoScript = nil;
    NSError *error = nil;
    BOOL asAdministrator = NO;
    BOOL ret = [DHScriptConfig fetchLipoScript:&lipoScript
                                         error:&error
                               asAdministrator:&asAdministrator];
    if (ret) {
        model.scriptCommand = lipoScript;
        model.asAdministrator = asAdministrator;
    }
    
    return model;
}

+ (DHScriptModel *)scriptModelForWhich {
    DHScriptModel *model = [[DHScriptModel alloc] init];
    
    NSString *whichScript = nil;
    NSError *error = nil;
    BOOL asAdministrator = NO;
    BOOL ret = [DHScriptConfig fetchWhichScript:&whichScript
                                          error:&error
                                asAdministrator:&asAdministrator];
    if (ret) {
        model.scriptCommand = whichScript;
        model.asAdministrator = asAdministrator;
    }
    
    return model;
}


// MARK: - xcodebuild script
+ (DHScriptModel *)fetchXcodebuildEngineeringCleanCommand:(NSString *)workspaceFileOrXcodeprojFile
                                           engineeringType:(DHEngineeringType)engineeringType
                                                    scheme:(NSString *)scheme
                                             configuration:(DHConfigurationName)configuration
                                                  verbose:(BOOL)verbose {
    DHScriptModel *command = [DHScriptFactory scriptModelForXcodebuild];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"clean"];
    [component addObject:[NSString stringWithFormat:@"-%@", engineeringType]];
    [component addObject:[NSString stringWithFormat:@"%@", workspaceFileOrXcodeprojFile]];
    if (scheme) {
        [component addObject:@"-scheme"];
        [component addObject:[NSString stringWithFormat:@"%@", scheme]];
    }
    if (configuration) {
        [component addObject:@"-configuration"];
        [component addObject:[NSString stringWithFormat:@"%@", configuration]];
    }
    if (!verbose) {
        [component addObject:@"-quiet"];
    }
    
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchXcodebuildEngineeringArchiveCommand:(NSString *)workspaceFileOrXcodeprojFile
                                             engineeringType:(DHEngineeringType)engineeringType
                                                      scheme:(NSString *)scheme
                                               configuration:(DHConfigurationName)configuration
                                                 archivePath:(NSString *)archivePath
                                                architecture:(nullable NSString *)architecture
                                                    xcconfig:(nullable NSString *)xcconfigFile
                                                    verbose:(BOOL)verbose {
    DHScriptModel *command = [DHScriptFactory scriptModelForXcodebuild];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"archive"];
    [component addObject:[NSString stringWithFormat:@"-%@", engineeringType]];
    [component addObject:[NSString stringWithFormat:@"%@", workspaceFileOrXcodeprojFile]];
    if (scheme) {
        [component addObject:@"-scheme"];
        [component addObject:[NSString stringWithFormat:@"%@", scheme]];
    }
    if (configuration) {
        [component addObject:@"-configuration"];
        [component addObject:[NSString stringWithFormat:@"%@", configuration]];
    }
    if (archivePath) {
        [component addObject:@"-archivePath"];
        [component addObject:[NSString stringWithFormat:@"%@", archivePath]];
    }
    if (architecture) {
        [component addObject:@"-arch"];
        [component addObject:[NSString stringWithFormat:@"%@", architecture]];
    }
    if (xcconfigFile) {
        [component addObject:@"-xcconfig"];
        [component addObject:[NSString stringWithFormat:@"%@", xcconfigFile]];
    }
    if (!verbose) {
        [component addObject:@"-quiet"];
    }
    
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchXcodebuildExportArchiveCommand:(NSString *)archivePath
                                    exportIPADirectory:(NSString *)exportIPADirectory
                                    exportOptionsPlist:(NSString *)exportOptionsPlist
                                               verbose:(BOOL)verbose {
    DHScriptModel *command = [DHScriptFactory scriptModelForXcodebuild];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-exportArchive"];
    if (exportOptionsPlist) {
        [component addObject:@"-exportOptionsPlist"];
        [component addObject:[NSString stringWithFormat:@"%@", exportOptionsPlist]];
    }
    if (archivePath) {
        [component addObject:@"-archivePath"];
        [component addObject:[NSString stringWithFormat:@"%@", archivePath]];
    }
    if (exportIPADirectory) {
        [component addObject:@"-exportPath"];
        [component addObject:[NSString stringWithFormat:@"%@", exportIPADirectory]];
    }
    if (!verbose) {
        [component addObject:@"-quiet"];
    }
    
    command.scriptComponent = [component copy];
    return command;
}

// MARK: - project相关
/// 解析pbxproj文件表达式的值
+ (DHScriptModel *)fetchPBXProjExpressionAttributeCommand:(NSString *)pbxprojFile
                                            attributeName:(NSString *)attributeName {

   DHScriptModel *command = [DHScriptFactory scriptModelForPlistBuddy];

   NSMutableArray *component = [NSMutableArray array];
   [component addObject:@"-c"];
   [component addObject:[NSString stringWithFormat:@"\\\"Print :%@\\\"", attributeName]];
   [component addObject:[NSString stringWithFormat:@"\\\"%@\\\"", pbxprojFile]];
   command.scriptComponent = [component copy];
   
   return command;
    
}

/// 解析pbxproj文件数组的值
+ (DHScriptModel *)fetchPBXProjArrayAttributeCommand:(NSString *)pbxprojFile
                                       attributeName:(NSString *)attributeName {

   DHScriptModel *command = [DHScriptFactory scriptModelForPlistBuddy];

   NSMutableArray *component = [NSMutableArray array];
   [component addObject:@"-c"];
   [component addObject:[NSString stringWithFormat:@"\\\"Print :%@\\\"", attributeName]];
   [component addObject:[NSString stringWithFormat:@"\\\"%@\\\"", pbxprojFile]];
   [component addObject:@"|"];
   [component addObject:@"sed -e '/Array {/d' -e '/}/d' -e 's/^[ \t]*//'"];
   command.scriptComponent = [component copy];
   
   return command;
    
}

+ (DHScriptModel *)fetchPBXProjRootObjectCommand:(NSString *)pbxprojFile {
    return [DHScriptFactory fetchPBXProjExpressionAttributeCommand:pbxprojFile
                                                     attributeName:@"rootObject"];
}

+ (DHScriptModel *)fetchPBXProjTargetIdListCommand:(NSString *)pbxprojFile
                                        rootObject:(NSString *)rootObject {
    return [DHScriptFactory fetchPBXProjArrayAttributeCommand:pbxprojFile
                                                attributeName:[NSString stringWithFormat:@"objects:%@:targets", rootObject]];
}

+ (DHScriptModel *)fetchPBXProjTargetNameCommand:(NSString *)pbxprojFile
                                        targetId:(NSString *)targetId {
    return [DHScriptFactory fetchPBXProjExpressionAttributeCommand:pbxprojFile
                                                     attributeName:[NSString stringWithFormat:@"objects:%@:name", targetId]];
}

+ (DHScriptModel *)fetchPBXProjBuildConfigureListIdCommand:(NSString *)pbxprojFile
                                                  targetId:(NSString *)targetId {
    return [DHScriptFactory fetchPBXProjExpressionAttributeCommand:pbxprojFile
                                                     attributeName:[NSString stringWithFormat:@"objects:%@:buildConfigurationList", targetId]];
}

+ (DHScriptModel *)fetchPBXProjBuildConfigureIdListCommand:(NSString *)pbxprojFile
                                      buildConfigureListId:(NSString *)buildConfigureListId {
    return [DHScriptFactory fetchPBXProjArrayAttributeCommand:pbxprojFile
                                                attributeName:[NSString stringWithFormat:@"objects:%@:buildConfigurations", buildConfigureListId]];
}

+ (DHScriptModel *)fetchPBXProjBuildConfigureNameCommand:(NSString *)pbxprojFile
                                        buildConfigureId:(NSString *)buildConfigureId {
    return [DHScriptFactory fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                             buildConfigurationId:buildConfigureId
                                                 buildSettingsKey:kDHBuildSettingsKeyName];
}

+ (DHScriptModel *)fetchPBXProjProductNameCommand:(NSString *)pbxprojFile
                                 buildConfigureId:(NSString *)buildConfigureId {
    return [DHScriptFactory fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                             buildConfigurationId:buildConfigureId
                                                 buildSettingsKey:kDHBuildSettingsKeyProductName];
}

+ (DHScriptModel *)fetchPBXProjBundleIdentifierCommand:(NSString *)pbxprojFile
                                      buildConfigureId:(NSString *)buildConfigureId {
    return [DHScriptFactory fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                             buildConfigurationId:buildConfigureId
                                                 buildSettingsKey:kDHBuildSettingsKeyBundleIdentifier];
}

+ (DHScriptModel *)fetchPBXProjEnableBitcodeCommand:(NSString *)pbxprojFile
                                   buildConfigureId:(NSString *)buildConfigureId {
    return [DHScriptFactory fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                             buildConfigurationId:buildConfigureId
                                                 buildSettingsKey:kDHBuildSettingsKeyEnableBitcode];
}

+ (DHScriptModel *)fetchPBXProjShortVersionCommand:(NSString *)pbxprojFile
                                  buildConfigureId:(NSString *)buildConfigureId {
    return [DHScriptFactory fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                             buildConfigurationId:buildConfigureId
                                                 buildSettingsKey:kDHBuildSettingsKeyVersion];
}

+ (DHScriptModel *)fetchPBXProjBuildVersionCommand:(NSString *)pbxprojFile
                                  buildConfigureId:(NSString *)buildConfigureId {
    return [DHScriptFactory fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                             buildConfigurationId:buildConfigureId
                                                 buildSettingsKey:kDHBuildSettingsKeyBuildVersion];
}

+ (DHScriptModel *)fetchPBXProjTeamIdentifierCommand:(NSString *)pbxprojFile
                                    buildConfigureId:(NSString *)buildConfigureId {
    return [DHScriptFactory fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                             buildConfigurationId:buildConfigureId
                                                 buildSettingsKey:kDHBuildSettingsKeyTeamIdentifier];
}

+ (DHScriptModel *)fetchPBXProjInfoPlistFileCommand:(NSString *)pbxprojFile
                                   buildConfigureId:(NSString *)buildConfigureId {
    return [DHScriptFactory fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                             buildConfigurationId:buildConfigureId
                                                 buildSettingsKey:kDHBuildSettingsKeyInfoPlistFile];
}

+ (DHScriptModel *)fetchPBXProjBuildSettingsValueCommand:(NSString *)pbxprojFile
                                    buildConfigurationId:(NSString *)buildConfigurationId
                                        buildSettingsKey:(NSString *)buildSettingsKey {
    return [DHScriptFactory fetchPBXProjExpressionAttributeCommand:pbxprojFile
                                                     attributeName:[NSString stringWithFormat:@"objects:%@:buildSettings:%@", buildConfigurationId, buildSettingsKey]];
}

// MARK: - profile相关
+ (DHScriptModel *)fetchProfileXMLCommand:(NSString *)profile {
    DHScriptModel *command = [DHScriptFactory scriptModelForSecurity];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"cms"];
    [component addObject:@"-D"];
    [component addObject:@"-i"];
    [component addObject:[NSString stringWithFormat:@"'%@'", profile]];
//    [component addObject:@"2>/tmp/log.txt"];
    [component addObject:@"2>/dev/null"];
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchTimestampCommand:(NSString *)time {
    DHScriptModel *command = [[DHScriptModel alloc] init];
    command.scriptCommand = @"date";
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-j -f \\\"%a %b %d  %T %Z %Y\\\""];
    [component addObject:[NSString stringWithFormat:@"\\\"%@\\\"", time]];
    [component addObject:@"\\\"+%s\\\""];
    
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchProfileAttributeCommand:(NSString *)profile
                                   attributeName:(NSString *)attributeName {
    DHScriptModel *command = [DHScriptFactory scriptModelForPlistBuddy];
    DHScriptModel *security = [DHScriptFactory fetchProfileXMLCommand:profile];
    
    NSMutableArray *component = [NSMutableArray array];

    [component addObject:@"-c"];
    [component addObject:[NSString stringWithFormat:@"'Print :%@'", attributeName]];
    [component addObject:@"/dev/stdin"];
    [component addObject:@"<<<"];
    [component addObject:@"$("];
    [component addObject:security.scriptCommand];
    [component addObjectsFromArray:security.scriptComponent];
    [component addObject:@")"];
    
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchProfileCreateTimeCommand:(NSString *)profile {
    DHScriptModel *command = [DHScriptFactory scriptModelForPlistBuddy];
    DHScriptModel *security = [DHScriptFactory fetchProfileXMLCommand:profile];
    command.scriptCommand = [@"export LANG=\\\"en_US.UTF-8\\\"; " stringByAppendingString:command.scriptCommand];
    NSMutableArray *component = [NSMutableArray array];
    
    [component addObject:@"-c"];
    [component addObject:@"'Print :CreationDate'"];
    [component addObject:@"/dev/stdin"];
    [component addObject:@"<<<"];
    [component addObject:@"$("];
    [component addObject:security.scriptCommand];
    [component addObjectsFromArray:security.scriptComponent];
    [component addObject:@")"];
    
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchProfileExpireTimeCommand:(NSString *)profile {
    DHScriptModel *command = [DHScriptFactory scriptModelForPlistBuddy];
    DHScriptModel *security = [DHScriptFactory fetchProfileXMLCommand:profile];
    // 避免出现输出无法识别
    command.scriptCommand = [@"export LANG=\\\"en_US.UTF-8\\\"; " stringByAppendingString:command.scriptCommand];
    NSMutableArray *component = [NSMutableArray array];
    
    [component addObject:@"-c"];
    [component addObject:@"'Print :ExpirationDate'"];
    [component addObject:@"/dev/stdin"];
    [component addObject:@"<<<"];
    [component addObject:@"$("];
    [component addObject:security.scriptCommand];
    [component addObjectsFromArray:security.scriptComponent];
    [component addObject:@")"];
    
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchProfileNameCommand:(NSString *)profile {
    return [DHScriptFactory fetchProfileAttributeCommand:profile
                                          attributeName:@"Name"];
}

+ (DHScriptModel *)fetchProfileUUIDCommand:(NSString *)profile {
    return [DHScriptFactory fetchProfileAttributeCommand:profile
                                          attributeName:@"UUID"];
}

+ (DHScriptModel *)fetchProfileAppIdentifierCommand:(NSString *)profile {
    return [DHScriptFactory fetchProfileAttributeCommand:profile
                                          attributeName:@"Entitlements:application-identifier"];
}

+ (DHScriptModel *)fetchProfileTeamIdentifierCommand:(NSString *)profile {
    return [DHScriptFactory fetchProfileAttributeCommand:profile
                                          attributeName:@"Entitlements:com.apple.developer.team-identifier"];
}

+ (DHScriptModel *)fetchProfileTeamNameCommand:(NSString *)profile {
    return [DHScriptFactory fetchProfileAttributeCommand:profile
                                          attributeName:@"TeamName"];
}

+ (DHScriptModel *)fetchProfileProvisionedAllDevicesCommand:(NSString *)profile {
    return [DHScriptFactory fetchProfileAttributeCommand:profile
                                          attributeName:@"ProvisionsAllDevices"];
}

+ (DHScriptModel *)fetchProfileGetTaskAllowCommand:(NSString *)profile {
    return [DHScriptFactory fetchProfileAttributeCommand:profile
                                          attributeName:@"Entitlements:get-task-allow"];
    
}

+ (DHScriptModel *)fetchProfileIsProvisionedDevicesExistedCommand:(NSString *)profile {
    DHScriptModel *command = [DHScriptFactory fetchProfileXMLCommand:profile];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObjectsFromArray:command.scriptComponent];
    [component addObject:@"|"];
    [component addObject:@"sed -e '/Array {/d' -e '/}/d' -e 's/^[ \t]*//'"];
    [component addObject:@"|"];
    [component addObject:@"grep ProvisionedDevices"];
    
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchProfileIsProvisionedAllDevicesExistedCommand:(NSString *)profile {
    DHScriptModel *command = [DHScriptFactory fetchProfileXMLCommand:profile];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObjectsFromArray:command.scriptComponent];
    [component addObject:@"|"];
    [component addObject:@"grep ProvisionsAllDevices"];
    
    command.scriptComponent = [component copy];
    return command;
}


// MARK: - git相关
+ (DHScriptModel *)fetchGitCurrentBranchCommand:(NSString *)gitDirectory {
    DHScriptModel *command = [DHScriptFactory scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"branch"];
//    [component addObject:@"--show-current"]; // 存在缺陷：游离分支无法显示
    [component addObject:@"|"];
    [component addObject:@"sed -n '/\\\\* /s///p'"];
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchGitStatusCommand:(NSString *)gitDirectory {
    DHScriptModel *command = [DHScriptFactory scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"status"];
    [component addObject:@"-s"];
    command.scriptComponent = [component copy];
    return command;
}
+ (DHScriptModel *)fetchGitAddAllCommand:(NSString *)gitDirectory {
    DHScriptModel *command = [DHScriptFactory scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"add"];
    [component addObject:@"."];
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchGitStashCommand:(NSString *)gitDirectory {
    DHScriptModel *command = [DHScriptFactory scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"stash"];
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchGitResetToHeadCommand:(NSString *)gitDirectory {
    DHScriptModel *command = [DHScriptFactory scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"reset"];
    [component addObject:@"--hard"];
    [component addObject:@"HEAD"];
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchGitPullCommand:(NSString *)gitDirectory {
    DHScriptModel *command = [DHScriptFactory scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"pull"];
    [component addObject:@"--quiet"];
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchGitBranchListCommand:(NSString *)gitDirectory {
    DHScriptModel *command = [DHScriptFactory scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"branch"];
    [component addObject:@"--all"];
    [component addObject:@"--list"];
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchGitTagListCommand:(NSString *)gitDirectory {
    DHScriptModel *command = [DHScriptFactory scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"tag"];
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchGitIsBranchNameExistedCommand:(NSString *)gitDirectory
                                         branchName:(NSString *)branchName {
    DHScriptModel *command = [DHScriptFactory scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"branch"];
    [component addObject:@"--all"];
    [component addObject:@"--list"];
    [component addObject:[NSString stringWithFormat:@"%@", branchName]];
    command.scriptComponent = [component copy];
    return command;
}
+ (DHScriptModel *)fetchGitCheckoutBranchCommand:(NSString *)gitDirectory
                                    branchName:(NSString *)branchName {
    DHScriptModel *command = [DHScriptFactory scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"checkout"];
    [component addObject:[NSString stringWithFormat:@"%@", branchName]];
    [component addObject:@"--quiet"];
    command.scriptComponent = [component copy];
    return command;
}


// MARK: pod相关
+ (DHScriptModel *)fetchPodInstallCommand:(NSString *)podfileDirectory {
    DHScriptModel *command = [DHScriptFactory scriptModelForPod];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"install"];
    [component addObject:[NSString stringWithFormat:@"--project-directory=\\\"%@\\\"", podfileDirectory]];
    [component addObject:@"--silent"];
    command.scriptComponent = [component copy];
    return command;
}


// MARK: - info.plist解析
+ (DHScriptModel *)fetchPlistAttibuteCommand:(NSString *)infoPlist
                               attributeName:(NSString *)attributeName {

   DHScriptModel *command = [DHScriptFactory scriptModelForPlistBuddy];

   NSMutableArray *component = [NSMutableArray array];
   [component addObject:@"-c"];
   [component addObject:[NSString stringWithFormat:@"'Print :%@'", attributeName]];
   [component addObject:[NSString stringWithFormat:@"%@", infoPlist]];
   command.scriptComponent = [component copy];
   
   return command;
    
}

+ (DHScriptModel *)fetchPlistProductNameCommand:(NSString *)infoPlist {
    return [DHScriptFactory fetchPlistAttibuteCommand:infoPlist
                                        attributeName:kDHPlistKeyProductName];
}

+ (DHScriptModel *)fetchPlistDisplayNameCommand:(NSString *)infoPlist {
    return [DHScriptFactory fetchPlistAttibuteCommand:infoPlist
                                        attributeName:kDHPlistKeyDisplayName];
}

+ (DHScriptModel *)fetchPlistBundleIdentifierCommand:(NSString *)infoPlist {
    return [DHScriptFactory fetchPlistAttibuteCommand:infoPlist
                                        attributeName:kDHPlistKeyBundleIdentifier];
}

+ (DHScriptModel *)fetchPlistShortVersionCommand:(NSString *)infoPlist {
    return [DHScriptFactory fetchPlistAttibuteCommand:infoPlist
                                        attributeName:kDHPlistKeyVersion];
}
+ (DHScriptModel *)fetchPlistBuildVersionCommand:(NSString *)infoPlist {
    return [DHScriptFactory fetchPlistAttibuteCommand:infoPlist
                                        attributeName:kDHPlistKeyBuildVersion];
}

+ (DHScriptModel *)fetchPlistMinimumOSVersionCommand:(NSString *)infoPlist {
    return [DHScriptFactory fetchPlistAttibuteCommand:infoPlist
                                        attributeName:kDHPlistKeyMinimumOSVersion];
}

+ (DHScriptModel *)fetchPlistExecutableFileCommand:(NSString *)infoPlist {
    return [DHScriptFactory fetchPlistAttibuteCommand:infoPlist
                                        attributeName:kDHPlistKeyExecutableFile];
}

// MARK: - info.plist设置
+ (DHScriptModel *)fetchPlistSetAttibuteCommand:(NSString *)infoPlist
                                  attributeName:(NSString *)attributeName
                                 attributeValue:(NSString *)attributeValue {

   DHScriptModel *command = [DHScriptFactory scriptModelForPlistBuddy];

   NSMutableArray *component = [NSMutableArray array];
   [component addObject:@"-c"];
   [component addObject:[NSString stringWithFormat:@"'Set :%@ \\\"%@\\\"'", attributeName, attributeValue]];
   [component addObject:[NSString stringWithFormat:@"%@", infoPlist]];
   command.scriptComponent = [component copy];
   
   return command;
    
}

+ (DHScriptModel *)fetchPlistSetProductNameCommand:(NSString *)infoPlist
                                       productName:(NSString *)productName {
    return [DHScriptFactory fetchPlistSetAttibuteCommand:infoPlist
                                           attributeName:kDHPlistKeyProductName
                                          attributeValue:productName];
}


+ (DHScriptModel *)fetchPlistSetDisplaytNameCommand:(NSString *)infoPlist
                                        displayName:(NSString *)displayName {
    return [DHScriptFactory fetchPlistSetAttibuteCommand:infoPlist
                                           attributeName:kDHPlistKeyDisplayName
                                          attributeValue:displayName];
}

+ (DHScriptModel *)fetchPlistSetBundleIdCommand:(NSString *)infoPlist
                                       bundleId:(NSString *)bundleId {
    return [DHScriptFactory fetchPlistSetAttibuteCommand:infoPlist
                                           attributeName:kDHPlistKeyBundleIdentifier
                                          attributeValue:bundleId];
}

+ (DHScriptModel *)fetchPlistSetVersionCommand:(NSString *)infoPlist
                                       version:(NSString *)version {
    return [DHScriptFactory fetchPlistSetAttibuteCommand:infoPlist
                                           attributeName:kDHPlistKeyVersion
                                          attributeValue:version];
}

+ (DHScriptModel *)fetchPlistSetBuildVersionCommand:(NSString *)infoPlist
                                       buildVersion:(NSString *)buildVersion {
    return [DHScriptFactory fetchPlistSetAttibuteCommand:infoPlist
                                           attributeName:kDHPlistKeyBuildVersion
                                          attributeValue:buildVersion];
}

// MARK: - info.plist增加属性
+ (DHScriptModel *)fetchPlistAddAttibuteCommand:(NSString *)infoPlist
                                  attributeName:(NSString *)attributeName
                                  attributeType:(NSString *)attributeType
                                 attributeValue:(NSString *)attributeValue {

   DHScriptModel *command = [DHScriptFactory scriptModelForPlistBuddy];

   NSMutableArray *component = [NSMutableArray array];
   [component addObject:@"-c"];
   [component addObject:[NSString stringWithFormat:@"'Add :%@ %@ \\\"%@\\\"'", attributeName, attributeType, attributeValue]];
   [component addObject:[NSString stringWithFormat:@"%@", infoPlist]];
   command.scriptComponent = [component copy];
   
   return command;
}

+ (DHScriptModel *)fetchPlistAddAttibuteCommand:(NSString *)infoPlist
                                  attributeName:(NSString *)attributeName
                                 attributeValue:(NSString *)attributeValue {
    return [self fetchPlistAddAttibuteCommand:infoPlist
                                attributeName:attributeName
                                attributeType:@"string"
                               attributeValue:attributeValue];
}

// MARK: - info.plist删除属性
+ (DHScriptModel *)fetchPlistDelAttibuteCommand:(NSString *)infoPlist
                                  attributeName:(NSString *)attributeName {

   DHScriptModel *command = [DHScriptFactory scriptModelForPlistBuddy];

   NSMutableArray *component = [NSMutableArray array];
   [component addObject:@"-c"];
   [component addObject:[NSString stringWithFormat:@"'Delete :%@'", attributeName]];
   [component addObject:[NSString stringWithFormat:@"%@", infoPlist]];
   command.scriptComponent = [component copy];
   
   return command;
}


// MARK: - other
+ (DHScriptModel *)fetchOtoolEnableBitcodeCommand:(NSString *)executableFile {
    DHScriptModel *command = [DHScriptFactory scriptModelForOtool];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-l"];
    [component addObject:[NSString stringWithFormat:@"%@", executableFile]];
    [component addObject:@"|"];
    [component addObject:@"grep __LLVM"];
    [component addObject:@"|"];
    [component addObject:@"wc -l"];
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchCodesignAuthorityCommand:(NSString *)appFile {
    DHScriptModel *command = [DHScriptFactory scriptModelForCodesign];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-dvvv"];
    [component addObject:[NSString stringWithFormat:@"%@", appFile]];
    [component addObject:@"2>/tmp/log.txt"];
    [component addObject:@"&&"];
    [component addObject:@"grep Authority /tmp/log.txt "];
    [component addObject:@"|"];
    [component addObject:@"head -n 1"];
    [component addObject:@"|"];
    [component addObject:@"cut -d \\\"=\\\" -f2"];
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchLipoArchitecturesCommand:(NSString *)executableFile {
    DHScriptModel *command = [DHScriptFactory scriptModelForLipo];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-info"];
    [component addObject:[NSString stringWithFormat:@"%@", executableFile]];
    [component addObject:@"|"];
    [component addObject:@"cut -d \\\":\\\" -f 3"];
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchCreateExportOptionsPlistCommand:(NSString *)exportOptionsPlistFile
                                               bundleId:(NSString *)bundleId
                                                 teamId:(NSString *)teamId
                                                channel:(DHChannel)channel
                                            profileName:(NSString *)profileName
                                          enableBitcode:(DHXMLBoolean)enableBitcode
                                      stripSwiftSymbols:(DHXMLBoolean)stripSwiftSymbols {
    DHScriptModel *command = [[DHScriptModel alloc] init];
    command.scriptCommand = @"echo";
    
    NSString *plist = [NSString stringWithFormat:@"<?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\n \
    <!DOCTYPE plist PUBLIC \\\"-//Apple//DTD PLIST 1.0//EN\\\" \\\"http://www.apple.com/DTDs/PropertyList-1.0.dtd\\\">\n \
    <plist version=\\\"1.0\\\">\n\
    <dict>\n\
    <key>teamID</key>\n\
    <string>%@</string>\n\
    <key>method</key>\n\
    <string>%@</string>\n\
    <key>stripSwiftSymbols</key>\n\
    %@\n\
    <key>provisioningProfiles</key>\n\
    <dict>\n\
        <key>%@</key>\n\
        <string>%@</string>\n\
    </dict>\n\
    <key>compileBitcode</key>\n\
    %@\n\
    </dict>\n\
    </plist>\n", teamId, channel, stripSwiftSymbols, bundleId, profileName, enableBitcode];
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:[NSString stringWithFormat:@"\\\"%@\\\"", plist]];
    [component addObject:@">"];
    [component addObject:[NSString stringWithFormat:@"%@", exportOptionsPlistFile]];
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchUnzipCommand:(NSString *)sourceFile
                     destinationFile:(NSString *)destinationFile {
    DHScriptModel *command = [[DHScriptModel alloc] init];
    command.scriptCommand = @"unzip";
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-o"];
    [component addObject:[NSString stringWithFormat:@"%@", sourceFile]];
    [component addObject:@"-d"];
    [component addObject:[NSString stringWithFormat:@"%@", destinationFile]];
    [component addObject:@" >/dev/null 2>&1"];
    command.scriptComponent = [component copy];
    return command;
}

+ (DHScriptModel *)fetchRemovePathCommand:(NSString *)file {
    DHScriptModel *command = [[DHScriptModel alloc] init];
    command.scriptCommand = @"rm";
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-rf"];
    [component addObject:[NSString stringWithFormat:@"%@", file]];
    command.scriptComponent = [component copy];
    return command;
}

// MARK: - 脚本路径
+ (DHScriptModel *)fetchGitScriptCommand {
    DHScriptModel *model = [DHScriptFactory scriptModelForWhich];
    model.scriptComponent = @[@"git"];
    return model;
}

+ (DHScriptModel *)fetchXcodebuildScriptCommand {
    DHScriptModel *model = [DHScriptFactory scriptModelForWhich];
    model.scriptComponent = @[@"xcodebuild"];
    return model;
}

+ (DHScriptModel *)fetchOtoolScriptCommand {
    DHScriptModel *model = [DHScriptFactory scriptModelForWhich];
    model.scriptComponent = @[@"otool"];
    return model;
}

+ (DHScriptModel *)fetchSecurityScriptCommand {
    DHScriptModel *model = [DHScriptFactory scriptModelForWhich];
    model.scriptComponent = @[@"security"];
    return model;
}

+ (DHScriptModel *)fetchLipoScriptCommand {
    DHScriptModel *model = [DHScriptFactory scriptModelForWhich];
    model.scriptComponent = @[@"lipo"];
    return model;
}

+ (DHScriptModel *)fetchCodesignScriptCommand {
    DHScriptModel *model = [DHScriptFactory scriptModelForWhich];
    model.scriptComponent = @[@"codesign"];
    return model;
}

/// bash交互登录shell执行环境变量
/// 将bash作为交互式登录shell调用时,/etc/paths 和/etc/paths.d/* 中的路径是由/usr/libexec /path_helper添加到PATH
/// 该路径从/etc/profile运行. do shell脚本以sh和非交互非登录shell(不读取/etc/profile)的形式调用bash.
/// 参考资料：http://www.cocoachina.com/cms/wap.php?action=article&id=105930
+ (NSString *)bashInactionLoginEnvirmentPath {
    return @"eval `/usr/libexec/path_helper -s`;";
}

+ (DHScriptModel *)fetchPodScriptCommand {
    DHScriptModel *model = [[DHScriptModel alloc] init];
    // 由于内置中断的环境变量问题（/bin/sh)，无法直接通过which pod得到正确的路径
    // 或者可以说此情况下，无法通过which得到mac内置脚本以外的脚本路径
    model.scriptCommand = [self bashInactionLoginEnvirmentPath];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"which"];
    [component addObject:@"pod"];
    model.scriptComponent = [component copy];
    
    return model;
}

+ (DHScriptModel *)fetchRubyScriptCommand {
    DHScriptModel *model = [[DHScriptModel alloc] init];
    model.scriptCommand = [self bashInactionLoginEnvirmentPath];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"which"];
    [component addObject:@"ruby"];
    model.scriptComponent = [component copy];
    
    return model;
}

@end

#pragma mark - Deprecated
@implementation DHScriptFactory (Deprecated)
/// 调用ruby时，反馈require无法加载xcodeproj命令
/// RUBY对环境要求太严格，直接弃用！
+ (DHScriptModel *)fetchTargetNameListCommand:(NSString *)pbxprojFile {
    NSString *rubyScript = nil;
    NSError *error = nil;
    BOOL asAdministrator = NO;
    BOOL ret = [DHScriptConfig fetchRubyScript:&rubyScript
                                         error:&error
                               asAdministrator:&asAdministrator];
    if (!ret) { return nil; }
    NSString *rubyFile = [[NSBundle mainBundle] pathForResource:@"getTargetNameList" ofType:@"rb"];
    
    DHScriptModel *command = [[DHScriptModel alloc] init];
    command.scriptCommand = rubyScript;
    command.asAdministrator = asAdministrator;
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:[NSString stringWithFormat:@"'%@'", rubyFile]];
    [component addObject:[NSString stringWithFormat:@"'%@'", pbxprojFile]];
    command.scriptComponent = [component copy];
    return command;
}

@end
