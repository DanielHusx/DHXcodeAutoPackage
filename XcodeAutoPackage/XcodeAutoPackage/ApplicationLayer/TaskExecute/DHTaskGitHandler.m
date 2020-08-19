//
//  DHTaskGitHandler.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/18.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskGitHandler.h"
#import "DHTaskModel.h"
#import <DHXcodeSDK/DHXcodeSDK.h>

@interface DHTaskGitHandler ()
/// 中断标记
@property (nonatomic, assign, getter=isInterrupt) BOOL interrupt;
/// 任务执行时间
@property (nonatomic, assign) CFAbsoluteTime startTime;
/// 任务结束时间
@property (nonatomic, assign) CFAbsoluteTime endTime;

@end

@implementation DHTaskGitHandler

+ (BOOL)checkTaskHandleable:(DHTaskModel *)task {
    if (task.gitFile) { return YES; }
    return NO;
}

- (BOOL)isTaskHandlerExecutable:(DHTaskModel *)task {
    DHLogInfo(@"正在校验git配置");
    if ([DHPathUtils isGitFile:task.gitFile]) {
        DHLogInfo(@"校验git配置完成");
        return YES;
    }
    if (task.isForceGitSwitch || task.isNeedGitPull) {
        DHLogError(@"git路径不存在: %@", task.gitFile);
        return NO;
    }
    // 不需要强制切换分支或者更新分支，那么只需要警告，不影响主流程
    DHLogWarning(@"git路径不存在: %@", task.gitFile);
    return YES;
}

- (BOOL)handleTask:(DHTaskModel *)task progress:(nonnull void (^)(NSProgress * _Nonnull))progress {
    _startTime = CFAbsoluteTimeGetCurrent();
    DHLogInfo(@"Running %@ | ***正在执行git任务***", task.taskName);
    int64_t pieceUnitCount = [DHTaskGitHandler pieceOfUnitCount];
    uint64_t totalUnitCount = [DHTaskGitHandler totalUnitCount];
    NSProgress *internalProgress = [NSProgress progressWithTotalUnitCount:totalUnitCount];
    if (progress) { progress(internalProgress); }
    if ([self checkInterrupt]) { return NO; }
    
    // 无需进行git处理
    if (!task.isForceGitSwitch && !task.isNeedGitPull) {
        [internalProgress setCompletedUnitCount:totalUnitCount];
        if (progress) { progress(internalProgress); }
        DHLogInfo(@"Running %@ | ***git任务完成***", task.taskName);
        if ([self checkInterrupt]) { return NO; }
        return YES;
    }
    
    NSString *gitFile = task.gitFile;
    NSString *gitDirectory = [DHPathUtils getGitDirectoryWithGitFile:gitFile];
    NSError *error;
    BOOL ret = NO;
    
    if ([self checkInterrupt]) { return NO; }
    
    // 强制切换分支
    if (task.isForceGitSwitch) {
        NSString *destinationBranch = task.currentBranch;
        if (![DHCommonTools isValidString:destinationBranch]) {
            DHLogError(@"目标分支信息异常: %@", destinationBranch);
            _endTime = CFAbsoluteTimeGetCurrent();
            return NO;
        }
        if ([self checkInterrupt]) { return NO; }
        
        DHLogInfo(@"正在获取当前git最新信息");
        // 之前保存的信息可能已经过期，需要获取最新分支信息
        DHGitModel *git = [DHGetterUtils fetchGitWithGitFile:gitFile error:&error];
        if (error) {
            DHLogError(@"获取当前git信息异常: %@", error);
            _endTime = CFAbsoluteTimeGetCurrent();
            return NO;
        }
        DHLogInfo(@"获取当前git最新信息完成");
        if ([self checkInterrupt]) { return NO; }
        
        NSString *currentBranch = git.currentBranch;
        
        // 检查当前分支是否与之相同
        if (![destinationBranch isEqualToString:currentBranch]) {
            // 切换分支
            DHLogInfo(@"当前分支(%@)正在切换至分支(%@)", currentBranch, destinationBranch);
            ret = [DHScriptCommand gitCheckoutBranchWithGitDirectory:gitDirectory
                                                          branchName:destinationBranch
                                                              output:nil
                                                               error:&error];
            if (!ret) {
                DHLogError(@"切换分支异常: %@", error);
                _endTime = CFAbsoluteTimeGetCurrent();
                return ret;
            }
            DHLogInfo(@"切换至分支(%@)完成", destinationBranch);
        } else {
            DHLogInfo(@"当前分支(%@)与目标分支(%@)一致，无需切换分支", currentBranch, destinationBranch);
        }
    }
    internalProgress.completedUnitCount += pieceUnitCount;
    if (progress) { progress(internalProgress); }
    
    if ([self checkInterrupt]) { return NO; }
    
    // 检查是否需要更新分支
    if (task.isNeedGitPull) {
        // 更新分支
        DHLogInfo(@"正在更新分支内容");
        ret = [DHScriptCommand gitPullWithGitDirectory:gitDirectory
                                                output:nil
                                                 error:&error];
        if (!ret) {
            DHLogError(@"更新分支内容异常: %@", error);
            _endTime = CFAbsoluteTimeGetCurrent();
            return ret;
        }
        DHLogInfo(@"更新分支内容完成");
        if ([self checkInterrupt]) { return NO; }
    }
    
    internalProgress.completedUnitCount += pieceUnitCount;
    if (progress) { progress(internalProgress); }
    
    DHLogInfo(@"Running %@ | *** Git Mission Complete ***", task.taskName);
    if ([self checkInterrupt]) { return NO; }
    
    _endTime = CFAbsoluteTimeGetCurrent();
    return YES;
}

- (BOOL)checkInterrupt {
    if (!self.isInterrupt) { return NO; }
    
    _endTime = CFAbsoluteTimeGetCurrent();
    DHLogWarning(@"Interrupt git mission");
    return YES;
}

- (void)interruptTask {
    self.interrupt = YES;
    // 中断命令执行
    [DHScriptCommand interrupt];
}


+ (int64_t)totalUnitCount {
    return kDHTotalUnitCount;
}

+ (int64_t)pieceOfUnitCount {
    return 1.0 * [self totalUnitCount] / [self actualTotalUnitCount];
}

+ (int64_t)actualTotalUnitCount {
    return 2;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Git mission using time: %.2f s",
    (_endTime-_startTime)];
}

@end
