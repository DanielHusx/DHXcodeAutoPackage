//
//  XAPWorkspaceModel+XAPParser.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPWorkspaceModel+XAPParser.h"
#import <objc/runtime.h>
#import "XAPProjectModel+XAPParser.h"
#import "XAPEngineerModel.h"
#import "XAPGitModel.h"
#import "XAPPodModel.h"

@implementation XAPWorkspaceModel (XAPParser)

- (id<XAPChainOfResponsibilityProtocol>)nextHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNextHandler:(id<XAPChainOfResponsibilityProtocol>)nextHandler {
    objc_setAssociatedObject(self, @selector(nextHandler), nextHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)handlePath:(NSString *)path externalInfo:(NSDictionary *)externalInfo error:(NSError *__autoreleasing  _Nullable *)error {
    if (![XAPTools isXcworkspaceFile:path]) {
        return [self.nextHandler handlePath:path externalInfo:externalInfo error:error];
    }
    
    XAPEngineerModel *engineer = [self parseEngineerWithXcworkspaceFile:path externalInfo:externalInfo];
    return engineer;
}


#pragma mark - parse method
- (XAPEngineerModel *)parseEngineerWithXcworkspaceFile:(NSString *)xcworkspaceFile externalInfo:(NSDictionary *)externalInfo {
    XAPWorkspaceModel *workspace = [self parseWorkspaceWithXcworkspaceFile:xcworkspaceFile];
    if (!workspace) {
        return nil;
    }
    XAPEngineerModel *engineer = [[XAPEngineerModel alloc] init];
    engineer.workspace = workspace;
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
    workspace.xcworkspaceFilePath = xcworkspaceFile;
    workspace.projects = projects;
    return workspace;
}

- (XAPProjectModel *)parseProjectWithXcodeprojFile:(NSString *)xcodeprojFile {
    XAPProjectModel *parser = [[XAPProjectModel alloc] init];
    NSError *error;
    id result = [parser handlePath:xcodeprojFile externalInfo:nil error:&error];
    
    if ([result isKindOfClass:[XAPEngineerModel class]]) {
        return ((XAPEngineerModel *)result).project;
        
    } else if ([result isKindOfClass:[XAPProjectModel class]]) {
        return result;
        
    }
    
    return nil;
}

@end
