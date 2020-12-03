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
- (NSDictionary * _Nullable)fetchProfileInfoWithProfile:(NSString *)profile
                                            profileName:(NSString * _Nullable __autoreleasing *)profileName
                                       bundleIdentifier:(NSString * _Nullable __autoreleasing *)bundleIdentifier
                                         teamIdentifier:(NSString * _Nullable __autoreleasing *)teamIdentifier
                                  applicationIdentifier:(NSString * _Nullable __autoreleasing *)applicationIdentifier
                                                   uuid:(NSString * _Nullable __autoreleasing *)uuid
                                               teamName:(NSString * _Nullable __autoreleasing *)teamName
                                                channel:(NSString * _Nullable __autoreleasing *)channel
                                        createTimestamp:(NSString * _Nullable __autoreleasing *)createTimestamp
                                        expireTimestamp:(NSString * _Nullable __autoreleasing *)expireTimestamp
                                           entitlements:(NSDictionary * _Nullable __autoreleasing *)entitlements
                                                  error:(NSError * _Nullable __autoreleasing *)error {
    NSString *infoPlistPath = [[profile stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"XAP_profile_info.plist"];
    XAPScriptModel *command = [XAPScriptResposity fetchProfileInfoCommand:profile infoPlistPath:infoPlistPath];
    [self executeScriptWithCommand:command error:error];
    if (*error) { return nil; }
    // 解析为字典后删除
    NSDictionary *result = [NSDictionary dictionaryWithContentsOfFile:infoPlistPath];
    [[NSFileManager defaultManager] removeItemAtPath:infoPlistPath error:nil];
    
    if (profileName) { *profileName = result[@"Name"]; }
    if (teamName) { *teamName = result[@"TeamName"]; }
    if (entitlements) { *entitlements = result[@"Entitlements"]; }
    if (uuid) { *uuid = result[@"UUID"]; }
    
    {
        /*
         Create timestamp, Expire timestamp
         */
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY-MM-dd'T'HH:mm:ss'Z'";
        
        if (createTimestamp) {
            NSString *time = result[@"CreationDate"];
            NSDate *date = [formatter dateFromString:time];
            *createTimestamp = [NSString stringWithFormat:@"%zd", (NSInteger)[date timeIntervalSince1970]];
        }
        
        if (expireTimestamp) {
            NSString *time = result[@"ExpirationDate"];
            NSDate *date = [formatter dateFromString:time];
            *expireTimestamp = [NSString stringWithFormat:@"%zd", (NSInteger)[date timeIntervalSince1970]];
        }
    }
    
    {
        /*
         Application Identifier, Team Identifier, Bundle Identifier
         */
        NSString *appId = result[@"Entitlements"][@"application-identifier"];
        NSString *teamId = result[@"Entitlements"][@"com.apple.developer.team-identifier"];
        if (applicationIdentifier) { *applicationIdentifier = appId; }
        if (teamIdentifier) { *teamIdentifier = teamId; }
        if (bundleIdentifier) {
            NSString *bundleId;
            // 拆分
            // 理论上格式是 appid: <teamid>.<bundleid>
            if (appId.length > (teamId.length+1)) {
                bundleId = [appId substringFromIndex:teamId.length+1];
            } else {
                // 理论上不可能执行到此处，以防万一
                // 以 . 分割排除第一项
                NSArray *components = [appId componentsSeparatedByString:@"."];
                if (components.count > 2) {
                    bundleId = [[components subarrayWithRange:NSMakeRange(1, components.count-1)] componentsJoinedByString:@"."];
                } else {
                    bundleId = appId;
                }
            }
            *bundleIdentifier = bundleId;
        }
    }
    
    {
        /*
         Channel
         */
        if (channel) {
            BOOL isProvisionedDevicesExist = result[@"ProvisionedDevices"] ? YES : NO;
            BOOL get_task_allow = [result[@"Entitlements"][@"get-task-allow"] boolValue];
            BOOL isProvisionsAllDevicesExist = result[@"ProvisionsAllDevices"] ?  YES : NO;
            
            if (isProvisionedDevicesExist) {
                if (get_task_allow) {
                    *channel = kXAPChannelDevelopment;
                } else {
                    *channel = kXAPChannelAdHoc;
                }
            } else if (isProvisionsAllDevicesExist) {
                BOOL isEnterprise = [result[@"ProvisionsAllDevices"] boolValue];
                if (isEnterprise) {
                    *channel = kXAPChannelEnterprise;
                } else {
                    *channel = kXAPChannelAppStore;
                }
            }
        }
    }
    
    return result;
}

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

- (NSString * _Nullable)fetchProfileExpireTimestampWithProfile:(NSString *)profile
                                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = nil;
    NSString *output = nil;
    
    // 获取ExpireTime
    command = [XAPScriptResposity fetchProfileExpireTimeCommand:profile];
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

- (NSString * _Nullable)fetchProfileNameWithProfile:(NSString *)profile
                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchProfileNameCommand:profile];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)fetchProfileAppIdentifierWithProfile:(NSString *)profile
                                                       error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchProfileAppIdentifierCommand:profile];
    NSString *result = [self executeScriptWithCommand:command
                                        error:error];
    return result;
}

- (NSString * _Nullable)fetchProfileBundleIdentifierWithProfile:(NSString *)profile
                                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = nil;
    NSString *appId = nil;
    NSString *teamId = nil;
    NSString *result;
    
    // 获取appId
    command = [XAPScriptResposity fetchProfileAppIdentifierCommand:profile];
    appId = [self executeScriptWithCommand:command
                                   error:error];
    if (*error) { return nil; }
    
    // 获取team id
    command = [XAPScriptResposity fetchProfileTeamIdentifierCommand:profile];
    teamId = [self executeScriptWithCommand:command
                                      error:error];
    if (*error) { return nil; }
    
    // 拆分
    // 理论上格式是 appid: <teamid>.<bundleid>
    if (appId.length > (teamId.length+1)) {
        result = [appId substringFromIndex:teamId.length+1];
        return result;
    }
    // 理论上不可能执行到此处，以防万一
    // 以 . 分割排除第一项
    NSArray *components = [appId componentsSeparatedByString:@"."];
    if (components.count > 2) {
        result = [[components subarrayWithRange:NSMakeRange(1, components.count-1)] componentsJoinedByString:@"."];
    } else {
        result = appId;
    }
    
    return result;
}

- (NSString * _Nullable)fetchProfileTeamIdentifierWithProfile:(NSString *)profile
                                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchProfileTeamIdentifierCommand:profile];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)fetchProfileTeamNameWithProfile:(NSString *)profile
                                                  error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchProfileTeamNameCommand:profile];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)fetchProfileUUIDWithProfile:(NSString *)profile
                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchProfileUUIDCommand:profile];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (XAPChannel)fetchProfileChannelWithProfile:(NSString *)profile
                                       error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = nil;
    NSString *output = nil;
    
    // 判别channel类型
    // Development: ProvisionedDevices存在 且 get-task-allow为true
    // Ad-Hoc: ProvisionedDevices存在 且 get-task-allow为false
    // Enterprise: ProvisionedDevices不存在 且 ProvisionsAllDevices存在且为true
    // AppStore: ProvisionedDevices不存在 且 ProvisionsAllDevices存在且为false
    //          或 ProvisionedDevices与ProvisionsAllDevices都不存在
    
    command = [XAPScriptResposity fetchProfileIsProvisionedDevicesExistedCommand:profile];
    output = [self executeScriptWithCommand:command
                                      error:error];
    if (*error) { return kXAPChannelUnknown; }
    
    if (output) {
        command = [XAPScriptResposity fetchProfileGetTaskAllowCommand:profile];
        output = [self executeScriptWithCommand:command
                                          error:error];
        if (*error) { return kXAPChannelUnknown; }
        
        if ([output isEqualToString:@"true"]) {
            return kXAPChannelDevelopment;
        }
        
        return kXAPChannelAdHoc;
    }
    
    command = [XAPScriptResposity fetchProfileIsProvisionedAllDevicesExistedCommand:profile];
    output = [self executeScriptWithCommand:command
                                      error:error];
    if (*error) { return kXAPChannelUnknown; }
    
    if (output) {
        command = [XAPScriptResposity fetchProfileProvisionedAllDevicesCommand:profile];
        output = [self executeScriptWithCommand:command
                                          error:error];
        
        if (*error) { return kXAPChannelUnknown; }
        
        if ([output isEqualToString:@"true"]) {
            return kXAPChannelEnterprise;
        }
        
        return kXAPChannelAppStore;
    }
    
    return kXAPChannelAppStore;
}

- (void)fetchKeychainCertificatesOfTeamNames:(NSArray <NSString *> * __autoreleasing _Nullable * _Nullable)teamNames
                                       uuids:(NSArray <NSString *> * __autoreleasing _Nullable * _Nullable)uuids
                             teamIdentifiers:(NSArray <NSString *> * __autoreleasing _Nullable * _Nullable)teamIdentifiers
                                       error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchKeychainCertificatesCommand];
    
    NSString *output = [self executeScriptWithCommand:command error:error];
    if (*error) { return ; }
    
    NSArray *list = [output componentsSeparatedByString:@"\r"];
    /*
     1) F7E1D505B4CAD8B016523F45A8FD6F4529A66AD7 "Apple Development: 数据 菲凡 (5V8CU4553V)" (CSSMERR_TP_CERT_REVOKED)
     2) EBC2AF4662E58DAECA38698985BC4285D9D6176C "Apple Development: renfei song (9C2Q99VBH5)"
     */
    __block NSMutableArray *teamNamesResult = [NSMutableArray array];
    __block NSMutableArray *uuidsResult = [NSMutableArray array];
    __block NSMutableArray *teamIdentifiersResult = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *temp = [obj copy];
        if ([temp containsString:@"("] && [temp containsString:@")"] && [temp containsString:@"\""] && [temp containsString:@":"]) {
            NSRange r1 = [temp rangeOfString:@")"];
            NSRange r2 = [temp rangeOfString:@"\""];
            NSString *uuid = [temp substringWithRange:NSMakeRange(NSMaxRange(r1), r2.location-NSMaxRange(r1))];
            uuid = [uuid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            temp = [temp substringFromIndex:NSMaxRange(r2)];
            r1 = [temp rangeOfString:@":"];
            r2 = [temp rangeOfString:@"\""];
            NSString *teamName = [temp substringWithRange:NSMakeRange(NSMaxRange(r1), r2.location-NSMaxRange(r1))];
            teamName = [teamName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            r1 = [temp rangeOfString:@"("];
            r2 = [temp rangeOfString:@")"];
            NSString *teamIdentifier = [temp substringWithRange:NSMakeRange(NSMaxRange(r1), r2.location-NSMaxRange(r1))];
            teamIdentifier = [teamIdentifier stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            [uuidsResult addObject:uuid];
            [teamNamesResult addObject:teamName];
            [teamIdentifiersResult addObject:teamIdentifier];
        }
    }];
    
    if (teamNames) { *teamNames = [teamNamesResult copy]; }
    if (uuids) { *uuids = [uuidsResult copy]; }
    if (teamIdentifiers) { *teamIdentifiers = [teamIdentifiersResult copy]; }
    
}


// MARK: - git相关
- (NSString * _Nullable)gitCurrentBranchWithGitDirectory:(NSString *)gitDirectory
                                                   error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchGitCurrentBranchCommand:gitDirectory];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)gitStatusWithGitDirectory:(NSString *)gitDirectory
                                            error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchGitStatusCommand:gitDirectory];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (BOOL)gitAddAllWithGitDirectory:(NSString *)gitDirectory
                            error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchGitAddAllCommand:gitDirectory];
    [self executeScriptWithCommand:command error:error];
    if (*error) { return NO; }
    
    return YES;
}

- (BOOL)gitStashWithGitDirectory:(NSString *)gitDirectory
                                           error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchGitStashCommand:gitDirectory];
    [self executeScriptWithCommand:command error:error];
    if (*error) { return NO; }
    
    return YES;
}

- (BOOL)gitResetToHeadWithGitDirectory:(NSString *)gitDirectory
                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchGitResetToHeadCommand:gitDirectory];
    [self executeScriptWithCommand:command error:error];
    if (*error) { return NO; }
    
    return YES;
}

- (NSString * _Nullable)gitPullWithGitDirectory:(NSString *)gitDirectory
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchGitPullCommand:gitDirectory];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)gitCheckoutBranchWithGitDirectory:(NSString *)gitDirectory
                                               branchName:(NSString *)branchName
                                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchGitCheckoutBranchCommand:gitDirectory branchName:branchName];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSArray * _Nullable)fetchGitBranchListWithGitDirectory:(NSString *)gitDirectory
                                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = nil;
    NSString *output = nil;
    
    // 获取branch list
    command = [XAPScriptResposity fetchGitBranchListCommand:gitDirectory];
    output = [self executeScriptWithCommand:command
                                      error:error];
    if (*error) { return nil; }
    
    NSArray *branchNameList = [output componentsSeparatedByString:@"\r"];
    return branchNameList;
}

- (NSArray * _Nullable)fetchGitTagListWithGitDirectory:(NSString *)gitDirectory
                                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = nil;
    NSString *output = nil;
    
    // 获取tag list
    command = [XAPScriptResposity fetchGitTagListCommand:gitDirectory];
    output = [self executeScriptWithCommand:command
                                      error:error];
    if (*error) { return nil; }
    
    NSArray *tagList = [output componentsSeparatedByString:@"\r"];
    
    return tagList;
}

- (NSArray * _Nullable)fetchGitBranchsWithGitDirectory:(NSString *)gitDirectory
                                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSMutableArray *result = [NSMutableArray array];
    NSArray *branchList = [self fetchGitBranchListWithGitDirectory:gitDirectory error:error];
    if (*error) { return nil; }
    
    [result addObjectsFromArray:branchList];
    
    NSArray *tagList = [self fetchGitTagListWithGitDirectory:gitDirectory error:error];
    if (*error) { return nil; }
    
    [result addObjectsFromArray:tagList];
    return [result copy];
}


// MARK: - pod相关
- (BOOL)podInstallWithPodfileDirectory:(NSString *)podfileDirectory
                                 error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPodInstallCommand:podfileDirectory];
    [self executeScriptWithCommand:command error:error];
    if (*error) { return NO; }
    
    return YES;
}


// MARK: - info.plist相关
- (NSString * _Nullable)fetchInfoPlistProductNameWithInfoPlist:(NSString *)infoPlist
                                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPlistProductNameCommand:infoPlist];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)fetchInfoPlistDisplayNameWithInfoPlist:(NSString *)infoPlist
                                                         error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPlistDisplayNameCommand:infoPlist];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)fetchInfoPlistBundleIdentifierWithInfoPlist:(NSString *)infoPlist
                                                              error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPlistBundleIdentifierCommand:infoPlist];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)fetchInfoPlistShortVersionWithInfoPlist:(NSString *)infoPlist
                                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPlistShortVersionCommand:infoPlist];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)fetchInfoPlistVersionWithInfoPlist:(NSString *)infoPlist
                                                     error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPlistVersionCommand:infoPlist];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)fetchInfoPlistExecutableFileWithInfoPlist:(NSString *)infoPlist
                                                            error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPlistExecutableFileCommand:infoPlist];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)plistFetchAttributeWithInfoPlist:(NSString *)infoPlist
                                            attributeKey:(NSString *)attributeKey
                                                   error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPlistAttibuteCommand:infoPlist
                                                              attributeName:attributeKey];
    NSString *result = [self executeScriptWithCommand:command
                                        error:error];
    return result;
}

- (BOOL)plistAppendAttributeWithInfoPlist:(NSString *)infoPlist
                             attributeKey:(NSString *)attributeKey
                           attributeValue:(NSString *)attributeValue
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPlistAddAttibuteCommand:infoPlist
                                                                 attributeName:attributeKey
                                                                attributeValue:attributeValue];
    [self executeScriptWithCommand:command error:error];
    if (*error) { return NO; }
    
    return YES;
}

- (BOOL)plistDeleteAttributeWithInfoPlist:(NSString *)infoPlist
                             attributeKey:(NSString *)attributeKey
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPlistDelAttibuteCommand:infoPlist
                                                                 attributeName:attributeKey];
    [self executeScriptWithCommand:command error:error];
    if (*error) { return NO; }
    
    return YES;
}

- (BOOL)plistModifyAttributeWithInfoPlist:(NSString *)infoPlist
                             attributeKey:(NSString *)attributeKey
                           attributeValue:(NSString *)attributeValue
                                    error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchPlistSetAttibuteCommand:infoPlist
                                                                 attributeName:attributeKey
                                                                attributeValue:attributeValue];
    [self executeScriptWithCommand:command error:error];
    if (*error) { return NO; }
    
    return YES;
}


#pragma mark - app相关
- (XAPEnableBitcode)fetchAppEnableBitcodeWithExecutableFile:(NSString *)executableFile
                                                      error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchOtoolEnableBitcodeCommand:executableFile];
    NSString *output = [self executeScriptWithCommand:command
                                                error:error];
    if (*error) { return nil; }
    
    // 0: NO; 其他: YES
    NSString *enableBitcodeIntegerString = output;
    enableBitcodeIntegerString = [enableBitcodeIntegerString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([enableBitcodeIntegerString isEqualToString:@"0"]) {
        return kXAPEnableBitcodeNO;
    }
         
    return kXAPEnableBitcodeYES;
}

- (NSString * _Nullable)fetchAppCodesignIdentifierWithAppFile:(NSString *)appFile
                                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchCodesignAuthorityCommand:appFile];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

- (NSString * _Nullable)fetchAppArchitecturesWithExecutableFile:(NSString *)executableFile
                                          error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    XAPScriptModel *command = [XAPScriptResposity fetchLipoArchitecturesCommand:executableFile];
    NSString *result = [self executeScriptWithCommand:command
                                                error:error];
    return result;
}

@end
