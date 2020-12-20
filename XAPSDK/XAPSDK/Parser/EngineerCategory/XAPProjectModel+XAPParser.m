//
//  XAPProjectModel+XAPParser.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPProjectModel+XAPParser.h"
#import <objc/runtime.h>
#import "XAPEngineerModel.h"
#import "XAPTargetModel.h"
#import "XAPBuildConfigurationModel.h"
#import "XAPInfoPlistTools.h"
#import "XAPInfoPlistModel.h"
#import "XAPBuildConfigurationListModel.h"
#import "XAPGitModel.h"
#import "XAPPodModel.h"

@implementation XAPProjectModel (XAPParser)

- (id<XAPChainOfResponsibilityProtocol>)nextHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNextHandler:(id<XAPChainOfResponsibilityProtocol>)nextHandler {
    objc_setAssociatedObject(self, @selector(nextHandler), nextHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)handlePath:(NSString *)path externalInfo:(NSDictionary *)externalInfo error:(NSError *__autoreleasing  _Nullable *)error {
    if (![XAPTools isXcodeprojFile:path]) {
        return [self.nextHandler handlePath:path externalInfo:externalInfo error:error];
    }
    
    XAPEngineerModel *engineer = [self parseEngineerWithXcodeprojFile:path externalInfo:externalInfo];
    return engineer;
}


#pragma mark - parser method
- (XAPEngineerModel *)parseEngineerWithXcodeprojFile:(NSString *)xcodeprojFile externalInfo:(NSDictionary *)externalInfo {
    XAPProjectModel *project = [self parseProjectWithXcodeprojFile:xcodeprojFile];
    if (!project) {
        return nil;
    }
    
    XAPEngineerModel *engineer = [[XAPEngineerModel alloc] init];
    engineer.project = project;
    // 解析后的git
    if ([[externalInfo objectForKey:kXAPChainOfResponsibilityExternalKeyGit] isKindOfClass:[XAPGitModel class]]) {
        engineer.git = [externalInfo objectForKey:kXAPChainOfResponsibilityExternalKeyGit];
    }
    // 解析后的pod
    if ([[externalInfo objectForKey:kXAPChainOfResponsibilityExternalKeyPod] isKindOfClass:[XAPPodModel class]]) {
        engineer.pod = [externalInfo objectForKey:kXAPChainOfResponsibilityExternalKeyPod];
    }
    return engineer;
}

- (XAPProjectModel *)parseProjectWithXcodeprojFile:(NSString *)xcodeprojFile {
    if (![XAPTools isXcodeprojFile:xcodeprojFile]) {
        return nil;
    }
    
    NSString *pbxprojFile = [XAPTools pbxprojFileWithXcodeprojFile:xcodeprojFile];
    NSData *pbxprojData = [NSData dataWithContentsOfFile:pbxprojFile];
    NSError *error;
    
    // 所有字段基于此字典进行查找
    NSDictionary *pbxprojDictionary = [NSPropertyListSerialization propertyListWithData:pbxprojData
                                                                                options:NSPropertyListMutableContainersAndLeaves
                                                                                 format:nil
                                                                                  error:&error];
    if (error) {
        return nil;
    }
    
    XAPProjectModel *projectModel = [[XAPProjectModel alloc] init];
    projectModel.xcodeprojFilePath = xcodeprojFile;
    projectModel.pbxprojFilePath = pbxprojFile;
    // pbxproj文件结构是基于key-value的格式进行编码的，入口为rootObject
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
    // Target查找
    NSArray *targetIds = projectDictionary[@"targets"];
    NSMutableArray *targetModels = [NSMutableArray arrayWithCapacity:targetIds.count];
    for (NSString *targetId in targetIds) {
        NSDictionary *targetDictionary = pbxprojDictionary[targetId];
        NSString *name = targetDictionary[@"name"];
        NSString *targetBuildConfigurationListId = targetDictionary[@"buildConfigurationList"];
        
        XAPTargetModel *targetModel = [[XAPTargetModel alloc] init];
        targetModel.name = name;
        targetModel.identifier = targetId;
        // Target配置
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

@end
