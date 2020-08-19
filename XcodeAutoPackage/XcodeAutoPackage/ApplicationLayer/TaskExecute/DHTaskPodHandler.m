//
//  DHTaskPodHandler.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/18.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskPodHandler.h"
#import "DHTaskModel.h"
#import <DHXcodeSDK/DHXcodeSDK.h>

@interface DHTaskPodHandler ()
/// 中断标记
@property (nonatomic, assign, getter=isInterrupt) BOOL interrupt;
/// 任务执行时间
@property (nonatomic, assign) CFAbsoluteTime startTime;
/// 任务结束时间
@property (nonatomic, assign) CFAbsoluteTime endTime;

@end

@implementation DHTaskPodHandler

+ (BOOL)checkTaskHandleable:(DHTaskModel *)task {
    if (task.podfilePath) { return YES; }
    return NO;
}

- (BOOL)isTaskHandlerExecutable:(DHTaskModel *)task {
    DHLogInfo(@"正在校验Podfile配置");
    if ([DHPathUtils isPodfileFile:task.podfilePath]) {
        DHLogInfo(@"校验Podfile配置完成");
        return YES;
    }
    DHLogError(@"Pofile路径不存在: %@", task.podfilePath);
    return NO;
}

- (BOOL)handleTask:(DHTaskModel *)task progress:(nonnull void (^)(NSProgress * _Nonnull))progress {
    _startTime = CFAbsoluteTimeGetCurrent();
    DHLogInfo(@"Running %@ | *** Process pod mission ***", task.taskName);
    int64_t pieceUnitCount = [DHTaskPodHandler pieceOfUnitCount];
    int64_t totalUnitCount = [DHTaskPodHandler totalUnitCount];
    NSProgress *internalProgress = [NSProgress progressWithTotalUnitCount:totalUnitCount];
    if (progress) { progress(internalProgress); }
    if ([self checkInterrupt]) { return NO; }
    
    // 检查是否需要pod install
    if (!task.isNeedPodInstall) {
        [internalProgress setCompletedUnitCount:totalUnitCount];
        if (progress) { progress(internalProgress); }
        
        DHLogInfo(@"Running %@ | *** Pod mission complete ***", task.taskName);
        if ([self checkInterrupt]) { return NO; }
        return YES;
    }
    if ([self checkInterrupt]) { return NO; }
    
    DHLogInfo(@"正在pod install");
    // 执行pod install
    NSError *error;
    NSString *podfile = task.podfilePath;
    NSString *podfileDirectory = [DHPathUtils getPodfileDirectoryWithPodfile:podfile];
    
    BOOL ret = [DHScriptCommand podInstallWithPodfileDirectory:podfileDirectory
                                                        output:nil
                                                         error:&error];
    if (!ret) {
        DHLogError(@"pod install异常: %@", error);
        _endTime = CFAbsoluteTimeGetCurrent();
        return ret;
    }
    DHLogInfo(@"pod install完成");
    
    internalProgress.completedUnitCount += pieceUnitCount;
    if (progress) { progress(internalProgress); }
    
    DHLogInfo(@"Running %@ | *** Pod mission complete ***", task.taskName);
    if ([self checkInterrupt]) { return NO; }
    _endTime = CFAbsoluteTimeGetCurrent();
    return YES;
}

- (BOOL)checkInterrupt {
    if (!self.isInterrupt) { return NO; }
    
    DHLogWarning(@"Interrupt pod mission");
    _endTime = CFAbsoluteTimeGetCurrent();
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
    return 1;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Pod mission using time: %.2f s",
    (_endTime-_startTime)];
}

@end
