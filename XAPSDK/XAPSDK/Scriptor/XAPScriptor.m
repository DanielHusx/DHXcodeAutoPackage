//
//  XAPScriptor.m
//  XAPSDK
//
//  Created by Daniel on 2020/11/30.
//

#import "XAPScriptor.h"
#import "XAPScriptModel.h"
#import "XAPScriptResposity.h"
#import "XAPScriptExecutor.h"

@interface XAPScriptor () <XAPScriptExecutorDelegate>

@end

@implementation XAPScriptor

#pragma mark - inialization
+ (instancetype)sharedInstance {
    static XAPScriptor *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XAPScriptor alloc] init];
        [XAPScriptExecutor sharedExecutor].delegate = _instance;
    });
    return _instance;
}

#pragma mark - XAPScriptExecutorDelegate
- (void)executor:(XAPScriptExecutor *)executor errorStream:(id)errorStream {
    // TODO: feedback
}

- (void)executor:(XAPScriptExecutor *)executor outputStream:(id)outputStream {
    // TODO: feedback
}


// MARK: - script
/// 需要结果
- (id)executeScriptWithCommand:(XAPScriptModel *)command
                         error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    id result = [[XAPScriptExecutor sharedExecutor] execute:command error:error];
    return result;
}

- (void)interrupt {
    [[XAPScriptExecutor sharedExecutor] interrupt];
}


#pragma mark - private method
+ (NSString *)pbxprojFileWithXcodeprojFile:(NSString *)xcodeprojFile {
    if ([xcodeprojFile.pathExtension isEqualToString:@".pbxproj"]) {
        return xcodeprojFile;
    }
    return [xcodeprojFile stringByAppendingPathComponent:@"project.pbxproj"];
}


// MARK: - 编译项目相关
- (void)cleanProjectWithXcworkspaceOrXcodeprojFile:(NSString *)xcworkspaceOrXcodeprojFile
                                   engineeringType:(XAPEngineeringType)engineeringType
                                        targetName:(NSString *)targetName
                                 configurationName:(XAPConfigurationName)configurationName
                                           verbose:(BOOL)verbose
                                             error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchXcodebuildEngineeringCleanCommand:xcworkspaceOrXcodeprojFile
                                                                         engineeringType:engineeringType
                                                                                  scheme:targetName
                                                                           configuration:configurationName
                                                                                 verbose:verbose];
    [self executeScriptWithCommand:command error:error];
}

- (void)archiveProjectWithXcworkspaceOrXcodeprojFile:(NSString *)xcworkspaceOrXcodeprojFile
                                     engineeringType:(XAPEngineeringType)engineeringType
                                          targetName:(NSString *)targetName
                                   configurationName:(XAPConfigurationName)configurationName
                                       xcarchiveFile:(NSString *)xcarchiveFile
                                        architecture:(NSString * _Nullable)architecture
                                            xcconfig:(NSString * _Nullable)xcconfig
                                             verbose:(BOOL)verbose
                                               error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchXcodebuildEngineeringArchiveCommand:xcworkspaceOrXcodeprojFile
                                                                           engineeringType:engineeringType
                                                                                    scheme:targetName
                                                                             configuration:configurationName
                                                                               archivePath:xcarchiveFile
                                                                              architecture:architecture
                                                                                  xcconfig:xcconfig
                                                                                   verbose:verbose];
    [self executeScriptWithCommand:command error:error];
}

- (void)exportProjectIPAFileWithXcarchiveFile:(NSString *)xcarchiveFile
                           exportIPADirectory:(NSString *)exportIPADirectory
                           exportOptionsPlist:(NSString *)exportOptionsPlist
                                      verbose:(BOOL)verbose
                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchXcodebuildExportArchiveCommand:xcarchiveFile
                                                                   exportIPADirectory:exportIPADirectory
                                                                   exportOptionsPlist:exportOptionsPlist
                                                                              verbose:verbose];
    [self executeScriptWithCommand:command error:error];
}

- (void)createExportOptionsPlistFile:(NSString *)exportOptionsPlistFile
                        withBundleId:(NSString *)bundleId
                              teamId:(NSString *)teamId
                             channel:(XAPChannel)channel
                         profileName:(NSString *)profileName
                       enableBitcode:(XAPEnableBitcode)enableBitcode
                               error:(NSError * _Nullable __autoreleasing *)error {
    // 转化xml的bool值
    XAPXMLBoolean enableBitcodeBoolean = [enableBitcode isEqualToString:kXAPEnableBitcodeYES]?kXAPXMLBooleanTrue:kXAPXMLBooleanFalse;
    XAPXMLBoolean stripSwiftSymbolsBoolean = kXAPXMLBooleanTrue;
    
    XAPScriptModel *command = [XAPScriptResposity fetchCreateExportOptionsPlistCommand:exportOptionsPlistFile
                                                                              bundleId:bundleId
                                                                                teamId:teamId
                                                                               channel:channel
                                                                           profileName:profileName
                                                                         enableBitcode:enableBitcodeBoolean
                                                                     stripSwiftSymbols:stripSwiftSymbolsBoolean];
    [self executeScriptWithCommand:command error:error];
}

/// 导出
- (void)exportProjectIPAFileWithXcarchiveFile:(NSString *)xcarchiveFile
                           exportIPADirectory:(NSString *)exportIPADirectory
               createExportOptionsPlistAtPath:(NSString *)exportOptionsPlist
                                     bundleId:(NSString *)bundleId
                                       teamId:(NSString *)teamId
                                      channel:(XAPChannel)channel
                                  profileName:(NSString *)profileName
                                enableBitcode:(XAPEnableBitcode)enableBitcode
                                      verbose:(BOOL)verbose
                                        error:(NSError **)error {
    // 临时路径，用完即删
    if (!exportOptionsPlist) {
        exportOptionsPlist = [[xcarchiveFile stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"XAP_exportOptions.plist"];
    }
    
    // 创建exportOptions.plist文件
    [self createExportOptionsPlistFile:exportOptionsPlist
                          withBundleId:bundleId
                                teamId:teamId
                               channel:channel
                           profileName:profileName
                         enableBitcode:enableBitcode
                                 error:error];
    if (*error) { return ; }
    
    // 导出ipa文件
    [self exportProjectIPAFileWithXcarchiveFile:xcarchiveFile
                             exportIPADirectory:exportIPADirectory
                             exportOptionsPlist:exportOptionsPlist
                                        verbose:verbose
                                          error:error];
    // 执行完毕就可将配置文件删除
    [[NSFileManager defaultManager] removeItemAtPath:exportOptionsPlist error:nil];
}


// MARK: - project相关
- (NSArray * _Nullable)fetchProjectTargetIdListWithPBXProjFile:(NSString *)pbxprojFile
                                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = nil;
    NSString *output = nil;
    
    // 获取rootObject
    command = [XAPScriptResposity fetchPBXProjRootObjectCommand:pbxprojFile];
    output = [self executeScriptWithCommand:command
                                      error:error];
    if (*error) { return nil; }
    
    // 获取TargetIdList，此时的output是rootObject值
    command = [XAPScriptResposity fetchPBXProjTargetIdListCommand:pbxprojFile
                                                       rootObject:output];
    output = [self executeScriptWithCommand:command
                                      error:error];
    if (*error) { return nil; }
    
    NSArray *targetIdList = [output componentsSeparatedByString:@"\r"];
    return targetIdList;
}

- (NSString * _Nullable)fetchProjectTargetNameWithPBXProjFile:(NSString *)pbxprojFile
                                           targetId:(NSString *)targetId
                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPBXProjTargetNameCommand:pbxprojFile
                                                                       targetId:targetId];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSArray * _Nullable)fetchProjectBuildConfigurationIdListWithPBXProjFile:(NSString *)pbxprojFile
                                                                  targetId:(NSString *)targetId
                                                                     error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = nil;
    NSString *output = nil;
    
    // 获取configurationListId=>用于查找debug/release的两个配置id
    command = [XAPScriptResposity fetchPBXProjBuildConfigureListIdCommand:pbxprojFile
                                                                 targetId:targetId];
    output = [self executeScriptWithCommand:command
                                      error:error];
    if (*error) { return nil; }
    
    // 获取configurationIdList
    command = [XAPScriptResposity fetchPBXProjBuildConfigureIdListCommand:pbxprojFile
                                                     buildConfigureListId:output];
    output = [self executeScriptWithCommand:command
                                      error:error];
    if (*error) { return nil; }
    
    NSArray *configurationIdList = [output componentsSeparatedByString:@"\r"];
    return configurationIdList;
}

- (NSString * _Nullable)fetchProjectBuildConfigurationNameWithPBXProjFile:(NSString *)pbxprojFile
                                                     buildConfigurationId:(NSString *)buildConfigurationId
                                                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPBXProjBuildConfigureNameCommand:pbxprojFile
                                                                   buildConfigureId:buildConfigurationId];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}


- (NSString * _Nullable)fetchProjectProductNameWithPBXProjFile:(NSString *)pbxprojFile
                                          buildConfigurationId:(NSString *)buildConfigurationId
                                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPBXProjProductNameCommand:pbxprojFile
                                                            buildConfigureId:buildConfigurationId];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)fetchProjectBundleIdentifierWithPBXProjFile:(NSString *)pbxprojFile
                                               buildConfigurationId:(NSString *)buildConfigurationId
                                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPBXProjBundleIdentifierCommand:pbxprojFile
                                                                     buildConfigureId:buildConfigurationId];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)fetchProjectEnableBitcodeWithPBXProjFile:(NSString *)pbxprojFile
                                            buildConfigurationId:(NSString *)buildConfigurationId
                                                           error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPBXProjEnableBitcodeCommand:pbxprojFile
                                                                  buildConfigureId:buildConfigurationId];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)fetchProjectShortVersionWithPBXProjFile:(NSString *)pbxprojFile
                                           buildConfigurationId:(NSString *)buildConfigurationId
                                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPBXProjShortVersionCommand:pbxprojFile
                                                                 buildConfigureId:buildConfigurationId];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)fetchProjectVersionWithPBXProjFile:(NSString *)pbxprojFile
                                      buildConfigurationId:(NSString *)buildConfigurationId
                                            error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPBXProjVersionCommand:pbxprojFile
                                                            buildConfigureId:buildConfigurationId];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)fetchProjectTeamIdentifierWithPBXProjFile:(NSString *)pbxprojFile
                                             buildConfigurationId:(NSString *)buildConfigurationId
                                                            error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPBXProjTeamIdentifierCommand:pbxprojFile
                                                                   buildConfigureId:buildConfigurationId];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)fetchProjectInfoPlistFileWithPBXProjFile:(NSString *)pbxprojFile
                                            buildConfigurationId:(NSString *)buildConfigurationId
                                                           error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    // 获取plist路径
    XAPScriptModel *command = [XAPScriptResposity fetchPBXProjInfoPlistFileCommand:pbxprojFile
                                                                  buildConfigureId:buildConfigurationId];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)fetchProjectBuildSettingsValueWithPBXProjFile:(NSString *)pbxprojFile
                                                 buildConfigurationId:(NSString *)buildConfigurationId
                                                     buildSettingsKey:(NSString *)buildSettingsKey
                                                                error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    // 获取指定设置
    XAPScriptModel *command = [XAPScriptResposity fetchPBXProjBuildSettingsValueCommand:pbxprojFile
                                                                   buildConfigurationId:buildConfigurationId
                                                                       buildSettingsKey:buildSettingsKey];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}


// MARK: - profile相关
- (NSString * _Nullable)fetchProfileCreateTimestampWithProfile:(NSString *)profile
                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = nil;
    NSString *output = nil;
    
    // 获取CreateTime
    command = [XAPScriptResposity fetchProfileCreateTimeCommand:profile];
    output = [self executeScriptWithCommand:command
                                      error:error];
    if (*error) { return nil; }
    // 时间转化时间戳
    command = [XAPScriptResposity fetchTimestampCommand:output];
    output = [self executeScriptWithCommand:command
                                      error:error];
    if (*error) { return nil; }
    
    return output;
}

- (BOOL)fetchProfileExpireTimestampWithProfile:(NSString *)profile
                                        
                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = nil;
    BOOL ret = NO;
    NSString *oput = nil;
    
    // 获取ExpireTime
    command = [XAPScriptResposity fetchProfileExpireTimeCommand:profile];
    ret = [self executeScriptWithCommand:command
                                  output:&oput
                                   error:error];
    if (!ret) { return NO; }
    // 时间转化时间戳
    command = [XAPScriptResposity fetchTimestampCommand:oput];
    ret = [self executeScriptWithCommand:command
                                  output:&oput
                                   error:error];
    if (!ret) { return NO; }
    if (output) { *output = oput; }
    
    return ret;
}

- (BOOL)fetchProfileNameWithProfile:(NSString *)profile
                             
                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchProfileNameCommand:profile]
                                       output:output
                                        error:error];
    return ret;
}

- (BOOL)fetchProfileAppIdentifierWithProfile:(NSString *)profile
                                      
                                       error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchProfileAppIdentifierCommand:profile]
                                       output:output
                                        error:error];
    return ret;
}

- (BOOL)fetchProfileBundleIdentifierWithProfile:(NSString *)profile
                                         
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = nil;
    BOOL ret = NO;
    NSString *appId = nil;
    NSString *teamId = nil;
    
    // 获取appId
    command = [XAPScriptResposity fetchProfileAppIdentifierCommand:profile];
    ret = [self executeScriptWithCommand:command
                                  output:output
                                   error:error];
    if (!ret) { return NO; }
    appId = *output;
    
    // 获取team id
    command = [XAPScriptResposity fetchProfileTeamIdentifierCommand:profile];
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

- (BOOL)fetchProfileTeamIdentifierWithProfile:(NSString *)profile
                                       
                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchProfileTeamIdentifierCommand:profile]
                                       output:output
                                        error:error];
    return ret;
}

- (BOOL)fetchProfileTeamNameWithProfile:(NSString *)profile
                                 
                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchProfileTeamNameCommand:profile]
                                          output:output
                                           error:error];
    return ret;
}

- (BOOL)fetchProfileUUIDWithProfile:(NSString *)profile
                             
                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchProfileUUIDCommand:profile]
                                       output:output
                                        error:error];
    return ret;
}

- (BOOL)fetchProfileChannelWithProfile:(NSString *)profile
                              output:(XAPChannel *)output
                               error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = nil;
    BOOL ret = NO;
    NSString *output = nil;
    
    // 判别channel类型
    // Development: ProvisionedDevices存在 且 get-task-allow为true
    // Ad-Hoc: ProvisionedDevices存在 且 get-task-allow为false
    // Enterprise: ProvisionedDevices不存在 且 ProvisionsAllDevices存在且为true
    // AppStore: ProvisionedDevices不存在 且 ProvisionsAllDevices存在且为false
    //          或 ProvisionedDevices与ProvisionsAllDevices都不存在
    
    command = [XAPScriptResposity fetchProfileIsProvisionedDevicesExistedCommand:profile];
    ret = [self executeScriptWithCommand:command
                                  output:&output
                                   error:error];
    if (!ret) { *output = kXAPChannelUnknown; return NO; }
    
    if (output) {
        command = [XAPScriptResposity fetchProfileGetTaskAllowCommand:profile];
        ret = [self executeScriptWithCommand:command
                                         output:&output
                                          error:error];
        if (!ret) { *output = kXAPChannelUnknown; return NO; }
        
        if ([output isEqualToString:@"true"]) {
            *output = kXAPChannelDevelopment;
        } else {
            *output = kXAPChannelAXAPoc;
        }
        return YES;
    }
    
    command = [XAPScriptResposity fetchProfileIsProvisionedAllDevicesExistedCommand:profile];
    ret = [self executeScriptWithCommand:command
                                  output:&output
                                   error:error];
    if (!ret) { *output = kXAPChannelUnknown; return NO; }
    
    if (output) {
        command = [XAPScriptResposity fetchProfileProvisionedAllDevicesCommand:profile];
        ret = [self executeScriptWithCommand:command
                                        output:&output
                                         error:error];
        
        if (!ret) { *output = kXAPChannelUnknown; return NO; }
        
        if ([output isEqualToString:@"true"]) {
            *output = kXAPChannelEnterprise;
        } else {
            *output = kXAPChannelAppStore;
        }
        return YES;
    }
    
    *output = kXAPChannelAppStore;
    return YES;
}


// MARK: - git相关
- (BOOL)gitCurrentBranchWithGitDirectory:(NSString *)gitDirectory
                                  
                                   error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchGitCurrentBranchCommand:gitDirectory]
                                       output:output
                                        error:error];
    return ret;
}

- (BOOL)gitStatusWithGitDirectory:(NSString *)gitDirectory
                           
                            error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchGitStatusCommand:gitDirectory]
                                       output:output
                                        error:error];
    return ret;
}

- (BOOL)gitAddAllWithGitDirectory:(NSString *)gitDirectory
                           
                            error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchGitAddAllCommand:gitDirectory]
                                       output:output
                                        error:error];
    return ret;
}

- (BOOL)gitStashWithGitDirectory:(NSString *)gitDirectory
                          
                           error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchGitStashCommand:gitDirectory]
                                       output:output
                                        error:error];
    return ret;
}

- (BOOL)gitResetToHeadWithGitDirectory:(NSString *)gitDirectory
                                
                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchGitResetToHeadCommand:gitDirectory]
                                       output:output
                                        error:error];
    return ret;
}

- (BOOL)gitPullWithGitDirectory:(NSString *)gitDirectory
                         
                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchGitPullCommand:gitDirectory]
                                       output:output
                                        error:error];
    return ret;
}

- (BOOL)gitCheckoutBranchWithGitDirectory:(NSString *)gitDirectory
                               branchName:(NSString *)branchName
                                   
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchGitCheckoutBranchCommand:gitDirectory branchName:branchName]
                                          output:output
                                           error:error];
    return ret;
}

- (BOOL)fetchGitBranchListWithGitDirectory:(NSString *)gitDirectory
                                    output:(NSArray * _Nullable __autoreleasing * _Nullable)output
                                     error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = NO;
    NSString *output = nil;
    
    // 获取branch list
    ret = [self executeScriptWithCommand:[XAPScriptResposity fetchGitBranchListCommand:gitDirectory]
                                  output:&output
                                   error:error];
    if (!ret) { return NO; }
    
    NSArray *branchNameList = [output componentsSeparatedByString:@"\r"];
    if (output) { *output = branchNameList; }
    
    return ret;
}

- (BOOL)fetchGitTagListWithGitDirectory:(NSString *)gitDirectory
                                 output:(NSArray * _Nullable __autoreleasing * _Nullable)output
                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = NO;
    NSString *output = nil;
    
    // 获取tag list
    ret = [self executeScriptWithCommand:[XAPScriptResposity fetchGitTagListCommand:gitDirectory]
                                  output:&output
                                   error:error];
    if (!ret) { return NO; }
    
    NSArray *tagList = [output componentsSeparatedByString:@"\r"];
    if (output) { *output = tagList; }
    
    return ret;
}


// MARK: - pod相关
- (BOOL)podInstallWithPodfileDirectory:(NSString *)podfileDirectory
                                
                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchPodInstallCommand:podfileDirectory]
                                       output:output
                                        error:error];
    return ret;
}


// MARK: - info.plist相关
- (BOOL)fetchInfoPlistProductNameWithInfoPlist:(NSString *)infoPlist
                                
                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchPlistProductNameCommand:infoPlist]
                                       output:output
                                        error:error];
    return ret;
}
- (BOOL)fetchInfoPlistDisplayNameWithInfoPlist:(NSString *)infoPlist
                                
                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchPlistDisplayNameCommand:infoPlist]
                                       output:output
                                        error:error];
    return ret;
}
- (BOOL)fetchInfoPlistBundleIdentifierWithInfoPlist:(NSString *)infoPlist
                                             
                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchPlistBundleIdentifierCommand:infoPlist]
                                       output:output
                                        error:error];
    return ret;
}
- (BOOL)fetchInfoPlistShortVersionWithInfoPlist:(NSString *)infoPlist
                                         
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchPlistShortVersionCommand:infoPlist]
                                       output:output
                                        error:error];
    return ret;
}

- (BOOL)fetchInfoPlistBuildVersionWithInfoPlist:(NSString *)infoPlist
                                 
                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchPlistBuildVersionCommand:infoPlist]
                                       output:output
                                        error:error];
    return ret;
}

- (BOOL)fetchInfoPlistExecutableFileWithInfoPlist:(NSString *)infoPlist
                                           
                                            error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchPlistExecutableFileCommand:infoPlist]
                                       output:output
                                        error:error];
    return ret;
}

- (BOOL)fetchInfoPlistMinimumOSVersionWithInfoPlist:(NSString *)infoPlist
                                             
                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchPlistMinimumOSVersionCommand:infoPlist]
                                       output:output
                                        error:error];
    return ret;
}

- (BOOL)plistFetchAttributeWithInfoPlist:(NSString *)infoPlist
                            attributeKey:(NSString *)attributeKey
                                  
                                   error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchPlistAttibuteCommand:infoPlist
                                                                           attributeName:attributeKey]
                                       output:output
                                        error:error];
    return ret;
}

- (BOOL)plistAppendAttributeWithInfoPlist:(NSString *)infoPlist
                             attributeKey:(NSString *)attributeKey
                           attributeValue:(NSString *)attributeValue
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchPlistAddAttibuteCommand:infoPlist
                                                                              attributeName:attributeKey
                                                                             attributeValue:attributeValue]
                                          output:nil
                                           error:error];
    return ret;
}

- (BOOL)plistDeleteAttributeWithInfoPlist:(NSString *)infoPlist
                             attributeKey:(NSString *)attributeKey
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchPlistDelAttibuteCommand:infoPlist
                                                                              attributeName:attributeKey]
                                          output:nil
                                           error:error];
    return ret;
}

- (BOOL)plistModifyAttributeWithInfoPlist:(NSString *)infoPlist
                             attributeKey:(NSString *)attributeKey
                           attributeValue:(NSString *)attributeValue
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchPlistSetAttibuteCommand:infoPlist
                                                                              attributeName:attributeKey
                                                                             attributeValue:attributeValue]
                                          output:nil
                                           error:error];
    return ret;
}


#pragma mark - app相关
- (BOOL)fetchAppEnableBitcodeWithExecutableFile:(NSString *)executableFile
                                         
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchOtoolEnableBitcodeCommand:executableFile]
                                       output:output
                                        error:error];
    if (!ret) { return NO; }
    // 0: NO; 其他: YES
    NSString *enableBitcodeIntegerString = *output;
    enableBitcodeIntegerString = [enableBitcodeIntegerString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([enableBitcodeIntegerString isEqualToString:@"0"]) {
        *output = kXAPEnableBitcodeNO;
    } else {
        *output = kXAPEnableBitcodeYES;
    }
    
    return ret;
}

- (BOOL)fetchAppCodesignIdentifierWithAppFile:(NSString *)appFile
                                       
                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchCodesignAuthorityCommand:appFile]
                                       output:output
                                        error:error];
    return ret;
}

- (BOOL)fetchAppArchitecturesWithExecutableFile:(NSString *)executableFile
                                         
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    BOOL ret = [self executeScriptWithCommand:[XAPScriptResposity fetchLipoArchitecturesCommand:executableFile]
                                       output:output
                                        error:error];
    return ret;
}

@end
