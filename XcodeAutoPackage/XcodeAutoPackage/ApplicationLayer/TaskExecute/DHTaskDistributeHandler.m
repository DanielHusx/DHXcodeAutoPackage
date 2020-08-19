//
//  DHTaskDistributeHandler.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/18.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskDistributeHandler.h"
#import "DHTaskModel.h"
#import "DHTaskArchiveHandler.h"
#import "DHTaskProjectHandler.h"
#import <DHXcodeSDK/DHXcodeSDK.h>
#import "DHTaskModel+DHTaskParseInfo.h"

@interface DHTaskDistributeHandler ()
/// 中断标记
@property (nonatomic, assign, getter=isInterrupt) BOOL interrupt;
/// 任务执行时间
@property (nonatomic, assign) CFAbsoluteTime startTime;
/// 任务结束时间
@property (nonatomic, assign) CFAbsoluteTime endTime;

@end

@implementation DHTaskDistributeHandler

+ (BOOL)checkTaskHandleable:(DHTaskModel *)task {
    if ([task.currentDistributionPlatformType isEqualToString:kDHDistributionPlatformNone]) {
        return NO;
    }
    if (!task.currentDistributer) { return NO; }
    return YES;
}

- (BOOL)isTaskHandlerExecutable:(DHTaskModel *)task {
    DHLogInfo(@"正在校验(%@)上传配置", task.currentDistributionNickname);
    if ([task.currentDistributionPlatformType isEqualToString:kDHDistributionPlatformNone]) {
        DHLogError(@"理论上不可能校验到此处，一旦出现，请检查代码");
        return NO;
    }
    if (![DHCommonTools isValidString:task.currentDistributionPlatformApiKey]) {
        DHLogError(@"%@ 上传平台(%@)对应API Key未配置", task.currentDistributionNickname, task.currentDistributionPlatformType);
        return NO;
    }
    if (![DHPathUtils isIPAFile:task.exportIPAFile]
        && ![DHTaskProjectHandler checkTaskHandleable:task]
        && ![DHTaskArchiveHandler checkTaskHandleable:task]) {
        DHLogError(@"需上传的.ipa文件不存在或非.ipa文件: %@", task.exportIPAFile);
        return NO;
    }
    DHLogInfo(@"校验(%@)上传配置完成", task.currentDistributionPlatformType);
    return YES;
}

// 模拟上传
- (void)uploadProgressHandler:(void (^)(NSProgress * _Nonnull))uploadProgressHandler
            completionHandler:(void (^)(BOOL, NSError * _Nullable))completionHandler {
    int64_t total = 1024000;
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:total];
    if (uploadProgressHandler) { uploadProgressHandler(progress); }
    int64_t count = 0;
    do {
        count += arc4random() % 10;
        if (count > total) { count = total; }
        progress.completedUnitCount = count;
        if (uploadProgressHandler) { uploadProgressHandler(progress); }
    } while(count < total);
    if (completionHandler) { completionHandler(YES, nil); }
}

- (BOOL)handleTask:(DHTaskModel *)task progress:(nonnull void (^)(NSProgress * _Nonnull))progress {
    _startTime = CFAbsoluteTimeGetCurrent();
    // 上传
    DHLogInfo(@"Running %@ | ***正在执行上传任务***", task.taskName);
    int64_t totalUnitCount = [DHTaskDistributeHandler totalUnitCount];
    __block NSProgress *internalProgress = [NSProgress progressWithTotalUnitCount:totalUnitCount];
    if (progress) { progress(internalProgress); }
    __block BOOL ret = YES;
    __block NSError *error = nil;
#ifdef DH_DEBUG_EXECUTE_ON
    [self uploadProgressHandler:^(NSProgress * _Nonnull uploadProgress) {
        internalProgress.completedUnitCount = uploadProgress.completedUnitCount * 1.0 * totalUnitCount/uploadProgress.totalUnitCount;
        if (progress) { progress(internalProgress); }
    } completionHandler:^(BOOL succeed, NSError * _Nullable completionError) {
        ret = succeed;
        error = completionError;
    }];
#else
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [task.currentDistributer distributeIPAFile:task.exportIPAFile
                                    toPlatform:task.distributionPlatform
                         uploadProgressHandler:^(NSProgress * _Nonnull uploadProgress) {
        internalProgress.completedUnitCount = uploadProgress.completedUnitCount * 1.0 * totalUnitCount/uploadProgress.totalUnitCount;
        if (progress) { progress(internalProgress); }
    }
                                           completionHandler:^(BOOL succeed, NSError * _Nullable completionError) {
        ret = succeed;
        error = completionError;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
#endif
    if (!ret) {
        DHLogError(@"上传异常: %@", error);
        _endTime = CFAbsoluteTimeGetCurrent();
        return ret;
    }
    
    DHLogInfo(@"Running %@ | *** Upload ipa mission complete ***", task.taskName);
    if ([self checkInterrupt]) { return NO; }
    _endTime = CFAbsoluteTimeGetCurrent();
    return YES;
}

+ (int64_t)totalUnitCount {
    return kDHTotalUnitCount;
}

- (BOOL)checkInterrupt {
    if (!self.isInterrupt) { return NO; }
    
    DHLogWarning(@"distribute任务执行中断");
    return YES;
}

- (void)interruptTask {
    self.interrupt = YES;
    // 中断命令执行
    [DHDistributer interrupt];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"Upload ipa mission using time: %.2f s",
            (_endTime-_startTime)];
}

@end
