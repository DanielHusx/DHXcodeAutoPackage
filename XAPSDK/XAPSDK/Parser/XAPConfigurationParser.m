//
//  XAPConfigurationParser.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPConfigurationParser.h"
#import "XAPEngineerModel.h"
#import "XAPConfigurationModel.h"
#import "XAPProjectExtraConfigurationModel.h"
#import "XAPArchiveExtraConfigurationModel.h"
#import "XAPWorkspaceModel.h"
#import "XAPProjectModel.h"
#import "XAPTargetModel.h"

@implementation XAPConfigurationParser

+ (instancetype)sharedParser {
    XAPConfigurationParser *instance = [[XAPConfigurationParser alloc] init];
    return instance;
}

- (XAPConfigurationModel *)parseConfigurationWithEngineerInfo:(XAPEngineerModel *)engineerInfo
                                                        error:(NSError *__autoreleasing  _Nullable *)error {
    if (![engineerInfo isKindOfClass:[XAPEngineerModel class]]) {
        return nil;
    }
    XAPProjectExtraConfigurationModel *projectExtra;
    if (engineerInfo.workspace || engineerInfo.project) {
        projectExtra = [[XAPProjectExtraConfigurationModel alloc] init];
        projectExtra.configurationName = kXAPConfigurationNameRelease;
        projectExtra.schemeName = engineerInfo.workspace.projects.firstObject.targets.firstObject.name?:engineerInfo.project.targets.firstObject.name;
        projectExtra.gitPullIfNeed = YES;
        projectExtra.podInstallIfNeed = YES;
        projectExtra.keepXcarchiveFileIfExist = YES;
    }
    XAPArchiveExtraConfigurationModel *archiveExtra;
    if (engineerInfo.workspace || engineerInfo.project || engineerInfo.archive) {
        archiveExtra = [[XAPArchiveExtraConfigurationModel alloc] init];
        archiveExtra.channel = kXAPChannelAdHoc;
    }
    
    XAPConfigurationModel *configuration = [[XAPConfigurationModel alloc] init];
    configuration.projectExtraConfiguration = projectExtra;
    configuration.archiveExtraConfiguration = archiveExtra;
    return configuration;
}

@end
