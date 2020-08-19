//
//  DHTaskArchiveHandler.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/18.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskArchiveHandler.h"
#import "DHTaskModel.h"
#import <DHXcodeSDK/DHXcodeSDK.h>

@interface DHTaskArchiveHandler ()
/// 中断标记
@property (nonatomic, assign, getter=isInterrupt) BOOL interrupt;
/// 任务执行时间
@property (nonatomic, assign) CFAbsoluteTime startTime;
/// 任务结束时间
@property (nonatomic, assign) CFAbsoluteTime endTime;

@end

@implementation DHTaskArchiveHandler

+ (BOOL)checkTaskHandleable:(DHTaskModel *)task {
    if (task.xcarchiveFile) { return YES; }
    return NO;
}

- (BOOL)isTaskHandlerExecutable:(DHTaskModel *)task {
    DHLogInfo(@"正在校验归档配置");
    if ([DHPathUtils isXcarchiveFile:task.xcarchiveFile]) {
        DHLogInfo(@"校验归档配置完成");
        return YES;
    }
    
    DHLogError(@".xcarchive路径不存在: %@", task.xcarchiveFile);
    return NO;
}

- (BOOL)handleTask:(DHTaskModel *)task progress:(nonnull void (^)(NSProgress * _Nonnull))progress {
    _startTime = CFAbsoluteTimeGetCurrent();
    DHLogInfo(@"Runing %@ | ***正在执行导出任务***", task.taskName);
    int64_t pieceUnitCount = [DHTaskArchiveHandler pieceOfUnitCount];
    int64_t totalUnitCount = [DHTaskArchiveHandler totalUnitCount];
    NSProgress *internalProgress = [NSProgress progressWithTotalUnitCount:totalUnitCount];
    if (progress) { progress(internalProgress); }
    if ([self checkInterrupt]) { return NO; }
    
    // 导出操作
    DHLogInfo(@"正在将.xcarchive导出.ipa文件至: %@", task.exportIPAFile);
    BOOL ret = YES;
    NSError *error;

    ret = [DHScriptCommand exportProjectIPAFileWithXcarchiveFile:task.xcarchiveFile
                                              exportIPADirectory:task.exportIPADirectory
                                  createExportOptionsPlistAtPath:nil
                                                        bundleId:task.currentBundleId
                                                          teamId:task.currentTeamId
                                                         channel:task.channel
                                                     profileName:task.currentProfileName
                                                   enableBitcode:task.currentEnableBitcode
                                                           error:&error];

    if (!ret) {
        DHLogError(@"导出.ipa文件异常: %@", error);
        _endTime = CFAbsoluteTimeGetCurrent();
        return ret;
    }
    DHLogInfo(@".xcarchive已导出.ipa文件至: %@", task.exportIPAFile);
    
    internalProgress.completedUnitCount+=pieceUnitCount;
    if (progress) { progress(internalProgress); }
    
    DHLogInfo(@"Running: %@ | *** Archive mission complete ***", task.taskName);
    if ([self checkInterrupt]) { return NO; }
    _endTime = CFAbsoluteTimeGetCurrent();
    return YES;
}

- (BOOL)checkInterrupt {
    if (!self.isInterrupt) { return NO; }
    
    DHLogWarning(@"Interrupt archive mission");
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
    return [NSString stringWithFormat:@"Archive mission using time: %.2f s",
            (_endTime-_startTime)];
}


@end
