//
//  DHCoreScriptGetter.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHCoreScriptGetter.h"
#import "DHScriptCommand.h"
#import "DHGitModel.h"
#import "DHPodModel.h"
#import "DHWorkspaceModel.h"
#import "DHProjectModel.h"
#import "DHTargetModel.h"
#import "DHProfileModel.h"
#import "DHBuildConfigurationModel.h"
#import "DHArchiveModel.h"
#import "DHAppModel.h"
#import "DHIPAModel.h"
#import "DHDistributionModel.h"
#import "DHDistributionFirModel.h"
#import "DHDistributionPgyerModel.h"
#import "DHXcworkspaceUtils.h"

@implementation DHCoreScriptGetter

/// 组装工作空间信息
/// @param xcworkspaceFile 工作空间文件(.xcworkspace)
+ (DHWorkspaceModel *)fetchWorkspaceWithXcworkspaceFile:(NSString *)xcworkspaceFile
                                                error:(NSError **)error {
    if (![DHPathUtils isXcworkspaceFile:xcworkspaceFile]) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_XCWORKSPACE_INVALID, @".xcworkspace路径异常");
        return nil;
    }
    DHWorkspaceModel *model = [[DHWorkspaceModel alloc] init];
    model.xcworkspaceFile = xcworkspaceFile;
    
    // 获取关联工程路径
    NSArray *xcodeprojFiles = [DHXcworkspaceUtils getXcodeprojVirtualFilesWithWorkspaceFile:xcworkspaceFile];
    if (![DHObjectTools isValidArray:xcodeprojFiles]) {
        // 未找到任何关联工程
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_XCWORKSPACE_NO_RELATE_PROJECT, @".xcworkspace未找到任何关联工程");
        return model;
    }
    NSMutableArray *projects = [NSMutableArray arrayWithCapacity:xcodeprojFiles.count];
    
    for (NSString *xcodeprojFile in xcodeprojFiles) {
        DHProjectModel *project = [self fetchProjectWithXcodeprojFile:xcodeprojFile
                                                                error:error];
        // 读取某项目失败
        if (*error) { return model; }
        
        [projects addObject:project];
    }
    if (![DHObjectTools isValidArray:projects]) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_XCWORKSPACE_PARSE_PROJECT_FAILED, @".xcworkspace解析关联的.xcodeproj失败");
        return model;
    }
    model.projects = projects;
    
    return model;
}

/// 组装项目信息
/// @param xcodeprojFile 项目文件(.xcodeproj)
+ (DHProjectModel *)fetchProjectWithXcodeprojFile:(NSString *)xcodeprojFile
                                          error:(NSError **)error {
    if (![DHPathUtils isXcodeprojFile:xcodeprojFile]) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_XCODEPROJ_INVALID, @".xcodeproj路径异常");
        return nil;
    }
    DHProjectModel *model = [[DHProjectModel alloc] init];
    model.xcodeprojFile = xcodeprojFile;
    
    BOOL ret = NO;
    NSArray *output = nil;
    NSError *err = nil;
    // 获取关联target信息
    ret = [DHScriptCommand fetchProjectTargetIdListWithXcodeprojFile:xcodeprojFile
                                                              output:&output
                                                               error:&err];
    if (err) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_XCODEPROJ_PARSE_FAILED, err);
        return model;
    }
    
    NSArray *targetIdList = output;
    NSMutableArray *targets = [NSMutableArray arrayWithCapacity:targetIdList.count];
    
    for (NSString *targetId in targetIdList) {
        DHTargetModel *target = [self fetchTargetWithXcodeprojFile:xcodeprojFile
                                                        targetId:targetId
                                                           error:&err];
        
        if (err) {
            DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_XCODEPROJ_PARSE_TARGET_FAILED, err);
            return model;
        }
        
        [targets addObject:target];
    }
    
    if (![DHObjectTools isValidArray:targets]) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_XCODEPROJ_NO_RELATE_TARGET, @".xcodeproj解析target失败");
        return model;
    }
    model.targets = targets;
    
    return model;
}

/// 组装项目关联Target信息
/// @param xcodeprojFile 项目文件(.xcodeproj)
/// @param targetId targetId
+ (DHTargetModel *)fetchTargetWithXcodeprojFile:(NSString *)xcodeprojFile
                                     targetId:(NSString *)targetId
                                        error:(NSError **)error {
    if (![DHPathUtils isXcodeprojFile:xcodeprojFile]) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_XCODEPROJ_INVALID, @".xcodeproj路径异常");
        return nil;
    }
    DHTargetModel *model = [[DHTargetModel alloc] init];
    
    BOOL ret = NO;
    NSString *output = nil;
    NSError *err;
    
    // 获取targetName
    ret = [DHScriptCommand fetchProjectTargetNameWithXcodeprojFile:xcodeprojFile
                                                          targetId:targetId
                                                            output:&output
                                                             error:&err];
    if (err) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_TARGET_PARSE_NAME_FAILED, err);
        return model;
    }
    model.name = output;
    
    NSArray *outputArray = nil;
    // 获取buildConfigurationIds
    ret = [DHScriptCommand fetchProjectBuildConfigurationIdListWithXcodeprojFile:xcodeprojFile
                                                                      targetId:targetId
                                                                        output:&outputArray
                                                                         error:&err];
    if (err) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_TARGET_PARSE_BUILDCONFIGURATIONIDS_FAILED, err);
        return model;
    }
    
    NSArray *buildConfigurationIdList = outputArray;
    NSMutableArray *buildConfigurations = [NSMutableArray arrayWithCapacity:buildConfigurationIdList.count];
    
    for (NSString *buildConfigurationId in buildConfigurationIdList) {
        DHBuildConfigurationModel *buildConfiguration = [self fetchBuildConfigurationWithXcodeprojFile:xcodeprojFile
                                                                                          targetName:model.name
                                                                                     configurationId:buildConfigurationId
                                                                                               error:&err];
        if (err) {
            DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_TARGET_PARSE_BUILDCONFIGURATIONS_FAILED, err);
            return model;
        }
        
        [buildConfigurations addObject:buildConfiguration];
    }
    
    if (![DHObjectTools isValidArray:buildConfigurations]) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_TARGET_PARSE_BUILDCONFIGURATIONS_FAILED, @"解析target关联的buildConfigurations失败");
        return model;
    }
    model.buildConfigurations = buildConfigurations;
    
    return model;
}

/// 组装项目关联Target信息
/// @param xcodeprojFile 项目文件(.xcodeproj)
/// @param targetName scheme
+ (DHTargetModel *)fetchTargetWithXcodeprojFile:(NSString *)xcodeprojFile
                                   targetName:(NSString *)targetName
                                        error:(NSError **)error {
    DHTargetModel *model = [[DHTargetModel alloc] init];
    
    BOOL ret = NO;
    NSArray *output = nil;
    // 获取关联target信息
    ret = [DHScriptCommand fetchProjectTargetIdListWithXcodeprojFile:xcodeprojFile
                                                              output:&output
                                                               error:error];
    if (*error) { return nil; }
    
    NSArray *targetIdList = output;
    
    NSError *err = nil;
    for (NSString *targetId in targetIdList) {
        DHTargetModel *target = [self fetchTargetWithXcodeprojFile:xcodeprojFile
                                                        targetId:targetId
                                                           error:&err];
        
        if (err) {
            DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_XCODEPROJ_PARSE_TARGET_FAILED, err);
            return model;
        }
        // 匹配
        if (![targetName isEqualToString:target.name]) { continue; }
        
        model = target;
        break;
    }
    
    return model;
}

/// 组装Target配置信息
/// @param xcodeprojFile 项目文件(.xcodeproj)
/// @param targetName scheme
/// @param configurationId 配置id
+ (DHBuildConfigurationModel *)fetchBuildConfigurationWithXcodeprojFile:(NSString *)xcodeprojFile
                                                           targetName:(NSString *)targetName
                                                      configurationId:(NSString *)configurationId
                                                                error:(NSError **)error {
    if (![DHPathUtils isXcodeprojFile:xcodeprojFile]) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_XCODEPROJ_INVALID, @".xcodeproj路径异常");
        return nil;
    }
    DHBuildConfigurationModel *model = [[DHBuildConfigurationModel alloc] init];
    
    BOOL ret = NO;
    NSString *output = nil;
    NSError *err;
    // 获取名称
    ret = [DHScriptCommand fetchProjectBuildConfigurationNameWithXcodeprojFile:xcodeprojFile
                                                        buildConfigurationId:configurationId
                                                                      output:&output
                                                                       error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_BUILDCONFIGURATION_PARSE_NAME_FAILED, err);
        return model;
    }
    model.name = output;
    
    // 获取team id
    ret = [DHScriptCommand fetchProjectTeamIdentifierWithXcodeprojFile:xcodeprojFile
                                                  buildConfigurationId:configurationId
                                                                output:&output
                                                                 error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_BUILDCONFIGURATION_PARSE_TEAMID_FAILED, err);
        return model;
    }
    model.teamId = output;
    
    // 获取enableBitcode
    ret = [DHScriptCommand fetchProjectEnableBitcodeWithXcodeprojFile:xcodeprojFile
                                                 buildConfigurationId:configurationId
                                                               output:&output
                                                                error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_BUILDCONFIGURATION_PARSE_ENABLEBITCODE_FAILED, err);
        return model;
    }
    // info.plist可能不存在该值，所以不做错误判断
    // 当buildSettings不存在该字段时（一旦存在，也必然存在值YES/NO），说明项目默认给了YES
    model.enableBitcode = output.length == 0? kDHEnableBitcodeYES : output;
    
    // 获取info.plist绝对路径
    ret = [DHScriptCommand fetchProjectInfoPlistFileWithXcodeprojFile:xcodeprojFile
                                               buildConfigurationId:configurationId
                                                             output:&output
                                                              error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_INFOPLIST_INVALID, err);
        return model;
    }
    model.infoPlistFile = [DHPathUtils getAbsolutePathWithXcodeprojFile:xcodeprojFile
                                                         relativePath:output];
    
    // 获取product name
    ret = [DHScriptCommand fetchInfoPlistProductNameWithInfoPlist:model.infoPlistFile
                                                           output:&output
                                                            error:&err];
    // 理论上info.plist必然存在ProductName
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_APP_PARSE_PRODUCT_NAME_FAILED, err);
        return model;
    }
    NSString *productName = output;
    if (checkPlistValueRelatived(productName)) {
        NSString *buildSettingsKey = fetchBuildSettingsKeyWithPlistRelativeValue(productName);
        ret = [DHScriptCommand fetchProjectBuildSettingsValueWithXcodeprojFile:xcodeprojFile
                                                          buildConfigurationId:configurationId
                                                              buildSettingsKey:buildSettingsKey
                                                                        output:&output
                                                                         error:&err];
        // 此处不做处理，再给后面挽回的机会
        if (ret) { productName = output; }
    }
    if (!productName) {
        ret = [DHScriptCommand fetchProjectProductNameWithXcodeprojFile:xcodeprojFile
                                                   buildConfigurationId:configurationId
                                                                 output:&output
                                                                  error:&err];
        if (!ret) {
            DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_BUILDCONFIGURATION_PARSE_PRODUCT_NAME_FAILED, err);
            return model;
        }
        productName = output;
    }
    // $(TARGET_NAME)
    if ([kDHRelativeValueTargetName isEqualToString:productName]) {
        productName = targetName;
    }
    model.productName = productName;
    
    
    // 获取App展示名称
    ret = [DHScriptCommand fetchInfoPlistDisplayNameWithInfoPlist:model.infoPlistFile
                                                           output:&output
                                                            error:&err];
    // info.plist可能不存在该值，所以不做错误判断
    NSString *displayName = output;
    if (checkPlistValueRelatived(displayName)) {
        NSString *buildSettingsKey = fetchBuildSettingsKeyWithPlistRelativeValue(displayName);
        ret = [DHScriptCommand fetchProjectBuildSettingsValueWithXcodeprojFile:xcodeprojFile
                                                          buildConfigurationId:configurationId
                                                              buildSettingsKey:buildSettingsKey
                                                                        output:&output
                                                                         error:&err];
        // 此处不做处理，再给后面挽回的机会
        if (ret) { displayName = output; }
    }
    if (!displayName || [kDHRelativeValueTargetName isEqualToString:displayName]) {
        displayName = productName;
    }
    model.displayName = displayName;
    
    
    // 获取bundle id
    ret = [DHScriptCommand fetchInfoPlistBundleIdentifierWithInfoPlist:model.infoPlistFile
                                                                output:&output
                                                                 error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_APP_PARSE_BUNDLEID_FAILED, err);
        return model;
    }
    NSString *bundleId = output;
    if (checkPlistValueRelatived(bundleId)) {
        NSString *buildSettingsKey = fetchBuildSettingsKeyWithPlistRelativeValue(bundleId);
        ret = [DHScriptCommand fetchProjectBuildSettingsValueWithXcodeprojFile:xcodeprojFile
                                                          buildConfigurationId:configurationId
                                                              buildSettingsKey:buildSettingsKey
                                                                        output:&output
                                                                         error:&err];
        // 此处不做处理，再给后面挽回的机会
        if (ret) { bundleId = output; }
    }
    if (!bundleId) {
        ret = [DHScriptCommand fetchProjectBundleIdentifierWithXcodeprojFile:xcodeprojFile
                                                        buildConfigurationId:configurationId
                                                                      output:&output
                                                                       error:&err];
        if (!ret) {
            DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_BUILDCONFIGURATION_PARSE_BUNDLEID_FAILED, err);
            return model;
        }
        bundleId = output;
    }
    model.bundleId = bundleId;
    
    
    // 获取version
    ret = [DHScriptCommand fetchInfoPlistShortVersionWithInfoPlist:model.infoPlistFile
                                               output:&output
                                                error:&err];
    // 理论上info.plist必然存在version
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_APP_PARSE_VERSION_FAILED, err);
        return model;
    }
    NSString *version = output;
    if (checkPlistValueRelatived(version)) {
        NSString *buildSettingsKey = fetchBuildSettingsKeyWithPlistRelativeValue(version);
        ret = [DHScriptCommand fetchProjectBuildSettingsValueWithXcodeprojFile:xcodeprojFile
                                                          buildConfigurationId:configurationId
                                                              buildSettingsKey:buildSettingsKey
                                                                        output:&output
                                                                         error:&err];
        // 此处不做处理，再给后面挽回的机会
        if (ret) { version = output; }
    }
    if (!version) {
        ret = [DHScriptCommand fetchProjectShortVersionWithXcodeprojFile:xcodeprojFile
                                                    buildConfigurationId:configurationId
                                                                  output:&output
                                                                   error:&err];
        if (!ret) {
            DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_BUILDCONFIGURATION_PARSE_VERSION_FAILED, err);
            return model;
        }
        version = output;
    }
    model.shortVersion = version;
    
    
    // 获取build version
    ret = [DHScriptCommand fetchInfoPlistBuildVersionWithInfoPlist:model.infoPlistFile
                                                            output:&output
                                                             error:&err];
    // 理论上info.plist必然存在build version
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_APP_PARSE_VERSION_FAILED, err);
        return model;
    }
    NSString *buildVersion = output;
    if (checkPlistValueRelatived(buildVersion)) {
        NSString *buildSettingsKey = fetchBuildSettingsKeyWithPlistRelativeValue(buildVersion);
        ret = [DHScriptCommand fetchProjectBuildSettingsValueWithXcodeprojFile:xcodeprojFile
                                                          buildConfigurationId:configurationId
                                                              buildSettingsKey:buildSettingsKey
                                                                        output:&output
                                                                         error:&err];
        // 此处不做处理，再给后面挽回的机会
        if (ret) { buildVersion = output; }
    }
    if (!buildVersion) {
        ret = [DHScriptCommand fetchProjectBuildVersionWithXcodeprojFile:xcodeprojFile
                                                    buildConfigurationId:configurationId
                                                                  output:&output
                                                                   error:&err];
        if (!ret) {
            DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_BUILDCONFIGURATION_PARSE_BUILDVERSION_FAILED, err);
            return model;
        }
        buildVersion = output;
    }
    model.buildVersion = buildVersion;
    
    
    return model;
    
}

/// 组装Target配置信息
/// @param xcodeprojFile 项目文件(.xcodeproj)
/// @param targetName scheme
+ (DHBuildConfigurationModel *)fetchBuildConfigurationWithXcodeprojFile:(NSString *)xcodeprojFile
                                                           targetName:(NSString *)targetName
                                                    configurationName:(DHConfigurationName)configurationName
                                                                error:(NSError **)error {
    // 遍历targetId，再遍历configurationId
    DHBuildConfigurationModel *model = [[DHBuildConfigurationModel alloc] init];
    
    BOOL ret = NO;
    NSArray *outputArray = nil;
    NSString *output = nil;
    NSError *err;
    // 获取关联target信息
    ret = [DHScriptCommand fetchProjectTargetIdListWithXcodeprojFile:xcodeprojFile
                                                              output:&outputArray
                                                               error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_XCODEPROJ_PARSE_TARGET_FAILED, err);
        return nil;
    }
    
    NSArray *targetIdList = outputArray;
    
    for (NSString *targetId in targetIdList) {
        // 获取targetName
        ret = [DHScriptCommand fetchProjectTargetNameWithXcodeprojFile:xcodeprojFile
                                                              targetId:targetId
                                                                output:&output
                                                                 error:&err];
        if (!ret) {
            DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_TARGET_PARSE_NAME_FAILED, err);
            return model;
        }
        if (![output isEqualToString:targetName]) { continue; }
        
        NSArray *outputArray = nil;
        // 获取buildConfigurationIds
        ret = [DHScriptCommand fetchProjectBuildConfigurationIdListWithXcodeprojFile:xcodeprojFile
                                                                            targetId:targetId
                                                                              output:&outputArray
                                                                               error:&err];
        if (!ret) {
            DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_TARGET_PARSE_BUILDCONFIGURATIONIDS_FAILED, err);
            return model;
        }
        
        NSArray *buildConfigurationIdList = outputArray;
        for (NSString *buildConfigurationId in buildConfigurationIdList) {
            DHBuildConfigurationModel *buildConfiguration = [self fetchBuildConfigurationWithXcodeprojFile:xcodeprojFile
                                                                                              targetName:targetName
                                                                                         configurationId:buildConfigurationId
                                                                                                   error:&err];
            if (err) {
                DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_TARGET_PARSE_BUILDCONFIGURATIONS_FAILED, err);
                return model;
            }
            
            if (![buildConfiguration.name isEqualToString:configurationName]) { continue; }
            
            model = buildConfiguration;
            break;
        }
        
        break;
    }
    
    return model;
}

/// 组装描述文件信息
+ (DHProfileModel *)fetchProfileWithProfile:(NSString *)profile
                                    error:(NSError **)error {
    if (![DHPathUtils isProfile:profile]) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_MOBILEPROVISION_INVALID, @".mobileprovision路径异常");
        return nil;
    }
    DHProfileModel *model = [[DHProfileModel alloc] init];
    model.profilePath = profile;
    
    
    BOOL ret = NO;
    NSString *output = nil;
    NSError *err;
    // 获取名称
    ret = [DHScriptCommand fetchProfileNameWithProfile:profile
                                                output:&output
                                                 error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_NAME_FAILED, err);
        return model;
    }
    model.name = output;
    
    // 获取Bundle id
    ret = [DHScriptCommand fetchProfileBundleIdentifierWithProfile:profile
                                                            output:&output
                                                             error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_BUNDLEID_FAILED, err);
        return model;
    }
    model.bundleId = output;
    
    // 获取app id
    ret = [DHScriptCommand fetchProfileAppIdentifierWithProfile:profile
                                                         output:&output
                                                          error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_APPID_FAILED, err);
        return model;
    }
    model.appId = output;
    
    // 获取team id
    ret = [DHScriptCommand fetchProfileTeamIdentifierWithProfile:profile
                                                          output:&output
                                                           error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_TEAMID_FAILED, err);
        return model;
    }
    model.teamId = output;
    
    // 获取team name
    ret = [DHScriptCommand fetchProfileTeamNameWithProfile:profile
                                                  output:&output
                                                   error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_TEAMNAME_FAILED, err);
        return model;
    }
    model.teamName = output;
    
    // 获取uuid
    ret = [DHScriptCommand fetchProfileUUIDWithProfile:profile
                                              output:&output
                                               error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_UUID_FAILED, err);
        return model;
    }
    model.uuid = output;
    
    // 获取createTimestamp
    ret = [DHScriptCommand fetchProfileCreateTimestampWithProfile:profile
                                                         output:&output
                                                          error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_CREATED_TIMESTAMP_FAILED, err);
        return model;
    }
    model.createTimestamp = output;
    
    // 获取ExpireTimestamp
    ret = [DHScriptCommand fetchProfileExpireTimestampWithProfile:profile
                                                         output:&output
                                                          error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_EXPIRE_TIMESTAMP_FAILED, err);
        return model;
    }
    model.expireTimestamp = output;
    
    // 渠道类型
    DHChannel outputChannel;
    ret = [DHScriptCommand fetchProfileChannelWithProfile:profile
                                                 output:&outputChannel
                                                  error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_CHANNEL_FAILED, err);
        return model;
    }
    model.channel = outputChannel;
    
    return model;
}

/// 组装Git信息
/// @param gitFile .git路径
+ (DHGitModel *)fetchGitWithGitFile:(NSString *)gitFile
                            error:(NSError **)error {
    if (![DHPathUtils isGitFile:gitFile]) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_GIT_INVALID, @".git路径异常");
        return nil;
    }
    NSString *gitDirectory = [gitFile stringByDeletingLastPathComponent];
    DHGitModel *model = [[DHGitModel alloc] init];
    model.gitFile = gitFile;
    
    BOOL ret = NO;
    NSString *output = nil;
    NSError *err;
    
    // 获取当前分支
    ret = [DHScriptCommand gitCurrentBranchWithGitDirectory:gitDirectory
                                                        output:&output
                                                         error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_GIT_PARSE_CURRENT_BRANCH_FAILD, err);
        return model;
    }
    model.currentBranch = output;
    
    // 获取所有分支名
    NSArray *outputArray = nil;
    ret = [DHScriptCommand fetchGitBranchListWithGitDirectory:gitDirectory
                                                         output:&outputArray
                                                          error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_GIT_PARSE_BRANCHS_FAILD, err);
        return model;
    }
    
    NSMutableArray *branchs = [NSMutableArray arrayWithCapacity:outputArray.count];
    // 剔除 * or remotes/
    for (NSString *item in outputArray) {
        NSString *temp = [item stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"*"]];
        temp = [temp stringByReplacingOccurrencesOfString:@"remotes/" withString:@""];
        temp = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [branchs addObject:temp];
    }
    model.branchs = [branchs copy];
    
    // 获取所有Tag
    ret = [DHScriptCommand fetchGitTagListWithGitDirectory:gitDirectory
                                                     output:&outputArray
                                                      error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_GIT_PARSE_TAGS_FAILD, err);
        return model;
    }
    model.tags = outputArray;
    
    return model;
}

/// 组装Podfile信息
/// @param podfile Podfile路径
+ (DHPodModel *)fetchPodWithPodfile:(NSString *)podfile
                            error:(NSError **)error {
    if (![DHPathUtils isPodfileFile:podfile]) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PODFILE_INVALID, @"Podfile路径异常");
        return nil;
    }
    DHPodModel *model = [[DHPodModel alloc] init];
    model.podfilePath = podfile;
    return model;
}

/// 组装Archive信息
/// @param xcarchiveFile .xcarchiveFile路径
+ (DHArchiveModel *)fetchArchiveWithXcarchiveFile:(NSString *)xcarchiveFile
                                          error:(NSError **)error {
    if (![DHPathUtils isXcarchiveFile:xcarchiveFile]) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_XCARCHIVE_INVALID, @".xcarchive路径异常");
        return nil;
    }
    DHArchiveModel *model = [[DHArchiveModel alloc] init];
    model.xcarchiveFile = xcarchiveFile;
    
    NSString *appFile = [DHPathUtils findApp:xcarchiveFile];
    NSError *err;
    DHAppModel *app = [self fetchAppWithAppFile:appFile
                                        error:&err];
    if (err) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_ARCHIVE_PARSE_APP_FAILED, err);
        return model;
    }
    model.app = app;
    
    return model;
}

/// 组装IPA信息
/// @param ipaFile .ipa路径
+ (DHIPAModel *)fetchIPAWithIPAFile:(NSString *)ipaFile
                            error:(NSError **)error {
    if (![DHPathUtils isIPAFile:ipaFile]) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_IPA_INVALID, @".ipa路径异常");
        return nil;
    }
    DHIPAModel *model = [[DHIPAModel alloc] init];
    model.ipaFile = ipaFile;
    
    // 解压得到.app文件路径
    NSString *unzippedPath;
    NSString *appFile = [DHPathUtils getAppFileWithIPAFile:ipaFile
                                            unzippedPath:&unzippedPath];
    if (!appFile) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_IPA_NOT_FOUND_APP, @".ipa解压后异常或者无法找到.app文件");
        if (unzippedPath) { [DHPathTools removePath:unzippedPath]; }
        return model;
    }
    NSError *err;
    DHAppModel *app = [self fetchAppWithAppFile:appFile
                                        error:&err];
    if (err) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_IPA_PARSE_APP_FAILED, err);
        if (unzippedPath) { [DHPathTools removePath:unzippedPath]; }
        return model;
    }
    
    model.app = app;
    if (unzippedPath) { [DHPathTools removePath:unzippedPath]; }
    return model;
}

/// 组装App信息
/// @param appFile .app路径
+ (DHAppModel *)fetchAppWithAppFile:(NSString *)appFile
                            error:(NSError **)error {
    if (![DHPathUtils isAppFile:appFile]) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_APP_INVALID, @".ipa路径异常");
        return nil;
    }
    DHAppModel *model = [[DHAppModel alloc] init];
    model.appFile = appFile;
    
    NSString *infoPlist = [DHPathUtils getInfoPlistFileWithAppFile:appFile];
    NSString *embeddedProfile = [DHPathUtils getEmbeddedProvisionFileWithAppFile:appFile];
    
    BOOL ret = NO;
    NSString *output = nil;
    NSError *err;
    
    // 获取显示名称
    ret = [DHScriptCommand fetchInfoPlistDisplayNameWithInfoPlist:infoPlist
                                                           output:&output
                                                            error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_APP_PARSE_DISPLAY_NAME_FAILED, err);
        return model;
    }
    model.displayName = output;
    
    // 获取产品名称
    ret = [DHScriptCommand fetchInfoPlistProductNameWithInfoPlist:infoPlist
                                                           output:&output
                                                            error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_APP_PARSE_PRODUCT_NAME_FAILED, err);
        return model;
    }
    model.productName = output;
    
    // 获取bundleId
    ret = [DHScriptCommand fetchInfoPlistBundleIdentifierWithInfoPlist:infoPlist
                                                output:&output
                                                 error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_APP_PARSE_BUNDLEID_FAILED, err);
        return model;
    }
    model.bundleId = output;
    
    // 获取版本号
    ret = [DHScriptCommand fetchInfoPlistShortVersionWithInfoPlist:infoPlist
                                               output:&output
                                                error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_APP_PARSE_VERSION_FAILED, err);
        return model;
    }
    model.version = output;
    
    // 获取子版本号
    ret = [DHScriptCommand fetchInfoPlistBuildVersionWithInfoPlist:infoPlist
                                                    output:&output
                                                     error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_APP_PARSE_BUILDVERSION_FAILED, err);
        return model;
    }
    model.buildVersion = output;
    
    // 获取可执行文件
    ret = [DHScriptCommand fetchInfoPlistExecutableFileWithInfoPlist:infoPlist
                                                              output:&output
                                                               error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_APP_PARSE_EXECUTABLE_FILE_FAILED, err);
        return model;
    }
    // 相对路径=>绝对路径
    NSString *executableReleativeFile = output;
    NSString *executableFile = [DHPathUtils getExecutableFileWithAppFile:appFile relativeExecutableFile:executableReleativeFile];
    model.executableFile = executableFile;
    
    // 获取 enable bitcode
    ret = [DHScriptCommand fetchAppEnableBitcodeWithExecutableFile:executableFile
                                                            output:&output
                                                             error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_APP_PARSE_ENABLEBITCODE_FAILED, err);
        return model;
    }
    model.enableBitcode = output;
    
    // 获取profile
    model.embeddedProfile = [self fetchProfileWithProfile:embeddedProfile
                                                  error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_APP_PARSE_EMBEDDED_PROFILE_FAILED, err);
        return model;
    }
    
    return model;
}

+ (id<DHDistributionProtocol>)fetchDistributeWithPlatform:(DHDistributionPlatform)platform {
    if ([platform isEqualToString:kDHDistributionPlatformFir]) {
        return [[DHDistributionFirModel alloc] init];
    } else if ([platform isEqualToString:kDHDistributionPlatformPgyer]) {
        return [[DHDistributionPgyerModel alloc] init];
    }
    return [[DHDistributionModel alloc] init];
}

@end
