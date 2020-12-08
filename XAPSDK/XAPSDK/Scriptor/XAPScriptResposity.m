//
//  XAPScriptResposity.m
//  XAPSDK
//
//  Created by Daniel on 2020/11/30.
//

#import "XAPScriptResposity.h"
#import "XAPScriptPathManager.h"
#import "XAPScriptModel.h"

@implementation XAPScriptResposity
// MARK: - initialization class
/*
 以下或者脚本路径，脚本环境校验应在调用此之前
 */
+ (XAPScriptModel *)scriptModelForXcodebuild {
    NSString *scriptPath = [[XAPScriptPathManager manager] scriptPathForKey:kXAPScriptPathKeyXcodebuild];
    XAPScriptModel *model = [XAPScriptModel scriptModelWithScriptPath:scriptPath];
    return model;
}

+ (XAPScriptModel *)scriptModelForGit {
    NSString *scriptPath = [[XAPScriptPathManager manager] scriptPathForKey:kXAPScriptPathKeyGit];
    XAPScriptModel *model = [XAPScriptModel scriptModelWithScriptPath:scriptPath];
    return model;
}

+ (XAPScriptModel *)scriptModelForSecurity {
    NSString *scriptPath = [[XAPScriptPathManager manager] scriptPathForKey:kXAPScriptPathKeySecurity];
    XAPScriptModel *model = [XAPScriptModel scriptModelWithScriptPath:scriptPath];
    return model;
}

+ (XAPScriptModel *)scriptModelForPod {
    NSString *scriptPath = [[XAPScriptPathManager manager] scriptPathForKey:kXAPScriptPathKeyPod];
    XAPScriptModel *model = [XAPScriptModel scriptModelWithScriptPath:scriptPath];
    return model;
}

+ (XAPScriptModel *)scriptModelForPlistBuddy {
    NSString *scriptPath = [[XAPScriptPathManager manager] scriptPathForKey:kXAPScriptPathKeyPlistbuddy];
    XAPScriptModel *model = [XAPScriptModel scriptModelWithScriptPath:scriptPath];
    return model;
}

+ (XAPScriptModel *)scriptModelForOtool {
    NSString *scriptPath = [[XAPScriptPathManager manager] scriptPathForKey:kXAPScriptPathKeyOtool];
    XAPScriptModel *model = [XAPScriptModel scriptModelWithScriptPath:scriptPath];
    return model;
}

+ (XAPScriptModel *)scriptModelForCodesign {
    NSString *scriptPath = [[XAPScriptPathManager manager] scriptPathForKey:kXAPScriptPathKeyCodesign];
    XAPScriptModel *model = [XAPScriptModel scriptModelWithScriptPath:scriptPath];
    return model;
}

+ (XAPScriptModel *)scriptModelForLipo {
    NSString *scriptPath = [[XAPScriptPathManager manager] scriptPathForKey:kXAPScriptPathKeyLipo];
    XAPScriptModel *model = [XAPScriptModel scriptModelWithScriptPath:scriptPath];
    return model;
}

+ (XAPScriptModel *)scriptModelForXcrun {
    NSString *scriptPath = [[XAPScriptPathManager manager] scriptPathForKey:kXAPScriptPathKeyXcrun];
    XAPScriptModel *model = [XAPScriptModel scriptModelWithScriptPath:scriptPath];
    return model;
}

+ (XAPScriptModel *)scriptModelForUnzip {
    NSString *scriptPath = [[XAPScriptPathManager manager] scriptPathForKey:kXAPScriptPathKeyUnzip];
    XAPScriptModel *model = [XAPScriptModel scriptModelWithScriptPath:scriptPath];
    return model;
}

+ (XAPScriptModel *)scriptModelForRm {
    NSString *scriptPath = [[XAPScriptPathManager manager] scriptPathForKey:kXAPScriptPathKeyRM];
    XAPScriptModel *model = [XAPScriptModel scriptModelWithScriptPath:scriptPath];
    return model;
}


// MARK: - xcodebuild script
+ (XAPScriptModel *)fetchXcodebuildEngineeringCleanCommand:(NSString *)workspaceFileOrXcodeprojFile
                                           engineeringType:(XAPEngineeringType)engineeringType
                                                    scheme:(NSString *)scheme
                                             configuration:(XAPConfigurationName)configuration
                                                   verbose:(BOOL)verbose {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForXcodebuild];
    command.scriptType = XAPScriptTypeDelay;
    
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
    
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchXcodebuildEngineeringArchiveCommand:(NSString *)workspaceFileOrXcodeprojFile
                                             engineeringType:(XAPEngineeringType)engineeringType
                                                      scheme:(NSString *)scheme
                                               configuration:(XAPConfigurationName)configuration
                                                 archivePath:(NSString *)archivePath
                                                architecture:(nullable NSString *)architecture
                                                    xcconfig:(nullable NSString *)xcconfigFile
                                                    verbose:(BOOL)verbose {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForXcodebuild];
    command.scriptType = XAPScriptTypeDelay;
    
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
    
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchXcodebuildExportArchiveCommand:(NSString *)archivePath
                                     exportIPADirectory:(NSString *)exportIPADirectory
                                     exportOptionsPlist:(NSString *)exportOptionsPlist
                                                verbose:(BOOL)verbose {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForXcodebuild];
    command.scriptType = XAPScriptTypeDelay;
    
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
    
    command.scriptArguments = [component copy];
    return command;
}

// MARK: - project相关
/// 解析pbxproj文件表达式的值
+ (XAPScriptModel *)fetchPBXProjExpressionAttributeCommand:(NSString *)pbxprojFile
                                             attributeName:(NSString *)attributeName {

   XAPScriptModel *command = [XAPScriptResposity scriptModelForPlistBuddy];

   NSMutableArray *component = [NSMutableArray array];
   [component addObject:@"-c"];
   [component addObject:[NSString stringWithFormat:@"\\\"Print :%@\\\"", attributeName]];
   [component addObject:[NSString stringWithFormat:@"\\\"%@\\\"", pbxprojFile]];
   command.scriptArguments = [component copy];
   
   return command;
    
}

/// 解析pbxproj文件数组的值
+ (XAPScriptModel *)fetchPBXProjArrayAttributeCommand:(NSString *)pbxprojFile
                                       attributeName:(NSString *)attributeName {

   XAPScriptModel *command = [XAPScriptResposity scriptModelForPlistBuddy];

   NSMutableArray *component = [NSMutableArray array];
   [component addObject:@"-c"];
   [component addObject:[NSString stringWithFormat:@"\\\"Print :%@\\\"", attributeName]];
   [component addObject:[NSString stringWithFormat:@"\\\"%@\\\"", pbxprojFile]];
   [component addObject:@"|"];
   [component addObject:@"sed -e '/Array {/d' -e '/}/d' -e 's/^[ \t]*//'"];
   command.scriptArguments = [component copy];
   
   return command;
    
}

+ (XAPScriptModel *)fetchPBXProjRootObjectCommand:(NSString *)pbxprojFile {
    return [XAPScriptResposity fetchPBXProjExpressionAttributeCommand:pbxprojFile
                                                        attributeName:@"rootObject"];
}

+ (XAPScriptModel *)fetchPBXProjTargetIdListCommand:(NSString *)pbxprojFile
                                         rootObject:(NSString *)rootObject {
    return [XAPScriptResposity fetchPBXProjArrayAttributeCommand:pbxprojFile
                                                   attributeName:[NSString stringWithFormat:@"objects:%@:targets", rootObject]];
}

+ (XAPScriptModel *)fetchPBXProjTargetNameCommand:(NSString *)pbxprojFile
                                         targetId:(NSString *)targetId {
    return [XAPScriptResposity fetchPBXProjExpressionAttributeCommand:pbxprojFile
                                                        attributeName:[NSString stringWithFormat:@"objects:%@:name", targetId]];
}

+ (XAPScriptModel *)fetchPBXProjBuildConfigureListIdCommand:(NSString *)pbxprojFile
                                                   targetId:(NSString *)targetId {
    return [XAPScriptResposity fetchPBXProjExpressionAttributeCommand:pbxprojFile
                                                        attributeName:[NSString stringWithFormat:@"objects:%@:buildConfigurationList", targetId]];
}

+ (XAPScriptModel *)fetchPBXProjBuildConfigureIdListCommand:(NSString *)pbxprojFile
                                       buildConfigureListId:(NSString *)buildConfigureListId {
    return [XAPScriptResposity fetchPBXProjArrayAttributeCommand:pbxprojFile
                                                   attributeName:[NSString stringWithFormat:@"objects:%@:buildConfigurations", buildConfigureListId]];
}

+ (XAPScriptModel *)fetchPBXProjBuildConfigureNameCommand:(NSString *)pbxprojFile
                                         buildConfigureId:(NSString *)buildConfigureId {
    return [XAPScriptResposity fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                                buildConfigurationId:buildConfigureId
                                                    buildSettingsKey:kXAPBuildSettingsKeyName];
}

+ (XAPScriptModel *)fetchPBXProjProductNameCommand:(NSString *)pbxprojFile
                                  buildConfigureId:(NSString *)buildConfigureId {
    return [XAPScriptResposity fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                                buildConfigurationId:buildConfigureId
                                                    buildSettingsKey:kXAPBuildSettingsKeyProductName];
}

+ (XAPScriptModel *)fetchPBXProjBundleIdentifierCommand:(NSString *)pbxprojFile
                                       buildConfigureId:(NSString *)buildConfigureId {
    return [XAPScriptResposity fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                                buildConfigurationId:buildConfigureId
                                                    buildSettingsKey:kXAPBuildSettingsKeyBundleIdentifier];
}

+ (XAPScriptModel *)fetchPBXProjEnableBitcodeCommand:(NSString *)pbxprojFile
                                    buildConfigureId:(NSString *)buildConfigureId {
    return [XAPScriptResposity fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                                buildConfigurationId:buildConfigureId
                                                    buildSettingsKey:kXAPBuildSettingsKeyEnableBitcode];
}

+ (XAPScriptModel *)fetchPBXProjShortVersionCommand:(NSString *)pbxprojFile
                                   buildConfigureId:(NSString *)buildConfigureId {
    return [XAPScriptResposity fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                                buildConfigurationId:buildConfigureId
                                                    buildSettingsKey:kXAPBuildSettingsKeyShortVersion];
}

+ (XAPScriptModel *)fetchPBXProjVersionCommand:(NSString *)pbxprojFile
                              buildConfigureId:(NSString *)buildConfigureId {
    return [XAPScriptResposity fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                                buildConfigurationId:buildConfigureId
                                                    buildSettingsKey:kXAPBuildSettingsKeyVersion];
}

+ (XAPScriptModel *)fetchPBXProjTeamIdentifierCommand:(NSString *)pbxprojFile
                                     buildConfigureId:(NSString *)buildConfigureId {
    return [XAPScriptResposity fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                                buildConfigurationId:buildConfigureId
                                                    buildSettingsKey:kXAPBuildSettingsKeyTeamIdentifier];
}

+ (XAPScriptModel *)fetchPBXProjInfoPlistFileCommand:(NSString *)pbxprojFile
                                   buildConfigureId:(NSString *)buildConfigureId {
    return [XAPScriptResposity fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                                buildConfigurationId:buildConfigureId
                                                    buildSettingsKey:kXAPBuildSettingsKeyInfoPlistFile];
}

+ (XAPScriptModel *)fetchPBXProjBuildSettingsValueCommand:(NSString *)pbxprojFile
                                     buildConfigurationId:(NSString *)buildConfigurationId
                                         buildSettingsKey:(NSString *)buildSettingsKey {
    return [XAPScriptResposity fetchPBXProjExpressionAttributeCommand:pbxprojFile
                                                        attributeName:[NSString stringWithFormat:@"objects:%@:buildSettings:%@", buildConfigurationId, buildSettingsKey]];
}

// MARK: - profile相关
+ (XAPScriptModel *)fetchProfileXMLCommand:(NSString *)profile {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForSecurity];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"cms"];
    [component addObject:@"-D"];
    [component addObject:@"-i"];
    [component addObject:[NSString stringWithFormat:@"'%@'", profile]];
//    [component addObject:@"2>/tmp/log.txt"];
    [component addObject:@"2>/dev/null"];
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchProfileInfoCommand:(NSString *)profile
                              infoPlistPath:(NSString *)plistPath {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForSecurity];
    command.scriptPath = [@"export LANG=\\\"en_US.UTF-8\\\"; " stringByAppendingString:command.scriptPath];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"cms"];
    [component addObject:@"-D"];
    [component addObject:@"-i"];
    [component addObject:[NSString stringWithFormat:@"'%@'", profile]];
    [component addObject:@">"];
    [component addObject:[NSString stringWithFormat:@"'%@'", plistPath]];
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchTimestampCommand:(NSString *)time {
    XAPScriptModel *command = [[XAPScriptModel alloc] init];
    command.scriptPath = @"date";
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-j -f \\\"%a %b %d  %T %Z %Y\\\""];
    [component addObject:[NSString stringWithFormat:@"\\\"%@\\\"", time]];
    [component addObject:@"\\\"+%s\\\""];
    
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchProfileAttributeCommand:(NSString *)profile
                                   attributeName:(NSString *)attributeName {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForPlistBuddy];
    XAPScriptModel *security = [XAPScriptResposity fetchProfileXMLCommand:profile];
    
    NSMutableArray *component = [NSMutableArray array];

    [component addObject:@"-c"];
    [component addObject:[NSString stringWithFormat:@"'Print :%@'", attributeName]];
    [component addObject:@"/dev/stdin"];
    [component addObject:@"<<<"];
    [component addObject:@"$("];
    [component addObject:security.scriptPath];
    [component addObjectsFromArray:security.scriptArguments];
    [component addObject:@")"];
    
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchProfileCreateTimeCommand:(NSString *)profile {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForPlistBuddy];
    XAPScriptModel *security = [XAPScriptResposity fetchProfileXMLCommand:profile];
    command.scriptPath = [@"export LANG=\\\"en_US.UTF-8\\\"; " stringByAppendingString:command.scriptPath];
    NSMutableArray *component = [NSMutableArray array];
    
    [component addObject:@"-c"];
    [component addObject:@"'Print :CreationDate'"];
    [component addObject:@"/dev/stdin"];
    [component addObject:@"<<<"];
    [component addObject:@"$("];
    [component addObject:security.scriptPath];
    [component addObjectsFromArray:security.scriptArguments];
    [component addObject:@")"];
    
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchProfileExpireTimeCommand:(NSString *)profile {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForPlistBuddy];
    XAPScriptModel *security = [XAPScriptResposity fetchProfileXMLCommand:profile];
    // 避免出现输出无法识别
    command.scriptPath = [@"export LANG=\\\"en_US.UTF-8\\\"; " stringByAppendingString:command.scriptPath];
    NSMutableArray *component = [NSMutableArray array];
    
    [component addObject:@"-c"];
    [component addObject:@"'Print :ExpirationDate'"];
    [component addObject:@"/dev/stdin"];
    [component addObject:@"<<<"];
    [component addObject:@"$("];
    [component addObject:security.scriptPath];
    [component addObjectsFromArray:security.scriptArguments];
    [component addObject:@")"];
    
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchProfileNameCommand:(NSString *)profile {
    return [XAPScriptResposity fetchProfileAttributeCommand:profile
                                          attributeName:@"Name"];
}

+ (XAPScriptModel *)fetchProfileUUIDCommand:(NSString *)profile {
    return [XAPScriptResposity fetchProfileAttributeCommand:profile
                                          attributeName:@"UUID"];
}

+ (XAPScriptModel *)fetchProfileAppIdentifierCommand:(NSString *)profile {
    return [XAPScriptResposity fetchProfileAttributeCommand:profile
                                          attributeName:@"Entitlements:application-identifier"];
}

+ (XAPScriptModel *)fetchProfileTeamIdentifierCommand:(NSString *)profile {
    return [XAPScriptResposity fetchProfileAttributeCommand:profile
                                          attributeName:@"Entitlements:com.apple.developer.team-identifier"];
}

+ (XAPScriptModel *)fetchProfileTeamNameCommand:(NSString *)profile {
    return [XAPScriptResposity fetchProfileAttributeCommand:profile
                                          attributeName:@"TeamName"];
}

+ (XAPScriptModel *)fetchProfileProvisionedAllDevicesCommand:(NSString *)profile {
    return [XAPScriptResposity fetchProfileAttributeCommand:profile
                                          attributeName:@"ProvisionsAllDevices"];
}

+ (XAPScriptModel *)fetchProfileGetTaskAllowCommand:(NSString *)profile {
    return [XAPScriptResposity fetchProfileAttributeCommand:profile
                                          attributeName:@"Entitlements:get-task-allow"];
    
}

+ (XAPScriptModel *)fetchProfileIsProvisionedDevicesExistedCommand:(NSString *)profile {
    XAPScriptModel *command = [XAPScriptResposity fetchProfileXMLCommand:profile];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObjectsFromArray:command.scriptArguments];
    [component addObject:@"|"];
    [component addObject:@"sed -e '/Array {/d' -e '/}/d' -e 's/^[ \t]*//'"];
    [component addObject:@"|"];
    [component addObject:@"grep ProvisionedDevices"];
    
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchProfileIsProvisionedAllDevicesExistedCommand:(NSString *)profile {
    XAPScriptModel *command = [XAPScriptResposity fetchProfileXMLCommand:profile];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObjectsFromArray:command.scriptArguments];
    [component addObject:@"|"];
    [component addObject:@"grep ProvisionsAllDevices"];
    
    command.scriptArguments = [component copy];
    return command;
}


// MARK: - git相关
+ (XAPScriptModel *)fetchGitCurrentBranchCommand:(NSString *)gitDirectory {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"branch"];
//    [component addObject:@"--show-current"]; // 存在缺陷：游离分支无法显示
    [component addObject:@"|"];
    [component addObject:@"sed -n '/\\\\* /s///p'"];
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchGitStatusCommand:(NSString *)gitDirectory {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"status"];
    [component addObject:@"-s"];
    command.scriptArguments = [component copy];
    return command;
}
+ (XAPScriptModel *)fetchGitAddAllCommand:(NSString *)gitDirectory {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"add"];
    [component addObject:@"."];
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchGitStashCommand:(NSString *)gitDirectory {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"stash"];
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchGitResetToHeadCommand:(NSString *)gitDirectory {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"reset"];
    [component addObject:@"--hard"];
    [component addObject:@"HEAD"];
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchGitPullCommand:(NSString *)gitDirectory {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"pull"];
    [component addObject:@"--quiet"];
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchGitBranchListCommand:(NSString *)gitDirectory {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"branch"];
    [component addObject:@"--all"];
    [component addObject:@"--list"];
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchGitTagListCommand:(NSString *)gitDirectory {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"tag"];
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchGitIsBranchNameExistedCommand:(NSString *)gitDirectory
                                            branchName:(NSString *)branchName {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"branch"];
    [component addObject:@"--all"];
    [component addObject:@"--list"];
    [component addObject:[NSString stringWithFormat:@"%@", branchName]];
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchGitCheckoutBranchCommand:(NSString *)gitDirectory
                                       branchName:(NSString *)branchName {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForGit];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-C"];
    [component addObject:[NSString stringWithFormat:@"%@", gitDirectory]];
    [component addObject:@"checkout"];
    [component addObject:[NSString stringWithFormat:@"%@", branchName]];
    [component addObject:@"--quiet"];
    command.scriptArguments = [component copy];
    return command;
}


// MARK: pod相关
+ (XAPScriptModel *)fetchPodInstallCommand:(NSString *)podfileDirectory {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForPod];
    command.scriptType = XAPScriptTypeDelay;
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"install"];
    [component addObject:[NSString stringWithFormat:@"--project-directory=\\\"%@\\\"", podfileDirectory]];
    [component addObject:@"--silent"];
    command.scriptArguments = [component copy];
    return command;
}


// MARK: - info.plist解析
+ (XAPScriptModel *)fetchPlistAttibuteCommand:(NSString *)infoPlist
                                attributeName:(NSString *)attributeName {

   XAPScriptModel *command = [XAPScriptResposity scriptModelForPlistBuddy];

   NSMutableArray *component = [NSMutableArray array];
   [component addObject:@"-c"];
   [component addObject:[NSString stringWithFormat:@"'Print :%@'", attributeName]];
   [component addObject:[NSString stringWithFormat:@"%@", infoPlist]];
   command.scriptArguments = [component copy];
   
   return command;
    
}

// MARK: - info.plist设置
+ (XAPScriptModel *)fetchPlistSetAttibuteCommand:(NSString *)infoPlist
                                  attributeName:(NSString *)attributeName
                                 attributeValue:(NSString *)attributeValue {

   XAPScriptModel *command = [XAPScriptResposity scriptModelForPlistBuddy];

   NSMutableArray *component = [NSMutableArray array];
   [component addObject:@"-c"];
   [component addObject:[NSString stringWithFormat:@"'Set :%@ \\\"%@\\\"'", attributeName, attributeValue]];
   [component addObject:[NSString stringWithFormat:@"%@", infoPlist]];
   command.scriptArguments = [component copy];
   
   return command;
    
}

+ (XAPScriptModel *)fetchPlistSetProductNameCommand:(NSString *)infoPlist
                                        productName:(NSString *)productName {
    return [XAPScriptResposity fetchPlistSetAttibuteCommand:infoPlist
                                              attributeName:kXAPKeyBundleName
                                             attributeValue:productName];
}


+ (XAPScriptModel *)fetchPlistSetDisplaytNameCommand:(NSString *)infoPlist
                                         displayName:(NSString *)displayName {
    return [XAPScriptResposity fetchPlistSetAttibuteCommand:infoPlist
                                              attributeName:kXAPKeyDisplayName
                                             attributeValue:displayName];
}

+ (XAPScriptModel *)fetchPlistSetBundleIdCommand:(NSString *)infoPlist
                                        bundleId:(NSString *)bundleId {
    return [XAPScriptResposity fetchPlistSetAttibuteCommand:infoPlist
                                              attributeName:kXAPKeyBundleIdentifier
                                             attributeValue:bundleId];
}

+ (XAPScriptModel *)fetchPlistSetShortVersionCommand:(NSString *)infoPlist
                                        shortVersion:(NSString *)shortVersion {
    return [XAPScriptResposity fetchPlistSetAttibuteCommand:infoPlist
                                              attributeName:kXAPKeyShortVersion
                                             attributeValue:shortVersion];
}

+ (XAPScriptModel *)fetchPlistSetVersionCommand:(NSString *)infoPlist
                                        version:(NSString *)version {
    return [XAPScriptResposity fetchPlistSetAttibuteCommand:infoPlist
                                              attributeName:kXAPKeyVersion
                                             attributeValue:version];
}

// MARK: - info.plist增加属性
+ (XAPScriptModel *)fetchPlistAddAttibuteCommand:(NSString *)infoPlist
                                   attributeName:(NSString *)attributeName
                                   attributeType:(NSString *)attributeType
                                  attributeValue:(NSString *)attributeValue {

   XAPScriptModel *command = [XAPScriptResposity scriptModelForPlistBuddy];

   NSMutableArray *component = [NSMutableArray array];
   [component addObject:@"-c"];
   [component addObject:[NSString stringWithFormat:@"'Add :%@ %@ \\\"%@\\\"'", attributeName, attributeType, attributeValue]];
   [component addObject:[NSString stringWithFormat:@"%@", infoPlist]];
   command.scriptArguments = [component copy];
   
   return command;
}

+ (XAPScriptModel *)fetchPlistAddAttibuteCommand:(NSString *)infoPlist
                                   attributeName:(NSString *)attributeName
                                  attributeValue:(NSString *)attributeValue {
    return [self fetchPlistAddAttibuteCommand:infoPlist
                                    attributeName:attributeName
                                    attributeType:@"string"
                                attributeValue:attributeValue];
}

// MARK: - info.plist删除属性
+ (XAPScriptModel *)fetchPlistDelAttibuteCommand:(NSString *)infoPlist
                                   attributeName:(NSString *)attributeName {

   XAPScriptModel *command = [XAPScriptResposity scriptModelForPlistBuddy];

   NSMutableArray *component = [NSMutableArray array];
   [component addObject:@"-c"];
   [component addObject:[NSString stringWithFormat:@"'Delete :%@'", attributeName]];
   [component addObject:[NSString stringWithFormat:@"%@", infoPlist]];
   command.scriptArguments = [component copy];
   
   return command;
}


// MARK: - 上传IPA至AppStore
/// 验证ipa包的正确性
+ (XAPScriptModel *)fetchXcrunValidateIPACommand:(NSString *)ipaFile
                                           apiKey:(NSString *)apiKey
                                       apiIssuer:(NSString *)apiIssuer {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForXcrun];
    command.scriptType = XAPScriptTypeDelay;
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"altool"];
    [component addObject:[NSString stringWithFormat:@"--validate-app -f %@", ipaFile]];
    [component addObject:[NSString stringWithFormat:@"--apiKey %@", apiKey]];
    [component addObject:[NSString stringWithFormat:@"--apiIssuer %@", apiIssuer]];
    [component addObject:@"--verbose"];
    command.scriptArguments = [component copy];
    
    return command;
}

/// 上传ipa包
+ (XAPScriptModel *)fetchXcrunUploadIPACommand:(NSString *)ipaFile
                                        apiKey:(NSString *)apiKey
                                     apiIssuer:(NSString *)apiIssuer {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForXcrun];
    command.scriptType = XAPScriptTypeDelay;
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"altool"];
    [component addObject:[NSString stringWithFormat:@"--upload-app -f %@", ipaFile]];
    [component addObject:[NSString stringWithFormat:@"--apiKey %@", apiKey]];
    [component addObject:[NSString stringWithFormat:@"--apiIssuer %@", apiIssuer]];
    [component addObject:@"--verbose"];
    command.scriptArguments = [component copy];
    
    return command;
}


// MARK: - other
+ (XAPScriptModel *)fetchOtoolEnableBitcodeCommand:(NSString *)executableFile {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForOtool];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-l"];
    [component addObject:[NSString stringWithFormat:@"%@", executableFile]];
    [component addObject:@"|"];
    [component addObject:@"grep __LLVM"];
    [component addObject:@"|"];
    [component addObject:@"wc -l"];
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchCodesignAuthorityCommand:(NSString *)appFile {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForCodesign];
    
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
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchLipoArchitecturesCommand:(NSString *)executableFile {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForLipo];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-info"];
    [component addObject:[NSString stringWithFormat:@"%@", executableFile]];
    [component addObject:@"|"];
    [component addObject:@"cut -d \\\":\\\" -f 3"];
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchCreateExportOptionsPlistCommand:(NSString *)exportOptionsPlistFile
                                                bundleId:(NSString *)bundleId
                                                  teamId:(NSString *)teamId
                                                 channel:(XAPChannel)channel
                                             profileName:(NSString *)profileName
                                           enableBitcode:(XAPXMLBoolean)enableBitcode
                                       stripSwiftSymbols:(XAPXMLBoolean)stripSwiftSymbols {
    XAPScriptModel *command = [[XAPScriptModel alloc] init];
    command.scriptPath = @"echo";
    
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
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchKeychainCertificatesCommand {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForSecurity];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"find-identity"];
    [component addObject:@"-v"];
    [component addObject:@"-p"];
    [component addObject:@"codesigning"];
    command.scriptArguments = [component copy];
    
    return command;
}

+ (XAPScriptModel *)fetchUnzipCommand:(NSString *)sourceFile
                     destinationFile:(NSString *)destinationFile {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForUnzip];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-o"];
    [component addObject:[NSString stringWithFormat:@"%@", sourceFile]];
    [component addObject:@"-d"];
    [component addObject:[NSString stringWithFormat:@"%@", destinationFile]];
    [component addObject:@" >/dev/null 2>&1"];
    command.scriptArguments = [component copy];
    return command;
}

+ (XAPScriptModel *)fetchRemovePathCommand:(NSString *)file {
    XAPScriptModel *command = [XAPScriptResposity scriptModelForRm];
    
    NSMutableArray *component = [NSMutableArray array];
    [component addObject:@"-rf"];
    [component addObject:[NSString stringWithFormat:@"%@", file]];
    command.scriptArguments = [component copy];
    return command;
}

@end
