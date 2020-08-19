//
//  DHTaskHandlerManager.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/18.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskHandlerManager.h"
#import "DHTaskGitHandler.h"
#import "DHTaskPodHandler.h"
#import "DHTaskArchiveHandler.h"
#import "DHTaskProjectHandler.h"
#import "DHTaskDistributeHandler.h"
#import "DHTaskModel.h"

@interface DHTaskHandlerManager ()
/// handler集合
@property (nonatomic, strong) NSMutableArray *handlers;

/// 正在执行的handler
@property (nonatomic, strong) id<DHTaskHandlerProtocol> runningHandler;

@end

@implementation DHTaskHandlerManager

+ (instancetype)manager {
    static DHTaskHandlerManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DHTaskHandlerManager alloc] init];
    });
    return _instance;
}

+ (int64_t)totalUnitCountForTask:(DHTaskModel *)task {
    int64_t totalUnitCount = 0;
    if ([DHTaskGitHandler checkTaskHandleable:task]) {
        totalUnitCount += [DHTaskGitHandler totalUnitCount];
    }
    if ([DHTaskPodHandler checkTaskHandleable:task]) {
        totalUnitCount += [DHTaskPodHandler totalUnitCount];
    }
    if ([DHTaskArchiveHandler checkTaskHandleable:task]) {
        totalUnitCount += [DHTaskArchiveHandler totalUnitCount];
    }
    if ([DHTaskProjectHandler checkTaskHandleable:task]) {
        totalUnitCount += [DHTaskProjectHandler totalUnitCount];
    }
    if ([DHTaskDistributeHandler checkTaskHandleable:task]) {
        totalUnitCount += [DHTaskDistributeHandler totalUnitCount];
    }
    return totalUnitCount;
}

+ (BOOL)prepareHandlersForTask:(DHTaskModel *)task {
    DHTaskHandlerManager *manager = [DHTaskHandlerManager manager];
    [manager.handlers removeAllObjects];
    
    if ([DHTaskGitHandler checkTaskHandleable:task]) {
        [manager.handlers addObject:[[DHTaskGitHandler alloc] init]];
    }
    if ([DHTaskPodHandler checkTaskHandleable:task]) {
        [manager.handlers addObject:[[DHTaskPodHandler alloc] init]];
    }
    if ([DHTaskArchiveHandler checkTaskHandleable:task]) {
        [manager.handlers addObject:[[DHTaskArchiveHandler alloc] init]];
    }
    if ([DHTaskProjectHandler checkTaskHandleable:task]) {
        [manager.handlers addObject:[[DHTaskProjectHandler alloc] init]];
    }
    if ([DHTaskDistributeHandler checkTaskHandleable:task]) {
        [manager.handlers addObject:[[DHTaskDistributeHandler alloc] init]];
    }
    
    if (![DHCommonTools isValidArray:manager.handlers]) {
        DHLogError(@"任务数据异常: 无有效任务信息");
        return NO;
    }
    return YES;
}

+ (BOOL)checkHandlesExecuatable:(DHTaskModel *)task {
    DHTaskHandlerManager *manager = [DHTaskHandlerManager manager];
    BOOL ret = YES;
    for (id<DHTaskHandlerProtocol> handler in manager.handlers) {
        ret = [handler isTaskHandlerExecutable:task];
        if (!ret) { return NO; }
    }
    return YES;
}

+ (void)interruptTask {
    if (![DHTaskHandlerManager manager].runningHandler) { return ; }
    [[DHTaskHandlerManager manager].runningHandler interruptTask];
}


+ (BOOL)handleTask:(DHTaskModel *)task progress:(void (^) (NSProgress *))progress completionHandler:(nullable void (^)(NSString * _Nonnull))completionHandler {
    DHTaskHandlerManager *manager = [DHTaskHandlerManager manager];
    BOOL ret = YES;
    __block NSProgress *internalProgress = [NSProgress progressWithTotalUnitCount:[manager totalUnitCount]];
    if (progress) { progress(internalProgress); }
    // 统计任务执行信息
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    NSMutableString *result = [NSMutableString stringWithFormat:@"\n******* %@ Mission Start *******\n", task.taskName];
    
    for (id<DHTaskHandlerProtocol> handler in manager.handlers) {
        manager.runningHandler = handler;
        int64_t currentCompletedUnitCount = internalProgress.completedUnitCount;
        ret = [handler handleTask:task progress:^(NSProgress * _Nonnull handlerProgress) {
            internalProgress.completedUnitCount = currentCompletedUnitCount + handlerProgress.completedUnitCount;
            if (progress) { progress(internalProgress); }
        }];
        [result appendFormat:@"%@\n", [handler description]];
        if (!ret) {
            [result appendFormat:@"############################################\nTotal using time: %.2f s\n", (CFAbsoluteTimeGetCurrent() - startTime)];
            [result appendFormat:@"*** %@ Mission Failed ***", task.taskName];
            [manager cleanRunningHanlder];
            return NO;
        }
    }

    [result appendFormat:@"############################################\nTotal using time: %.2f s\n", (CFAbsoluteTimeGetCurrent() - startTime)];
    [result appendFormat:@"******* %@ Mission Complete *******\n", task.taskName];
    if (completionHandler) { completionHandler([result copy]); }
    [manager cleanRunningHanlder];
    return YES;
}

- (void)cleanRunningHanlder {
    _runningHandler = nil;
}

- (int64_t)totalUnitCount {
    int64_t total = 0;
    for (id<DHTaskHandlerProtocol> handler in self.handlers) {
        total += [handler.class totalUnitCount];
    }
    return total;
}

- (NSMutableArray *)handlers {
    if (!_handlers) {
        _handlers = [NSMutableArray arrayWithCapacity:5];
    }
    return _handlers;
}

@end
