//
//  XAPDirectoryParser.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPDirectoryParser.h"
#import "XAPWorkspaceModel+XAPParser.h"
#import "XAPProjectModel+XAPParser.h"
#import "XAPIPAModel+XAPParser.h"
#import "XAPArchiveModel+XAPParser.h"
#import "XAPPathParser.h"

@implementation XAPDirectoryParser

- (id)handlePath:(NSString *)path externalInfo:(NSDictionary *)externalInfo error:(NSError *__autoreleasing  _Nullable *)error {
    if (![XAPTools isDirectoryPath:path]) {
        return nil;
    }
    
    id result = [self parseDirectoryWithPath:path];
    return result;
}


#pragma mark - parser method
- (id)parseDirectoryWithPath:(NSString *)path {
    // 解析文档路径下的文件
    NSArray *subpaths = [XAPTools absoluteSubpathsOfDirectory:path];
    __block NSString *gitFile;
    __block NSString *podFile;
    __block NSString *workspaceFile;
    __block NSString *projectFile;
    __block NSString *archiveFile;
    __block NSString *ipaFile;
    
    // TODO: 以后再考虑给文档路径下存在多种路径的情况
    // 优先级：xcworkspace > xcodeproj > ipa > xcarchive
    // 共存性：xcworkspace & xcodeproj & git & pod
    //       ipa & xcarchive
    [subpaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([XAPTools isXcworkspaceFile:obj]) {
            workspaceFile = obj;
        } else if ([XAPTools isXcodeprojFile:obj]) {
            projectFile = obj;
        } else if ([XAPTools isGitFile:gitFile]) {
            gitFile = obj;
        } else if ([XAPTools isPodfileFile:obj]) {
            podFile = obj;
        } else if ([XAPTools isXcarchiveFile:obj]) {
            archiveFile = obj;
        } else if ([XAPTools isIPAFile:obj]) {
            ipaFile = obj;
        }
    }];
    NSMutableDictionary *externalInfo = [NSMutableDictionary dictionary];
    if (gitFile) {
        [externalInfo setValue:gitFile forKey:kXAPChainOfResponsibilityExternalKeyGit];
    }
    if (podFile) {
        [externalInfo setValue:podFile forKey:kXAPChainOfResponsibilityExternalKeyPod];
    }
    
    XAPPathParser *pathParser = [[XAPPathParser alloc] init];
    XAPWorkspaceModel *workspaceParser = [[XAPWorkspaceModel alloc] init];
    XAPProjectModel *projectParser = [[XAPProjectModel alloc] init];
    XAPIPAModel *ipaParser = [[XAPIPAModel alloc] init];
    XAPArchiveModel *archiveParser = [[XAPArchiveModel alloc] init];
    
    pathParser.nextHandler = workspaceParser;
    workspaceParser.nextHandler = projectParser;
    projectParser.nextHandler = ipaParser;
    ipaParser.nextHandler = archiveParser;
    
    NSError *error;
    // 按照优先级解析
    NSString *directPath = workspaceFile?:projectFile?:ipaFile?:archiveFile;
    id result = [pathParser handlePath:directPath externalInfo:externalInfo error:&error];
    
    return result;
}

@end
