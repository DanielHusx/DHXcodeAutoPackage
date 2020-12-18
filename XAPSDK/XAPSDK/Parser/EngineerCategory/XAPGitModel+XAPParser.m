//
//  XAPGitModel+XAPParser.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import "XAPGitModel+XAPParser.h"
#import <objc/runtime.h>
#import "XAPScriptor.h"

@implementation XAPGitModel (XAPParser)

- (id<XAPChainOfResponsibilityProtocol>)nextHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNextHandler:(id<XAPChainOfResponsibilityProtocol>)nextHandler {
    objc_setAssociatedObject(self, @selector(nextHandler), nextHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XAPEngineerModel *)handlePath:(NSString *)path error:(NSError * __autoreleasing _Nullable * _Nullable)error {
    if (![XAPTools isGitFile:path]) {
        return [self.nextHandler handlePath:path error:error];
    }
    return nil;
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
