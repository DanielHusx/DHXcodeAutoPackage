//
//  DHCoreParseGetter.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHCoreParseGetter.h"
#import "DHPathUtils.h"
#import "DHGitModel.h"
#import "DHPodModel.h"
#import "DHWorkspaceModel.h"
#import "DHProjectModel.h"
#import "DHTargetModel.h"
#import "DHProfileModel.h"
#import "DHBuildConfigurationModel.h"
#import "PBXProjectManager.h"
#import "DHArchiveModel.h"
#import "DHAppModel.h"
#import "DHIPAModel.h"
#import "DHDistributionModel.h"
#import "DHDistributionFirModel.h"
#import "DHDistributionPgyerModel.h"
#import "DHXMLUtils.h"
#import "DHXcworkspaceUtils.h"

@implementation DHCoreParseGetter

// MARK: -
// 解析项目所有信息
+ (PBXProjParser *)parseProjectWithXcodeprojFile:(NSString *)xcodeprojFile {
    if ([[[PBXProjParser sharedInstance].pbxprojPath stringByDeletingLastPathComponent] isEqualToString:xcodeprojFile]) { return [PBXProjParser sharedInstance]; }
    
    [[PBXProjParser sharedInstance] parseProjectWithPath:xcodeprojFile];
    return [PBXProjParser sharedInstance];
}

// MARK: -
+ (DHTargetModel *)fetchTargetWithXcodeprojFile:(NSString *)xcodeprojFile
                                    pbxTarget:(PBXTarget *)pbxTarget
                                        error:(NSError **)error {
    DHTargetModel *model = [[DHTargetModel alloc] init];
    model.name = [pbxTarget getName];
    
    NSArray *configurations = pbxTarget.buildConfigurationList.buildConfigurations;
    NSMutableArray *buildConfigurations = [NSMutableArray arrayWithCapacity:configurations.count];
    for (XCBuildConfiguration *item in configurations) {
        DHBuildConfigurationModel *buildConfiguration = [self fetchBuildConfigurationWithXcodeprojFile:xcodeprojFile
                                                                                          targetName:model.name
                                                                                xcbuildConfiguration:item
                                                                                               error:error];
        if (*error) { return model; }
        
        [buildConfigurations addObject:buildConfiguration];
    }
    model.buildConfigurations = buildConfigurations;
    return model;
}

+ (DHBuildConfigurationModel *)fetchBuildConfigurationWithXcodeprojFile:(NSString *)xcodeprojFile
                                                           targetName:(NSString *)targetName
                                                 xcbuildConfiguration:(XCBuildConfiguration *)xcbuildConfiguration
                                                                error:(NSError **)error {
    DHBuildConfigurationModel *model = [[DHBuildConfigurationModel alloc] init];
    // 只能从buildSettings中拿的字段
    model.name = [xcbuildConfiguration getName];
    // 此字段必然存在，但值可能为空
    model.teamId = [xcbuildConfiguration getBuildSetting:kDHBuildSettingsKeyTeamIdentifier];
    // 当buildSettings不存在该字段时（一旦存在，也必然存在值YES/NO），说明项目默认给了YES
    model.enableBitcode = [xcbuildConfiguration getBuildSetting:kDHBuildSettingsKeyEnableBitcode]?:kDHEnableBitcodeYES;
    
    // 解析info.plist绝对路径
    NSString *infoPlistRelativeFile = [xcbuildConfiguration getBuildSetting:kDHBuildSettingsKeyInfoPlistFile];
    model.infoPlistFile = [DHPathUtils getAbsolutePathWithXcodeprojFile:xcodeprojFile
                                                         relativePath:infoPlistRelativeFile];
    // 以下数据有限从info.plist中读取，然后在从关联的.pbxproj对应的字段读取
    NSString *displayName;
    NSString *productName;
    NSString *version;
    NSString *buildVersion;
    NSString *bundleId;
    BOOL ret = [DHXMLUtils readInfoPlistFile:model.infoPlistFile
                              forDisplayName:&displayName
                                 productName:&productName
                                    bundleId:&bundleId
                                     version:&version
                                buildVersion:&buildVersion
                              executableFile:nil
                             applicationPath:nil
                                      teamId:nil];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_INFOPLIST_INVALID, @"解析项目内info.plist失败");
        return model;
    }
    // info.plist中 productName可能是$(PRODUCT_NAME),则读取.pbxproj内对应的值
    if (checkPlistValueRelatived(productName)) {
        productName = [xcbuildConfiguration getBuildSetting:fetchBuildSettingsKeyWithPlistRelativeValue(productName)];
    }
    if (!productName) {
        productName = [xcbuildConfiguration getBuildSetting:kDHBuildSettingsKeyProductName];
    }
    // .pbxproj中productName可能是$(TARGET_NAME)
    if ([kDHRelativeValueTargetName isEqualToString:productName]) {
        productName = targetName;
    }
    model.productName = productName;
    
    // display name
    if (checkPlistValueRelatived(displayName)) {
        displayName = [xcbuildConfiguration getBuildSetting:fetchBuildSettingsKeyWithPlistRelativeValue(displayName)];
    }
    if (!displayName || [kDHRelativeValueTargetName isEqualToString:displayName]) {
        displayName = productName;
    }
    model.displayName = displayName;
    
    // bundle id
    if (checkPlistValueRelatived(bundleId)) {
        bundleId = [xcbuildConfiguration getBuildSetting:fetchBuildSettingsKeyWithPlistRelativeValue(bundleId)];
    }
    if (!bundleId) {
        bundleId = [xcbuildConfiguration getBuildSetting:kDHBuildSettingsKeyBundleIdentifier];
    }
    model.bundleId = bundleId;
    
    // version
    if (checkPlistValueRelatived(version)) {
        version = [xcbuildConfiguration getBuildSetting:fetchBuildSettingsKeyWithPlistRelativeValue(version)];
    }
    if (!version) {
        version = [xcbuildConfiguration getBuildSetting:kDHBuildSettingsKeyVersion];
    }
    model.shortVersion = version;
    
    // build version
    if (checkPlistValueRelatived(buildVersion)) {
        buildVersion = [xcbuildConfiguration getBuildSetting:fetchBuildSettingsKeyWithPlistRelativeValue(buildVersion)];
    }
    if (!buildVersion) {
        buildVersion = [xcbuildConfiguration getBuildSetting:kDHBuildSettingsKeyBuildVersion];
    }
    model.buildVersion = buildVersion;
    
    return model;
}

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
    NSArray *xcodeprojFiles = [DHXcworkspaceUtils getXcodeprojFilesWithWorkspaceFile:xcworkspaceFile];
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
    
    PBXProjParser *parser = [self parseProjectWithXcodeprojFile:xcodeprojFile];
    if (!parser.project) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_XCODEPROJ_PARSE_FAILED, @"解析.xcodeproj失败");
        return model;
    }
    
    PBXProject *project = parser.project;
    NSMutableArray *targets = [[NSMutableArray alloc] initWithCapacity:project.targets.count];
    for (PBXTarget *item in project.targets) {
        DHTargetModel *target = [self fetchTargetWithXcodeprojFile:xcodeprojFile
                                                      targetName:[item getName]
                                                           error:error];
        
        if (*error) { return model; }
        
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
/// @param targetName scheme
+ (DHTargetModel *)fetchTargetWithXcodeprojFile:(NSString *)xcodeprojFile
                                   targetName:(NSString *)targetName
                                        error:(NSError **)error {
    if (![DHPathUtils isXcodeprojFile:xcodeprojFile]) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_XCODEPROJ_INVALID, @".xcodeproj路径异常");
        return nil;
    }
    PBXProjParser *parser = [self parseProjectWithXcodeprojFile:xcodeprojFile];
    if (!parser.project) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_XCODEPROJ_PARSE_FAILED, @"解析.xcodeproj失败");
        return nil;
    }
    DHTargetModel *model = nil;
    
    PBXProject *project = parser.project;
    
    // 匹配
    for (PBXTarget *item in project.targets) {
        if (![[item getName] isEqualToString:targetName]) { continue; }
        
        DHTargetModel *target = [self fetchTargetWithXcodeprojFile:xcodeprojFile
                                                       pbxTarget:item
                                                           error:error];
        // 不管对错，赋值即可，上层自会对error处理
        model = target;
        break;
    }
    
    return model;
}

/// 组装Target配置信息
/// @param xcodeprojFile 项目文件(.xcodeproj)
/// @param targetName scheme
/// @param configurationName Debug/Release
+ (DHBuildConfigurationModel *)fetchBuildConfigurationWithXcodeprojFile:(NSString *)xcodeprojFile
                                                           targetName:(NSString *)targetName
                                                    configurationName:(DHConfigurationName)configurationName
                                                                error:(NSError **)error {
    [self parseProjectWithXcodeprojFile:xcodeprojFile];
    DHBuildConfigurationModel *model = nil;
    
    PBXProject *project = [PBXProjParser sharedInstance].project;
    // 匹配scheme
    for (PBXTarget *item in project.targets) {
        if (![item.getName isEqualToString:targetName]) { continue; }
        // 匹配Debug/Release
        for (XCBuildConfiguration *configuration in item.buildConfigurationList.buildConfigurations) {
            if (![[configuration getName] isEqualToString:configurationName]) { continue; }
            
            DHBuildConfigurationModel *buildConfiguration = [self fetchBuildConfigurationWithXcodeprojFile:xcodeprojFile
                                                                                              targetName:targetName
                                                                                    xcbuildConfiguration:configuration
                                                                                                   error:error];
            // 不管对错，赋值即可，上层自会对error处理
            model = buildConfiguration;
            break;
        }
        
        break;
    }
    
    return model;
}

@end

#pragma mark -
@implementation DHCoreParseGetter (DHUnsupport)
/// 组装描述文件信息
+ (DHProfileModel *)fetchProfileWithProfile:(NSString *)profile
                                    error:(NSError **)error {
    NSAssert(NO, @"此方法不支持，请使用DHDBScriptFactory类对应方法");
    return nil;
}

/// 组装Git信息
/// @param gitFile .git路径
+ (DHGitModel *)fetchGitWithGitFile:(NSString *)gitFile
                            error:(NSError **)error {
    NSAssert(NO, @"此方法不支持，请使用DHDBScriptFactory类对应方法");
    return nil;
}

/// 组装Podfile信息
/// @param podfile Podfile路径
+ (DHPodModel *)fetchPodWithPodfile:(NSString *)podfile
                            error:(NSError **)error {
    NSAssert(NO, @"此方法不支持，请使用DHDBScriptFactory类对应方法");
    return nil;
}


/// 组装Archive信息
/// @param xcarchiveFile .xcarchiveFile路径
+ (DHArchiveModel *)fetchArchiveWithXcarchiveFile:(NSString *)xcarchiveFile
                                          error:(NSError **)error {
    NSAssert(NO, @"此方法不支持，请使用DHDBScriptFactory类对应方法");
    return nil;
}

/// 组装IPA信息
/// @param ipaFile .ipa路径
+ (DHIPAModel *)fetchIPAWithIPAFile:(NSString *)ipaFile
                            error:(NSError **)error {
    NSAssert(NO, @"此方法不支持，请使用DHDBScriptFactory类对应方法");
    return nil;
}

/// 组装App信息
/// @param appFile .app路径
+ (DHAppModel *)fetchAppWithAppFile:(NSString *)appFile
                            error:(NSError **)error {
    NSAssert(NO, @"此方法不支持，请使用DHDBScriptFactory类对应方法");
    return nil;
}

/// 获取初始化的发布信息
/// @param platform 平台类型
+ (id<DHDistributionProtocol>)fetchDistributeWithPlatform:(DHDistributionPlatform)platform {
    NSAssert(NO, @"此方法不支持，请使用DHDBScriptFactory类对应方法");
    return nil;
}

@end
