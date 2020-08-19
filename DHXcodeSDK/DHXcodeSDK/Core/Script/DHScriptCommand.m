//
//  DHScriptCommand.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/18.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHScriptCommand.h"
#import "DHScriptModel.h"
#import "DHScriptFactory.h"
#import "DHScriptExecutor.h"

@implementation DHScriptCommand
// MARK: - script
/// 需要结果
+ (BOOL)executeScriptWithCommand:(DHScriptModel *)command
                          output:(NSString * _Nullable __autoreleasing * _Nullable)output
                           error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [DHScriptExecutor executeCommand:command
                                         output:output
                                          error:error];
    return ret;
}

/// 忽略output。error为执行错误，不是结果错误
+ (BOOL)executeScriptWithCommand:(DHScriptModel *)command
                           error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [DHScriptExecutor executeCommand:command
                                          error:error
                                   outputStream:^(NSString * _Nonnull output) {
        DHXcodePrintf(@"[output]: %@", output);
    }
                                    errorStream:^(NSString * _Nonnull outError) {
        DHXcodePrintf(@"[outerr]: %@", outError);
    }];
    return ret;
}

+ (void)interrupt {
    [DHScriptExecutor interrupt];
}


#pragma mark - private method
+ (NSString *)pbxprojFileWithXcodeprojFile:(NSString *)xcodeprojFile {
    if ([xcodeprojFile.pathExtension isEqualToString:@".pbxproj"]) {
        return xcodeprojFile;
    }
    return [xcodeprojFile stringByAppendingPathComponent:@"project.pbxproj"];
}


// MARK: - 编译项目相关
+ (BOOL)cleanProjectWithXcworkspaceOrXcodeprojFile:(NSString *)xcworkspaceOrXcodeprojFile
                                   engineeringType:(DHEngineeringType)engineeringType
                                        targetName:(NSString *)targetName
                                 configurationName:(DHConfigurationName)configurationName
                                             error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    DHScriptModel *command = [DHScriptFactory fetchXcodebuildEngineeringCleanCommand:xcworkspaceOrXcodeprojFile
                                                                     engineeringType:engineeringType
                                                                              scheme:targetName
                                                                       configuration:configurationName
                                                                             verbose:NO];
    BOOL ret = [self executeScriptWithCommand:command
                                        error:error];
    return ret;
}

+ (BOOL)archiveProjectWithXcworkspaceOrXcodeprojFile:(NSString *)xcworkspaceOrXcodeprojFile
                                     engineeringType:(DHEngineeringType)engineeringType
                                          targetName:(NSString *)targetName
                                   configurationName:(DHConfigurationName)configurationName
                                       xcarchiveFile:(NSString *)xcarchiveFile
                                               error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    DHScriptModel *command = [DHScriptFactory fetchXcodebuildEngineeringArchiveCommand:xcworkspaceOrXcodeprojFile
                                                                       engineeringType:engineeringType
                                                                                scheme:targetName
                                                                         configuration:configurationName
                                                                           archivePath:xcarchiveFile
                                                                          architecture:nil
                                                                              xcconfig:nil
                                                                               verbose:NO];
    BOOL ret = [self executeScriptWithCommand:command
                                        error:error];
    return ret;
}

+ (BOOL)exportProjectIPAFileWithXcarchiveFile:(NSString *)xcarchiveFile
                           exportIPADirectory:(NSString *)exportIPADirectory
                           exportOptionsPlist:(NSString *)exportOptionsPlist
                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    DHScriptModel *command = [DHScriptFactory fetchXcodebuildExportArchiveCommand:xcarchiveFile
                                                               exportIPADirectory:exportIPADirectory
                                                               exportOptionsPlist:exportOptionsPlist
                                                                          verbose:NO];
    BOOL ret = [self executeScriptWithCommand:command
                                        error:error];
    return ret;
}

+ (BOOL)createExportOptionsPlistFile:(NSString *)exportOptionsPlistFile
                        withBundleId:(NSString *)bundleId
                              teamId:(NSString *)teamId
                             channel:(DHChannel)channel
                         profileName:(NSString *)profileName
                       enableBitcode:(DHEnableBitcode)enableBitcode
                               error:(NSError * _Nullable __autoreleasing *)error {
    // 转化xml的bool值
    DHXMLBoolean enableBitcodeBoolean = [enableBitcode isEqualToString:kDHEnableBitcodeYES]?kDHXMLBooleanTrue:kDHXMLBooleanFalse;
    DHXMLBoolean stripSwiftSymbolsBoolean = kDHXMLBooleanTrue;
    
    DHScriptModel *command = [DHScriptFactory fetchCreateExportOptionsPlistCommand:exportOptionsPlistFile
                                                                          bundleId:bundleId
                                                                            teamId:teamId
                                                                           channel:channel
                                                                       profileName:profileName
                                                                     enableBitcode:enableBitcodeBoolean
                                                                 stripSwiftSymbols:stripSwiftSymbolsBoolean];
    BOOL ret = [self executeScriptWithCommand:command
                                       output:nil
                                        error:error];
    return ret;
}

/// 导出
+ (BOOL)exportProjectIPAFileWithXcarchiveFile:(NSString *)xcarchiveFile
                           exportIPADirectory:(NSString *)exportIPADirectory
               createExportOptionsPlistAtPath:(NSString *)exportOptionsPlist
                                     bundleId:(NSString *)bundleId
                                       teamId:(NSString *)teamId
                                      channel:(DHChannel)channel
                                  profileName:(NSString *)profileName
                                enableBitcode:(DHEnableBitcode)enableBitcode
                                        error:(NSError **)error {
    // 临时路径，用完即删
    if (!exportOptionsPlist) {
        exportOptionsPlist = [[xcarchiveFile stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"XAP_exportOptions.plist"];
    }
    
    BOOL ret = NO;
    // 创建exportOptions.plist文件
    ret = [self createExportOptionsPlistFile:exportOptionsPlist
                                withBundleId:bundleId
                                      teamId:teamId
                                     channel:channel
                                 profileName:profileName
                               enableBitcode:enableBitcode
                                       error:error];
    if (!ret) { return ret; }
    
    // 导出ipa文件
    ret = [DHScriptCommand exportProjectIPAFileWithXcarchiveFile:xcarchiveFile
                                              exportIPADirectory:exportIPADirectory
                                              exportOptionsPlist:exportOptionsPlist
                                                           error:error];
    // 执行完毕就可将配置文件删除
    [[NSFileManager defaultManager] removeItemAtPath:exportOptionsPlist error:error];
    
    return ret;
}


// MARK: - project相关
+ (BOOL)fetchProjectTargetIdListWithXcodeprojFile:(NSString *)xcodeprojFile
                                           output:(NSArray * _Nullable __autoreleasing * _Nullable)output
                                            error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    DHScriptModel *command = nil;
    BOOL ret = NO;
    NSString *outString = nil;
    NSString *pbxprojFile = [self pbxprojFileWithXcodeprojFile:xcodeprojFile];
    
    // 获取rootObject
    command = [DHScriptFactory fetchPBXProjRootObjectCommand:pbxprojFile];
    ret = [self executeScriptWithCommand:command
                                  output:&outString
                                   error:error];
    if (!ret) { return NO; }
    
    // 获取TargetIdList，此时的oput是rootObject
    command = [DHScriptFactory fetchPBXProjTargetIdListCommand:pbxprojFile
                                                    rootObject:outString];
    ret = [self executeScriptWithCommand:command
                                  output:&outString
                                   error:error];
    if (!ret) { return NO; }
    
    NSArray *targetIdList = [outString componentsSeparatedByString:@"\r"];
    if (output) { *output = targetIdList; }
    
    return ret;
}

+ (BOOL)fetchProjectTargetNameWithXcodeprojFile:(NSString *)xcodeprojFile
                                       targetId:(NSString *)targetId
                                         output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSString *pbxprojFile = [self pbxprojFileWithXcodeprojFile:xcodeprojFile];
    DHScriptModel *command = [DHScriptFactory fetchPBXProjTargetNameCommand:pbxprojFile
                                                                   targetId:targetId];
    BOOL ret = [self executeScriptWithCommand:command
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)fetchProjectBuildConfigurationIdListWithXcodeprojFile:(NSString *)xcodeprojFile
                                                     targetId:(NSString *)targetId
                                                       output:(NSArray * _Nullable __autoreleasing * _Nullable)output
                                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    DHScriptModel *command = nil;
    BOOL ret = NO;
    NSString *outString = nil;
    NSString *pbxprojFile = [self pbxprojFileWithXcodeprojFile:xcodeprojFile];
    
    // 获取configurationListId=>用于查找debug/release的两个配置id
    command = [DHScriptFactory fetchPBXProjBuildConfigureListIdCommand:pbxprojFile
                                                              targetId:targetId];
    ret = [self executeScriptWithCommand:command
                                  output:&outString
                                   error:error];
    if (!ret) { return NO; }
    
    // 获取configurationIdList
    command = [DHScriptFactory fetchPBXProjBuildConfigureIdListCommand:pbxprojFile
                                                  buildConfigureListId:outString];
    ret = [self executeScriptWithCommand:command
                                  output:&outString
                                   error:error];
    if (!ret) { return NO; }
    
    NSArray *configurationIdList = [outString componentsSeparatedByString:@"\r"];
    if (output) { *output = configurationIdList; }
    
    return ret;
}

+ (BOOL)fetchProjectBuildConfigurationNameWithXcodeprojFile:(NSString *)xcodeprojFile
                                       buildConfigurationId:(NSString *)buildConfigurationId
                                                     output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                                      error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSString *pbxprojFile = [self pbxprojFileWithXcodeprojFile:xcodeprojFile];
    DHScriptModel *command = [DHScriptFactory fetchPBXProjBuildConfigureNameCommand:pbxprojFile
                                                                   buildConfigureId:buildConfigurationId];
    BOOL ret = [self executeScriptWithCommand:command
                                       output:output
                                        error:error];
    return ret;
}


+ (BOOL)fetchProjectProductNameWithXcodeprojFile:(NSString *)xcodeprojFile
                            buildConfigurationId:(NSString *)buildConfigurationId
                                          output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                           error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSString *pbxprojFile = [self pbxprojFileWithXcodeprojFile:xcodeprojFile];
    DHScriptModel *command = [DHScriptFactory fetchPBXProjProductNameCommand:pbxprojFile
                                                            buildConfigureId:buildConfigurationId];
    BOOL ret = [self executeScriptWithCommand:command
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)fetchProjectBundleIdentifierWithXcodeprojFile:(NSString *)xcodeprojFile
                                 buildConfigurationId:(NSString *)buildConfigurationId
                                               output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                                error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSString *pbxprojFile = [self pbxprojFileWithXcodeprojFile:xcodeprojFile];
    DHScriptModel *command = [DHScriptFactory fetchPBXProjBundleIdentifierCommand:pbxprojFile
                                                                 buildConfigureId:buildConfigurationId];
    BOOL ret = [self executeScriptWithCommand:command
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)fetchProjectEnableBitcodeWithXcodeprojFile:(NSString *)xcodeprojFile
                              buildConfigurationId:(NSString *)buildConfigurationId
                                            output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                             error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSString *pbxprojFile = [self pbxprojFileWithXcodeprojFile:xcodeprojFile];
    DHScriptModel *command = [DHScriptFactory fetchPBXProjEnableBitcodeCommand:pbxprojFile
                                                              buildConfigureId:buildConfigurationId];
    BOOL ret = [self executeScriptWithCommand:command
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)fetchProjectShortVersionWithXcodeprojFile:(NSString *)xcodeprojFile
                             buildConfigurationId:(NSString *)buildConfigurationId
                                           output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                            error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSString *pbxprojFile = [self pbxprojFileWithXcodeprojFile:xcodeprojFile];
    DHScriptModel *command = [DHScriptFactory fetchPBXProjShortVersionCommand:pbxprojFile
                                                             buildConfigureId:buildConfigurationId];
    BOOL ret = [self executeScriptWithCommand:command
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)fetchProjectBuildVersionWithXcodeprojFile:(NSString *)xcodeprojFile
                             buildConfigurationId:(NSString *)buildConfigurationId
                                           output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                            error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSString *pbxprojFile = [self pbxprojFileWithXcodeprojFile:xcodeprojFile];
    DHScriptModel *command = [DHScriptFactory fetchPBXProjBuildVersionCommand:pbxprojFile
                                                             buildConfigureId:buildConfigurationId];
    BOOL ret = [self executeScriptWithCommand:command
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)fetchProjectTeamIdentifierWithXcodeprojFile:(NSString *)xcodeprojFile
                               buildConfigurationId:(NSString *)buildConfigurationId
                                             output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSString *pbxprojFile = [self pbxprojFileWithXcodeprojFile:xcodeprojFile];
    DHScriptModel *command = [DHScriptFactory fetchPBXProjTeamIdentifierCommand:pbxprojFile
                                                               buildConfigureId:buildConfigurationId];
    BOOL ret = [self executeScriptWithCommand:command
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)fetchProjectInfoPlistFileWithXcodeprojFile:(NSString *)xcodeprojFile
                            buildConfigurationId:(NSString *)buildConfigurationId
                                          output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                           error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSString *pbxprojFile = [self pbxprojFileWithXcodeprojFile:xcodeprojFile];
    // 获取plist路径
    DHScriptModel *command = [DHScriptFactory fetchPBXProjInfoPlistFileCommand:pbxprojFile
                                                              buildConfigureId:buildConfigurationId];
    BOOL ret = [self executeScriptWithCommand:command
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)fetchProjectBuildSettingsValueWithXcodeprojFile:(NSString *)xcodeprojFile
                                 buildConfigurationId:(NSString *)buildConfigurationId
                                     buildSettingsKey:(NSString *)buildSettingsKey
                                               output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                                error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSString *pbxprojFile = [self pbxprojFileWithXcodeprojFile:xcodeprojFile];
    // 获取指定设置
    DHScriptModel *command = [DHScriptFactory fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                                               buildConfigurationId:buildConfigurationId
                                                                   buildSettingsKey:buildSettingsKey];
    BOOL ret = [self executeScriptWithCommand:command
                                       output:output
                                        error:error];
    return ret;
}


// MARK: - profile相关
+ (BOOL)fetchProfileCreateTimestampWithProfile:(NSString *)profile
                                        output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    DHScriptModel *command = nil;
    BOOL ret = NO;
    NSString *outString = nil;
    
    // 获取CreateTime
    command = [DHScriptFactory fetchProfileCreateTimeCommand:profile];
    ret = [self executeScriptWithCommand:command
                                  output:&outString
                                   error:error];
    if (!ret) { return NO; }
    // 时间转化时间戳
    command = [DHScriptFactory fetchTimestampCommand:outString];
    ret = [self executeScriptWithCommand:command
                                  output:&outString
                                   error:error];
    if (!ret) { return NO; }
    if (output) { *output = outString; }
    
    return ret;
}

+ (BOOL)fetchProfileExpireTimestampWithProfile:(NSString *)profile
                                        output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    DHScriptModel *command = nil;
    BOOL ret = NO;
    NSString *oput = nil;
    
    // 获取ExpireTime
    command = [DHScriptFactory fetchProfileExpireTimeCommand:profile];
    ret = [self executeScriptWithCommand:command
                                  output:&oput
                                   error:error];
    if (!ret) { return NO; }
    // 时间转化时间戳
    command = [DHScriptFactory fetchTimestampCommand:oput];
    ret = [self executeScriptWithCommand:command
                                  output:&oput
                                   error:error];
    if (!ret) { return NO; }
    if (output) { *output = oput; }
    
    return ret;
}

+ (BOOL)fetchProfileNameWithProfile:(NSString *)profile
                             output:(NSString * _Nullable __autoreleasing * _Nullable)output
                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchProfileNameCommand:profile]
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)fetchProfileAppIdentifierWithProfile:(NSString *)profile
                                      output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                       error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchProfileAppIdentifierCommand:profile]
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)fetchProfileBundleIdentifierWithProfile:(NSString *)profile
                                         output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    DHScriptModel *command = nil;
    BOOL ret = NO;
    NSString *appId = nil;
    NSString *teamId = nil;
    
    // 获取appId
    command = [DHScriptFactory fetchProfileAppIdentifierCommand:profile];
    ret = [self executeScriptWithCommand:command
                                  output:output
                                   error:error];
    if (!ret) { return NO; }
    appId = *output;
    
    // 获取team id
    command = [DHScriptFactory fetchProfileTeamIdentifierCommand:profile];
    ret = [self executeScriptWithCommand:command
                                  output:output
                                   error:error];
    if (!ret) { return NO; }
    teamId = *output;
    
    // 拆分
    // 理论上格式是 appid: <teamid>.<bundleid>
    if (appId.length > (teamId.length+1)) {
        *output = [appId substringFromIndex:teamId.length+1];
        return ret;
    }
    // 理论上不可能执行到此处，以防万一
    // 以 . 分割排除第一项
    NSArray *components = [appId componentsSeparatedByString:@"."];
    if (components.count > 2) {
        *output = [[components subarrayWithRange:NSMakeRange(1, components.count-1)] componentsJoinedByString:@"."];
    } else {
        *output = appId;
    }
    
    return ret;
}

+ (BOOL)fetchProfileTeamIdentifierWithProfile:(NSString *)profile
                                       output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchProfileTeamIdentifierCommand:profile]
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)fetchProfileTeamNameWithProfile:(NSString *)profile
                                 output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchProfileTeamNameCommand:profile]
                                          output:output
                                           error:error];
    return ret;
}

+ (BOOL)fetchProfileUUIDWithProfile:(NSString *)profile
                             output:(NSString * _Nullable __autoreleasing * _Nullable)output
                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchProfileUUIDCommand:profile]
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)fetchProfileChannelWithProfile:(NSString *)profile
                              output:(DHChannel *)output
                               error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    DHScriptModel *command = nil;
    BOOL ret = NO;
    NSString *outString = nil;
    
    // 判别channel类型
    // Development: ProvisionedDevices存在 且 get-task-allow为true
    // Ad-Hoc: ProvisionedDevices存在 且 get-task-allow为false
    // Enterprise: ProvisionedDevices不存在 且 ProvisionsAllDevices存在且为true
    // AppStore: ProvisionedDevices不存在 且 ProvisionsAllDevices存在且为false
    //          或 ProvisionedDevices与ProvisionsAllDevices都不存在
    
    command = [DHScriptFactory fetchProfileIsProvisionedDevicesExistedCommand:profile];
    ret = [self executeScriptWithCommand:command
                                  output:&outString
                                   error:error];
    if (!ret) { *output = kDHChannelUnknown; return NO; }
    
    if (outString) {
        command = [DHScriptFactory fetchProfileGetTaskAllowCommand:profile];
        ret = [self executeScriptWithCommand:command
                                         output:&outString
                                          error:error];
        if (!ret) { *output = kDHChannelUnknown; return NO; }
        
        if ([outString isEqualToString:@"true"]) {
            *output = kDHChannelDevelopment;
        } else {
            *output = kDHChannelAdHoc;
        }
        return YES;
    }
    
    command = [DHScriptFactory fetchProfileIsProvisionedAllDevicesExistedCommand:profile];
    ret = [self executeScriptWithCommand:command
                                  output:&outString
                                   error:error];
    if (!ret) { *output = kDHChannelUnknown; return NO; }
    
    if (outString) {
        command = [DHScriptFactory fetchProfileProvisionedAllDevicesCommand:profile];
        ret = [self executeScriptWithCommand:command
                                        output:&outString
                                         error:error];
        
        if (!ret) { *output = kDHChannelUnknown; return NO; }
        
        if ([outString isEqualToString:@"true"]) {
            *output = kDHChannelEnterprise;
        } else {
            *output = kDHChannelAppStore;
        }
        return YES;
    }
    
    *output = kDHChannelAppStore;
    return YES;
}


// MARK: - git相关
+ (BOOL)gitCurrentBranchWithGitDirectory:(NSString *)gitDirectory
                                  output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                   error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchGitCurrentBranchCommand:gitDirectory]
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)gitStatusWithGitDirectory:(NSString *)gitDirectory
                           output:(NSString * _Nullable __autoreleasing * _Nullable)output
                            error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchGitStatusCommand:gitDirectory]
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)gitAddAllWithGitDirectory:(NSString *)gitDirectory
                           output:(NSString * _Nullable __autoreleasing * _Nullable)output
                            error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchGitAddAllCommand:gitDirectory]
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)gitStashWithGitDirectory:(NSString *)gitDirectory
                          output:(NSString * _Nullable __autoreleasing * _Nullable)output
                           error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchGitStashCommand:gitDirectory]
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)gitResetToHeadWithGitDirectory:(NSString *)gitDirectory
                                output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchGitResetToHeadCommand:gitDirectory]
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)gitPullWithGitDirectory:(NSString *)gitDirectory
                         output:(NSString * _Nullable __autoreleasing * _Nullable)output
                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchGitPullCommand:gitDirectory]
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)gitCheckoutBranchWithGitDirectory:(NSString *)gitDirectory
                               branchName:(NSString *)branchName
                                   output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchGitCheckoutBranchCommand:gitDirectory branchName:branchName]
                                          output:output
                                           error:error];
    return ret;
}

+ (BOOL)fetchGitBranchListWithGitDirectory:(NSString *)gitDirectory
                                    output:(NSArray * _Nullable __autoreleasing * _Nullable)output
                                     error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = NO;
    NSString *outString = nil;
    
    // 获取branch list
    ret = [self executeScriptWithCommand:[DHScriptFactory fetchGitBranchListCommand:gitDirectory]
                                  output:&outString
                                   error:error];
    if (!ret) { return NO; }
    
    NSArray *branchNameList = [outString componentsSeparatedByString:@"\r"];
    if (output) { *output = branchNameList; }
    
    return ret;
}

+ (BOOL)fetchGitTagListWithGitDirectory:(NSString *)gitDirectory
                                 output:(NSArray * _Nullable __autoreleasing * _Nullable)output
                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = NO;
    NSString *outString = nil;
    
    // 获取tag list
    ret = [self executeScriptWithCommand:[DHScriptFactory fetchGitTagListCommand:gitDirectory]
                                  output:&outString
                                   error:error];
    if (!ret) { return NO; }
    
    NSArray *tagList = [outString componentsSeparatedByString:@"\r"];
    if (output) { *output = tagList; }
    
    return ret;
}


// MARK: - pod相关
+ (BOOL)podInstallWithPodfileDirectory:(NSString *)podfileDirectory
                                output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchPodInstallCommand:podfileDirectory]
                                       output:output
                                        error:error];
    return ret;
}


// MARK: - info.plist相关
+ (BOOL)fetchInfoPlistProductNameWithInfoPlist:(NSString *)infoPlist
                                output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchPlistProductNameCommand:infoPlist]
                                       output:output
                                        error:error];
    return ret;
}
+ (BOOL)fetchInfoPlistDisplayNameWithInfoPlist:(NSString *)infoPlist
                                output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchPlistDisplayNameCommand:infoPlist]
                                       output:output
                                        error:error];
    return ret;
}
+ (BOOL)fetchInfoPlistBundleIdentifierWithInfoPlist:(NSString *)infoPlist
                                             output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchPlistBundleIdentifierCommand:infoPlist]
                                       output:output
                                        error:error];
    return ret;
}
+ (BOOL)fetchInfoPlistShortVersionWithInfoPlist:(NSString *)infoPlist
                                         output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchPlistShortVersionCommand:infoPlist]
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)fetchInfoPlistBuildVersionWithInfoPlist:(NSString *)infoPlist
                                 output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchPlistBuildVersionCommand:infoPlist]
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)fetchInfoPlistExecutableFileWithInfoPlist:(NSString *)infoPlist
                                           output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                            error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchPlistExecutableFileCommand:infoPlist]
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)fetchInfoPlistMinimumOSVersionWithInfoPlist:(NSString *)infoPlist
                                             output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchPlistMinimumOSVersionCommand:infoPlist]
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)plistFetchAttributeWithInfoPlist:(NSString *)infoPlist
                            attributeKey:(NSString *)attributeKey
                                  output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                   error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchPlistAttibuteCommand:infoPlist
                                                                           attributeName:attributeKey]
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)plistAppendAttributeWithInfoPlist:(NSString *)infoPlist
                             attributeKey:(NSString *)attributeKey
                           attributeValue:(NSString *)attributeValue
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchPlistAddAttibuteCommand:infoPlist
                                                                              attributeName:attributeKey
                                                                             attributeValue:attributeValue]
                                          output:nil
                                           error:error];
    return ret;
}

+ (BOOL)plistDeleteAttributeWithInfoPlist:(NSString *)infoPlist
                             attributeKey:(NSString *)attributeKey
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchPlistDelAttibuteCommand:infoPlist
                                                                              attributeName:attributeKey]
                                          output:nil
                                           error:error];
    return ret;
}

+ (BOOL)plistModifyAttributeWithInfoPlist:(NSString *)infoPlist
                             attributeKey:(NSString *)attributeKey
                           attributeValue:(NSString *)attributeValue
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchPlistSetAttibuteCommand:infoPlist
                                                                              attributeName:attributeKey
                                                                             attributeValue:attributeValue]
                                          output:nil
                                           error:error];
    return ret;
}


#pragma mark - app相关
+ (BOOL)fetchAppEnableBitcodeWithExecutableFile:(NSString *)executableFile
                                         output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchOtoolEnableBitcodeCommand:executableFile]
                                       output:output
                                        error:error];
    if (!ret) { return NO; }
    // 0: NO; 其他: YES
    NSString *enableBitcodeIntegerString = *output;
    enableBitcodeIntegerString = [enableBitcodeIntegerString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([enableBitcodeIntegerString isEqualToString:@"0"]) {
        *output = kDHEnableBitcodeNO;
    } else {
        *output = kDHEnableBitcodeYES;
    }
    
    return ret;
}

+ (BOOL)fetchAppCodesignIdentifierWithAppFile:(NSString *)appFile
                                       output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchCodesignAuthorityCommand:appFile]
                                       output:output
                                        error:error];
    return ret;
}

+ (BOOL)fetchAppArchitecturesWithExecutableFile:(NSString *)executableFile
                                         output:(NSString * _Nullable __autoreleasing * _Nullable)output
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[DHScriptFactory fetchLipoArchitecturesCommand:executableFile]
                                       output:output
                                        error:error];
    return ret;
}



@end
