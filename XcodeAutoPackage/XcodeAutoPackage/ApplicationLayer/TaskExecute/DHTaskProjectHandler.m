//
//  DHTaskProjectHandler.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/18.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskProjectHandler.h"
#import "DHTaskModel.h"
#import <DHXcodeSDK/DHXcodeSDK.h>

@interface DHTaskProjectHandler ()
/// 中断标记
@property (nonatomic, assign, getter=isInterrupt) BOOL interrupt;
/// 任务执行时间
@property (nonatomic, assign) CFAbsoluteTime startTime;
/// 任务结束时间
@property (nonatomic, assign) CFAbsoluteTime endTime;

@end

@implementation DHTaskProjectHandler

+ (BOOL)checkTaskHandleable:(DHTaskModel *)task {
    if (!task.engineeringType) { return NO; }
    if ([task.engineeringType isEqualToString:kDHEngineeringTypeProject]
        || [task.engineeringType isEqualToString:kDHEngineeringTypeWorkspace]) { return YES; }
    return NO;
}

- (BOOL)isTaskHandlerExecutable:(DHTaskModel *)task {
    DHLogInfo(@"正在校验项目配置");
    if (![DHPathUtils isXcodeprojFile:task.currentXcodeprojFile]) {
        DHLogError(@".xcodeproj路径不存在: %@", task.currentXcodeprojFile);
        return NO;
    }
    if ([task.engineeringType isEqualToString:kDHEngineeringTypeWorkspace]) {
        if (![DHPathUtils isXcworkspaceFile:task.currentXcworkspaceFile]) {
            DHLogError(@".xcworkspace路径不存在: %@", task.currentXcworkspaceFile);
            return NO;
        }
    }
    DHLogInfo(@"校验项目配置完成");
    return YES;
}

- (BOOL)handleTask:(DHTaskModel *)task progress:(nonnull void (^)(NSProgress * _Nonnull))progress {
    _startTime = CFAbsoluteTimeGetCurrent();
    DHLogInfo(@"Running %@ | ***正在执行项目任务***", task.taskName);
    int64_t pieceUnitCount = [DHTaskProjectHandler pieceOfUnitCount];
    int64_t totalUnitCount = [DHTaskProjectHandler totalUnitCount];
    NSProgress *internalProgress = [NSProgress progressWithTotalUnitCount:totalUnitCount];
    if (progress) { progress(internalProgress); }
    if ([self checkInterrupt]) { return NO; }
    
    
    BOOL ret = NO;
    NSError *error;
    DHLogInfo(@"正在设置配置参数");
    // 设置参数
    ret = [DHSetterUtils setupWithXcodeprojFile:task.currentXcodeprojFile
                                         targetName:task.currentTargetName
                                  configurationName:task.configurationName
                                     forDisplayName:task.isForceSetDisplayName?task.currentDisplayName:nil
                                        productName:task.isForceSetProductName?task.currentProductName:nil
                                           bundleId:task.isForceSetBundleId?task.currentBundleId:nil
                                             teamId:task.isForceSetTeamId?task.currentTeamId:nil
                                            version:task.isForceSetVersion?task.currentVersion:nil
                                       buildVersion:task.isForceSetBuildVersion?task.currentBuildVersion:nil
                                      encodeBitcode:task.isForceSetEnableBitcode?task.currentEnableBitcode:nil
                                              error:&error];
    if (!ret) {
        DHLogError(@"设置配置参数异常: %@", error);
        _endTime = CFAbsoluteTimeGetCurrent();
        return ret;
    }
    internalProgress.completedUnitCount += pieceUnitCount;
    if (progress) { progress(internalProgress); }
    
    DHLogInfo(@"设置配置参数完成");
    if ([self checkInterrupt]) { return NO; }
    
    DHLogInfo(@"正在清理工程");
    NSString *enginePath = [task.engineeringType isEqualToString:kDHEngineeringTypeWorkspace] ? task.currentXcworkspaceFile : task.currentXcodeprojFile;
#ifdef DH_DEBUG_EXECUTE_ON
    [NSThread sleepForTimeInterval:5.f];
    ret = YES;
#else
    // 清理工程
    ret = [DHScriptCommand cleanProjectWithXcworkspaceOrXcodeprojFile:enginePath
                                                   engineeringType:task.engineeringType
                                                        targetName:task.currentTargetName
                                                 configurationName:task.configurationName
                                                             error:&error];
#endif
    if (!ret) {
        // 一旦失败就重置设置项
        [DHSetterUtils resetSetupWithXcodeprojFile:task.currentXcodeprojFile];
        DHLogInfo(@"重置配置参数设置");
        DHLogError(@"清理工程异常: %@", error);
        _endTime = CFAbsoluteTimeGetCurrent();
        return ret;
    }
    internalProgress.completedUnitCount += pieceUnitCount;
    if (progress) { progress(internalProgress); }
    
    DHLogInfo(@"清理工程完成");
    if ([self checkInterrupt]) { return NO; }
    
    DHLogInfo(@"正在归档工程");
    // 归档工程
    NSString *exportArchiveFile = task.exportArchiveFile;
#ifdef DH_DEBUG_EXECUTE_ON
    [NSThread sleepForTimeInterval:5.f];
    ret = YES;
#else
    ret = [DHScriptCommand archiveProjectWithXcworkspaceOrXcodeprojFile:enginePath
                                                     engineeringType:task.engineeringType
                                                          targetName:task.currentTargetName
                                                   configurationName:task.configurationName
                                                       xcarchiveFile:exportArchiveFile
                                                               error:&error];
#endif
    // 归档后无论都要重置配置参数了
    [DHSetterUtils resetSetupWithXcodeprojFile:task.currentXcodeprojFile];
    DHLogInfo(@"重置配置参数设置");
    if (!ret) {
        DHLogError(@"归档工程异常: %@", error);
        _endTime = CFAbsoluteTimeGetCurrent();
        return ret;
    }
    internalProgress.completedUnitCount += pieceUnitCount;
    if (progress) { progress(internalProgress); }
    DHLogInfo(@"归档工程完成");
    DHLogInfo(@"已经生成.xcarchive文件: %@", exportArchiveFile);
    if ([self checkInterrupt]) { return NO; }
    
    DHLogInfo(@"正在导出.ipa文件至: %@", task.exportIPAFile);
    // 导出
#ifdef DH_DEBUG_EXECUTE_ON
    [NSThread sleepForTimeInterval:5.f];
    ret = YES;
#else
    ret = [DHScriptCommand exportProjectIPAFileWithXcarchiveFile:exportArchiveFile
                                              exportIPADirectory:task.exportIPADirectory
                                  createExportOptionsPlistAtPath:nil
                                                        bundleId:task.currentBundleId
                                                          teamId:task.currentTeamId
                                                         channel:task.channel
                                                     profileName:task.currentProfileName
                                                   enableBitcode:task.currentEnableBitcode
                                                        error:&error];
#endif
    if (!ret) {
        DHLogError(@"导出.ipa文件异常: %@", error);
        _endTime = CFAbsoluteTimeGetCurrent();
        return ret;
    }
    internalProgress.completedUnitCount += pieceUnitCount;
    if (progress) { progress(internalProgress); }
    
    DHLogInfo(@"导出.ipa文件完成: %@", task.exportIPAFile);
    if ([self checkInterrupt]) { return NO; }
    
    if (!task.isKeepXcarchive) {
        DHLogInfo(@"正在删除.xcarchive文件: %@", exportArchiveFile);
        ret = [DHCommonTools removePath:exportArchiveFile error:&error];
        // 删除失败，应该只是返回个warning，不影响主流程
        if (!ret) {
            DHLogWarning(@"删除.xcarchive文件(%@)异常: %@", exportArchiveFile, error);
        } else {
            DHLogInfo(@"删除.xcarchive文件完成: %@", exportArchiveFile);
        }
    }
    internalProgress.completedUnitCount += pieceUnitCount;
    if (progress) { progress(internalProgress); }
    
    
    DHLogInfo(@"Running %@ | *** Project mission complete ***", task.taskName);
    if ([self checkInterrupt]) { return NO; }
    _endTime = CFAbsoluteTimeGetCurrent();
    return YES;
}

- (BOOL)checkInterrupt {
    if (!self.isInterrupt) { return NO; }
    
    DHLogWarning(@"Interrupt project mission");
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
    return 5;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Project mission using time: %.2f s",
            (_endTime-_startTime)];
}


@end
