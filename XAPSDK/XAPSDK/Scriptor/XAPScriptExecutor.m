//
//  XAPScriptExecutor.m
//  XAPSDK
//
//  Created by Daniel on 2020/11/30.
//

#import "XAPScriptExecutor.h"
#import "XAPScriptModel.h"

/// 脚本错误域名
static NSErrorDomain const kXAPScriptErrorDomain = @"daniel.script.error";

@interface XAPScriptExecutor ()

/// 执行中的Task
@property (nonatomic, strong) NSTask *currentShellTask;
/// 执行中的Task
@property (nonatomic, strong) NSAppleScript *currentScriptTask;
/// 信号量
@property (nonatomic, strong) dispatch_semaphore_t taskSemaphore;
/// 串行队列
@property (nonatomic, strong) dispatch_queue_t taskQueue;

@end

@implementation XAPScriptExecutor
#pragma mark - public method
+ (instancetype)sharedExecutor {
    static XAPScriptExecutor *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XAPScriptExecutor alloc] init];
        
        _instance.taskSemaphore = dispatch_semaphore_create(0);
        _instance.taskQueue = dispatch_queue_create("DHScriptExecutorQueue", DISPATCH_QUEUE_SERIAL);
    });
    return _instance;
}

- (id)execute:(XAPScriptModel *)scriptModel
        error:(NSError * _Nullable __autoreleasing *)error {
    // 验证数据有效性
    BOOL ret = [self checkScriptValidWithScriptModel:scriptModel
                                               error:error];
    if (!ret) { return nil; }
    
    // 执行命令
    id result = [self executeByQueue:scriptModel
                               error:error];
    return result;
}

- (void)interrupt {
    [self interruptTask:_currentShellTask];
}


#pragma mark - private method
- (BOOL)checkScriptValidWithScriptModel:(XAPScriptModel *)scriptModel
                                  error:(NSError * _Nullable __autoreleasing *)error {
    if (![scriptModel.scriptPath isKindOfClass:[NSString class]]
        || scriptModel.scriptPath.length == 0) {
         [self errorWithCode:-1
                     message:[NSString stringWithFormat:@"Script path parameter is invalid(not string or length equal zero)! [scriptPath: %@]", scriptModel.scriptPath]
                       error:error];
        return NO;
    }
    
    return YES;
}

- (void)errorWithCode:(NSInteger)errorCode
              message:(NSString *)errorMessage
                error:(NSError * _Nullable __autoreleasing *)error {
    if (!error) { return; }
    NSError *e = [NSError errorWithDomain:kXAPScriptErrorDomain
                                     code:errorCode
                                 userInfo:@{
                                     NSLocalizedFailureReasonErrorKey:errorMessage?:@""
                                 }];
    
    *error = e;
}


#pragma mark - execute
- (id)executeByQueue:(XAPScriptModel *)scriptModel
               error:(NSError * _Nullable __autoreleasing *)error {
    __weak typeof(self) weakself = self;
    __block id result;
    // 线程执行命令
    dispatch_async(_taskQueue, ^{
        __weak typeof(weakself) strongself = weakself;
        if (scriptModel.scriptType == XAPScriptModelTypeDelay) {
            // 延迟命令
            result = [strongself executeDelayCommand:scriptModel error:error];
        } else {
            // 即时命令
            result = [strongself executeImmediateCommand:scriptModel error:error];
        }
        
        dispatch_semaphore_signal(strongself.taskSemaphore);
    });
    
    dispatch_semaphore_wait(self.taskSemaphore, DISPATCH_TIME_FOREVER);
    
    return result;
}


#pragma mark - XAPScriptModelTypeDelay
- (id)executeImmediateCommand:(XAPScriptModel *)scriptModel
                        error:(NSError * _Nullable __autoreleasing *)error {
    @autoreleasepool {
        
        NSDictionary *errorInfo = nil;
        NSString *source = [self sourceWithScriptModel:scriptModel];
        NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:source];
        NSAppleEventDescriptor *result = [appleScript executeAndReturnError:&errorInfo];
        
        if (!result) {
            // 错误信息
            NSString *errorMessage = @"Execute apple script failed with unknow error";
            if ([errorInfo valueForKey:NSAppleScriptErrorMessage]) {
                errorMessage = [errorInfo objectForKey:NSAppleScriptErrorMessage];
            }
            // 这种情况属于没有输出、对于shell命令来说是正确的
            // 但对于apple script就会抛出错误，所以此处做拦截
            // 返回上层output、error都为空但是 return 为nil
            if ([errorMessage isEqualToString:@"The command exited with a non-zero status."]) {
                return nil;
            }

            [self errorWithCode:-1
                        message:[NSString stringWithFormat:@"Apple script executed failed. Reason: %@ [source: %@]", errorMessage, source]
                          error:error];
            
        }
        
        return [result stringValue];
    }
}

/// 组装成shell指令
- (NSString *)sourceWithScriptModel:(XAPScriptModel *)scriptModel {
    
    NSString *shellScript = [NSString stringWithFormat:@"%@ %@", scriptModel.scriptPath, [scriptModel.scriptArguments componentsJoinedByString:@" "]];
    NSString *premissionSuffix = scriptModel.isAsAdministrator ? @"with administrator privileges" : @"";
    NSString *source = [NSString stringWithFormat:@"do shell script \"%@\" %@", shellScript, premissionSuffix];
    return source;
    
}


#pragma mark - XAPScriptModelTypeDefault
- (id)executeDelayCommand:(XAPScriptModel *)scriptModel
                    error:(NSError * _Nullable __autoreleasing *)error {
    @autoreleasepool {
        
        // 判断是否存在运行中命令
        if ([self checkExistTaskIsRunning]) {
            [self errorWithCode:1
                        message:[NSString stringWithFormat:@"Exist shell script [%@] running. ", _currentShellTask.executableURL]
                          error:error];
            return nil;
        }
        
        // 配置脚本参数
        _currentShellTask = [[NSTask alloc] init];
        [_currentShellTask setExecutableURL:[NSURL fileURLWithPath:scriptModel.scriptPath]];
        [_currentShellTask setArguments:scriptModel.scriptArguments];
        
        // 正常输出管道
        BOOL outputStreamable = _delegate && [_delegate respondsToSelector:@selector(executor:outputStream:)];
        if (outputStreamable) {
            NSPipe *outPip = [[NSPipe alloc]init];
            [_currentShellTask setStandardOutput:outPip];
            
            // 后台线程等待输出
            [outPip.fileHandleForReading waitForDataInBackgroundAndNotify];
            
            // 以下监听值由于通知名称一致，所以只能通过block监听，且在task执行区间内有效，@selector的方式无效
            // 监听正常输出
            __weak typeof(self) weakself = self;
            [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification
                                                              object:outPip.fileHandleForReading queue:nil
                                                          usingBlock:^(NSNotification * _Nonnull note) {
                
                __weak typeof(weakself) strongself = weakself;
                NSData *outData = [[outPip fileHandleForReading] availableData];
                NSString *outString = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
                if (outString.length > 0) {
                    [strongself delegateOutputStream:outString];
                }
                // 继续等待输出
                [outPip.fileHandleForReading waitForDataInBackgroundAndNotify];
            }];
        }
        
        // 错误输出管道
        BOOL errorStreamable = _delegate && [_delegate respondsToSelector:@selector(executor:errorStream:)];
        if (errorStreamable) {
            NSPipe *errorPip = [[NSPipe alloc]init];
            [_currentShellTask setStandardError:errorPip];
            
            // 后台线程等待输出
            [errorPip.fileHandleForReading waitForDataInBackgroundAndNotify];
            // 监听错误输出
            __weak typeof(self) weakself = self;
            [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification
                                                              object:errorPip.fileHandleForReading
                                                               queue:nil
                                                          usingBlock:^(NSNotification * _Nonnull note) {
                __weak typeof(weakself) strongself = weakself;
                NSData *errorData = [[errorPip fileHandleForReading] availableData];
                NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
                if (errorString.length > 0) {
                    [strongself delegateErrorStream:errorString];
                }
                // 继续等待输出
                [errorPip.fileHandleForReading waitForDataInBackgroundAndNotify];
            }];
        }
        
        // 执行脚本
        BOOL ret = [_currentShellTask launchAndReturnError:error];
        [_currentShellTask waitUntilExit];
        
        // 执行脚本出错
        if (!ret) {
            [self reset];
            return nil;
        }
        
        // 判断是否执行成功
        ret = [self isTaskExecuteSucceed:_currentShellTask];
        if (!ret) {
            [self errorWithCode:-1
                        message:[NSString stringWithFormat:@"Execute shell script [%@] failed with terminal status isn't zero [%d].", _currentShellTask.executableURL, _currentShellTask.terminationStatus]
                          error:error];
        }
        [self reset];
        
        return nil;
    }
}

// 中断task
- (void)interruptTask:(NSTask *)task {
    // 当前不存在指令
    if (!task) { return ; }
    // 当前不存在执行中的指令
    if (![task isRunning]) { return ; }
    
    // 执行中断
    [task interrupt];
}

// 判断task是否在运行中
- (BOOL)checkExistTaskIsRunning {
    if (!_currentShellTask) { return NO; }
    // 存在执行中的任务则断掉
    if ([_currentShellTask isRunning]) { return YES; }
    
    return NO;
}

// 判断task执行成功
- (BOOL)isTaskExecuteSucceed:(NSTask *)task {
    if (!task) { return NO; }
    return task.terminationStatus == 0;
}

- (void)reset {
    [self interruptTask:_currentShellTask];
    _currentShellTask = nil;
}

- (void)delegateOutputStream:(NSString *)output {
    [_delegate executor:self outputStream:output];
}

- (void)delegateErrorStream:(NSString *)error {
    [_delegate executor:self errorStream:error];
}

@end
