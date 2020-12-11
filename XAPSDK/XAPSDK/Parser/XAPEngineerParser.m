//
//  XAPEngineerParser.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/10.
//

#import "XAPEngineerParser.h"
#import "XAPWorkspaceModel.h"
#import "XAPProjectModel.h"
#import "XAPTargetModel.h"
#import "XAPBuildConfigurationListModel.h"
#import "XAPBuildConfigurationModel.h"
#import "XAPInfoPlistModel.h"
#import "XAPInfoPlistTools.h"
#import "XAPProvisioningProfileManager.h"
#import "XAPProvisioningProfileModel.h"
#import "XAPPodModel.h"
#import "XAPScriptor.h"
#import "XAPGitModel.h"
#import "XAPAppModel.h"

@implementation XAPEngineerParser

+ (instancetype)sharedParser {
    static XAPEngineerParser *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XAPEngineerParser alloc] init];
    });
    return _instance;
}

- (XAPWorkspaceModel *)parseWorkspaceWithXcworkspaceFile:(NSString *)xcworkspaceFile {
    if (![XAPTools isXcworkspaceFile:xcworkspaceFile]) {
        return nil;
    }
    
    // 关联工程
    NSArray *relateXcodeprojFiles = [XAPTools xcodeprojFilesWithWorkspaceFile:xcworkspaceFile];
    if (![XAPTools isValidArray:relateXcodeprojFiles]) {
        return nil;
    }
    NSMutableArray *projects = [NSMutableArray arrayWithCapacity:relateXcodeprojFiles.count];
    for (NSString *xcodeprojFile in relateXcodeprojFiles) {
        XAPProjectModel *project = [self parseProjectWithXcodeprojFile:xcodeprojFile];
        [projects addObject:project];
    }
    
    XAPWorkspaceModel *workspace = [[XAPWorkspaceModel alloc] init];
    workspace
}

- (XAPProjectModel *)parseProjectWithXcodeprojFile:(NSString *)xcodeprojFile {
    if (![XAPTools isXcodeprojFile:xcodeprojFile]) {
        return nil;
    }
    
    NSString *pbxprojFile = [XAPTools pbxprojFileWithXcodeprojFile:xcodeprojFile];
    NSData *pbxprojData = [NSData dataWithContentsOfFile:pbxprojFile];
    NSError *error;
    
    // 所有字段基于此字典进行查找
    NSDictionary *pbxprojDictionary = [NSPropertyListSerialization propertyListWithData:pbxprojData options:NSPropertyListMutableContainersAndLeaves format:nil error:&error];
    if (error) {
        return nil;
    }
    
    XAPProjectModel *projectModel = [[XAPProjectModel alloc] init];
    projectModel.xcodeprojFilePath = xcodeprojFile;
    projectModel.pbxprojFilePath = pbxprojFile;
    
    NSString *rootObject = pbxprojDictionary[@"rootObject"];
    NSDictionary *projectDictionary = pbxprojDictionary[rootObject];
    projectModel.identifier = rootObject;
    
    // Project的配置
    NSString *projectBuildConfigurationListId = pbxprojDictionary[@"buildConfigurationList"];
    NSDictionary *projectBuildConfigurationList = pbxprojDictionary[projectBuildConfigurationListId];
    NSArray *projectBuildConfigurationIds = projectBuildConfigurationList[@"buildConfigurations"];
    projectModel.buildConfiguraionList = [self buildConfigurationListModelWithBuildConfigurationIds:projectBuildConfigurationIds
                                                                                  pbxprojDictionary:pbxprojDictionary
                                                                                  xcodeprojFilePath:xcodeprojFile];
    
    NSArray *targetIds = projectDictionary[@"targets"];
    NSMutableArray *targetModels = [NSMutableArray arrayWithCapacity:targetIds.count];
    for (NSString *targetId in targetIds) {
        NSDictionary *targetDictionary = pbxprojDictionary[targetId];
        NSString *name = targetDictionary[@"name"];
        NSString *targetBuildConfigurationListId = targetDictionary[@"buildConfigurationList"];
        
        XAPTargetModel *targetModel = [[XAPTargetModel alloc] init];
        targetModel.name = name;
        targetModel.identifier = targetId;
        
        NSDictionary *targetConfigurationList = pbxprojDictionary[targetBuildConfigurationListId];
        NSArray *buildConfigurationIds = targetConfigurationList[@"buildConfigurations"];
        targetModel.buildConfigurationList = [self buildConfigurationListModelWithBuildConfigurationIds:buildConfigurationIds
                                                                                      pbxprojDictionary:pbxprojDictionary
                                                                                      xcodeprojFilePath:xcodeprojFile];
        [targetModels addObject:targetModel];
    }
    projectModel.targets = targetModels;
    
    return projectModel;
}

- (XAPBuildConfigurationListModel *)buildConfigurationListModelWithBuildConfigurationIds:(NSArray *)buildConfigurationIds
                                                                       pbxprojDictionary:(NSDictionary *)pbxprojDictionary
                                                                       xcodeprojFilePath:(NSString *)xcodeprojFilePath {
    XAPBuildConfigurationListModel *projectBuildConfigurationListModel = [[XAPBuildConfigurationListModel alloc] init];
    NSMutableArray *buildConfigurationModels = [NSMutableArray arrayWithCapacity:2];
    for (NSString *buildConfigurationId in buildConfigurationIds) {
        NSDictionary *buildConfiguration = pbxprojDictionary[buildConfigurationId];
        NSString *buildConfigurationName = buildConfiguration[@"name"];
        NSDictionary *buildSettings = buildConfiguration[@"buildSettings"];
        NSString *infoPlistFile = buildSettings[@"INFOPLIST_FILE"];
        
        XAPBuildConfigurationModel *buildConfigurationModel = [[XAPBuildConfigurationModel alloc] init];
        buildConfigurationModel.identifier = buildConfigurationId;
        buildConfigurationModel.name = buildConfigurationName;
        buildConfigurationModel.buildSettings = buildSettings;
        if (infoPlistFile) {
            XAPInfoPlistModel *infoPlistModel = [self infoPlistModelWithXcodeprojFilePath:xcodeprojFilePath
                                                                             relativePath:infoPlistFile];
            buildConfigurationModel.infoPlist = infoPlistModel;
        }
        [buildConfigurationModels addObject:buildConfigurationModel];
    }
    projectBuildConfigurationListModel.buildConfigurations = buildConfigurationModels;
    return projectBuildConfigurationListModel;
}

- (XAPInfoPlistModel *)infoPlistModelWithXcodeprojFilePath:(NSString *)xcodeprojFilePath
                                              relativePath:(NSString *)relativePath {
    XAPInfoPlistModel *infoPlistModel = [[XAPInfoPlistModel alloc] init];
    NSString *infoPlistPath = [XAPTools absolutePathWithXcodeprojFile:xcodeprojFilePath relativePath:relativePath];
    NSString *displayName;
    NSString *productName;
    NSString *bundleIdentifier;
    NSString *version;
    NSString *shortVersion;
    NSString *executableFile;
    [XAPInfoPlistTools parseProjectOrAppInfoPlistFileWithPlistFileOrDictionary:infoPlistPath
                                                                   displayName:&displayName
                                                                   productName:&productName
                                                              bundleIdentifier:&bundleIdentifier
                                                                  shortVersion:&shortVersion
                                                                       version:&version
                                                                executableFile:&executableFile];
    infoPlistModel.bundleIdentifier = bundleIdentifier;
    infoPlistModel.bundleName = productName;
    infoPlistModel.bundleDisplayName = displayName;
    infoPlistModel.bundleVersion = version;
    infoPlistModel.bundleShortVersion = shortVersion;
    infoPlistModel.executableFile = executableFile;
    return infoPlistModel;
}

- (XAPInfoPlistModel *)infoPlistModelWithXcarchiveFilePath:(NSString *)xcarchiveFilePath {
    XAPInfoPlistModel *infoPlistModel = [[XAPInfoPlistModel alloc] init];
    NSString *infoPlistFile = [XAPTools infoPlistFileWithXcarchiveFile:xcarchiveFile];
    NSString *schemeName;
    NSString *bundleIdentifier;
    NSString *version;
    NSString *shortVersion;
    [XAPInfoPlistTools parseXcarchiveInfoPlistWithPlistFileOrDictionary:infoPlistFile name:nil
                                                             schemeName:&schemeName
                                                           creationDate:nil
                                                        applicationPath:nil
                                                       bundleIdentifier:&bundleIdentifier
                                                         teamIdentifier:nil
                                                           shortVersion:&shortVersion
                                                                version:&version
                                                          architectures:nil
                                                        signingIdentity:nil];
    infoPlistModel.bundleIdentifier = bundleIdentifier;
    infoPlistModel.bundleName = schemeName;
    infoPlistModel.bundleVersion = version;
    infoPlistModel.bundleShortVersion = shortVersion;
    return infoPlistModel;
}


- (XAPIPAModel *)parseIPAWithIPAFile:(NSString *)ipaFile {
    
}

- (XAPArchiveModel *)parseArchiveWithXcarchiveFile:(NSString *)xcarchiveFile {
    if (![XAPTools isXcarchiveFile:xcarchiveFile]) {
        return nil;
    }
    
    NSString *infoPlistFile = [XAPTools infoPlistFileWithXcarchiveFile:xcarchiveFile];
    NSString *appFile = [XAPTools appFileWithXcarchiveFile:xcarchiveFile];
    
}

- (XAPAppModel *)parseAppWithAppFile:(NSString *)appFile {
    if (![XAPTools isAppFile:appFile]) {
        return nil;
    }
    
}

- (XAPGitModel *)parseGitWithGitFile:(NSString *)gitFile {
    if (![XAPTools isGitFile:gitFile]) {
        return nil;
    }
    NSString *gitDirectory = [XAPTools directoryPathWithFilePath:gitFile];
    XAPScriptor *scriptor = [XAPScriptor sharedInstance];
    NSError *error;
    
    NSString *currentBranch = [scriptor gitCurrentBranchWithGitDirectory:gitDirectory error:&error];
    if (error) {
        return nil;
    }
    
    NSArray *branchs = [scriptor fetchGitBranchsWithGitDirectory:gitDirectory error:&error];
    if (error) {
        return nil;
    }
    
    XAPGitModel *git = [[XAPGitModel alloc] init];
    git.gitFilePath = gitFile;
    git.currentBranch = currentBranch;
    git.branchs = branchs;
    
    return git;
}

- (XAPPodModel *)parsePodWithPodFile:(NSString *)podFile {
    if (![XAPTools isPodfileFile:podFile]) {
        return nil;
    }
    XAPPodModel *podModel = [[XAPPodModel alloc] init];
    podModel.podfileFilePath = podFile;
    return podModel;
}

@end