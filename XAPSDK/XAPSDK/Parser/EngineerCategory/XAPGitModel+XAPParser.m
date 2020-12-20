//
//  XAPGitModel+XAPParser.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPGitModel+XAPParser.h"
#import <objc/runtime.h>
#import "XAPScriptor.h"
#import "XAPEngineerModel.h"

@implementation XAPGitModel (XAPParser)

- (id<XAPChainOfResponsibilityProtocol>)nextHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNextHandler:(id<XAPChainOfResponsibilityProtocol>)nextHandler {
    objc_setAssociatedObject(self, @selector(nextHandler), nextHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)handlePath:(NSString *)path externalInfo:(NSDictionary *)externalInfo error:(NSError *__autoreleasing  _Nullable *)error {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:externalInfo];
    if (externalInfo) {
        id gitInfo = externalInfo[kXAPChainOfResponsibilityExternalKeyGit];
        // 如果gitInfo为字符串则是.git的路径；如果是此类，则是已经解析的git信息；其他情况，搞错信息，则移除校正
        if ([gitInfo isKindOfClass:[NSString class]]) {
            if (![XAPTools isGitFile:gitInfo]) {
                // TODO: 暴露路径错误信息
                [result removeObjectForKey:kXAPChainOfResponsibilityExternalKeyGit];
            } else {
                // 解析
                XAPGitModel *git = [self parseGitWithGitFile:gitInfo];
                [result setValue:git forKey:kXAPChainOfResponsibilityExternalKeyGit];
            }
        } else if (![gitInfo isKindOfClass:[self class]]) {
            // 未知错误信息被赋值，移除
            [result removeObjectForKey:kXAPChainOfResponsibilityExternalKeyGit];
        }
    }
    return [self.nextHandler handlePath:path externalInfo:result error:error];
}


#pragma mark - parser method
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

@end
