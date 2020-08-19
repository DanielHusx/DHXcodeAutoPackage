//
//  DHScriptExecutor.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/17.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHScriptExecutor.h"
#import "DHScriptModel.h"

static NSErrorDomain const kDHDBScriptErrorDomain = @"daniel.script.error";



#pragma mark - DHScriptExecutor
@interface DHScriptExecutor ()
/// 执行中的Task
@property (nonatomic, strong) NSTask *task;

@end

@implementation DHScriptExecutor

// MARK: - initalization
// 单例
+ (instancetype)executor {
    static DHScriptExecutor *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DHScriptExecutor alloc] init];
    });
    return _instance;
}

@end

#pragma mark - apple script
@implementation DHScriptExecutor (NSAppleScript)
+ (BOOL)executeCommand:(DHScriptModel *)command
                output:(NSString * _Nullable __autoreleasing *)output
                 error:(NSError * _Nonnull __autoreleasing *)error {
    BOOL ret = [[DHScriptExecutor executor] executeCommand:command
                                                    output:output
                                                     error:error];
    return ret;
}

- (BOOL)executeCommand:(DHScriptModel *)command
                output:(NSString * _Nullable __autoreleasing *)output
                 error:(NSError * _Nonnull __autoreleasing *)error {
    BOOL ret = NO;
    // 校验脚本是否可执行
    ret = [self validateAppleScriptExecutableWithScriptPath:command.scriptCommand
                                                      error:error];
    if (!ret) { return ret; }
    
    // 组装Apple Script执行命令
    NSString *shellCommand = [self shellCommandWithScriptModel:command];
    BOOL asAdministrator = command.isAsAdministrator;
    NSString *source = [self appleScriptSourceWithShellCommand:shellCommand
                                               asAdministrator:asAdministrator];
    // 执行AppleScript
    BOOL result = [self executeAppleScriptWithSource:source
                                              output:output
                                               error:error];
    return result;
}

/// 校验参数是否正确
- (BOOL)validateAppleScriptExecutableWithScriptPath:(NSString *)scriptPath
                                              error:(NSError **)error {
    if (![scriptPath isKindOfClass:[NSString class]] || scriptPath.length == 0) {
        *error = [NSError errorWithDomain:kDHDBScriptErrorDomain
                                     code:DHERROR_SCRIPT_NSAPPLESCRIPT_PARAMS_INVALID
                                 userInfo:@{
                                     NSLocalizedFailureReasonErrorKey:[NSString stringWithFormat:@"Script path parameter is invalid(not string or length equal zero)! [scriptPath: %@]", scriptPath]
                                 }];
        return NO;
    }
    return YES;
}

/// 组装成shell指令
- (NSString *)shellCommandWithScriptModel:(DHScriptModel *)scriptModel {
    return [NSString stringWithFormat:@"%@ %@", scriptModel.scriptCommand, [scriptModel.scriptComponent componentsJoinedByString:@" "]];
}


/// 将shell命令组装成Apple脚本字符串
/// @param shellCommand shell指令
/// @param asAdministrator 是否需要管理员权限
/// @return 返回Apple脚本
- (NSString *)appleScriptSourceWithShellCommand:(NSString *)shellCommand
                                asAdministrator:(BOOL)asAdministrator {
    // 管理员权限后缀授权
    NSString *premissionSuffix = asAdministrator?@"with administrator privileges":@"";
    
    NSString *source = [NSString stringWithFormat:@"do shell script \"%@\" %@", shellCommand, premissionSuffix];
    return source;
}

#pragma mark *** apple script core ***
/// 执行Apple脚本
/// @param source 脚本
/// @param output 输出
/// @param error 错误
/// @return YES: 执行正确 NO: 失败
- (BOOL)executeAppleScriptWithSource:(NSString *)source
                              output:(NSString * _Nullable __autoreleasing * _Nullable)output
                               error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    
//    DHXcodeLog(@"daniel: %@", [NSThread currentThread]);
//    if (output) { *output = @"hah"; }
//    return YES;
     DHXcodeLog(@"-----AppleScriptStart-----\n\
[source: %@]",
                source);
    
    NSDictionary *errorInfo = nil;
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:source];
    NSAppleEventDescriptor *result = [appleScript executeAndReturnError:&errorInfo];
    
//    DHXcodeLog(@"[source: %@]\n\
//[result: %@]\n\
//[error: %@]\n\
//-----AppleScriptEnd-----",
//                     source, [result stringValue], errorInfo);
//    if (!result) {
//        if (error) { *error = nil; }
//        if (output) { *output = nil; }
//
////        NSInteger errorCode = -1;
////        // 错误码——意义不大
////        if ([errorInfo valueForKey:NSAppleScriptErrorNumber]) {
////            NSNumber * errorNumber = (NSNumber *)[errorInfo valueForKey:NSAppleScriptErrorNumber];
////            errorCode = [errorNumber integerValue];
////        }
//        // 错误信息
//        NSString *errorMessage = @"unknow error";
//        if ([errorInfo valueForKey:NSAppleScriptErrorMessage]) {
//            errorMessage = (NSString *)[errorInfo valueForKey:NSAppleScriptErrorMessage];
//        }
//        // 这种情况属于没有输出、对于shell命令来说是正确的
//        // 但对于apple script就会抛出错误，所以此处做拦截
//        // 返回上层output、error都为空但是 return 为YES
//        if ([errorMessage isEqualToString:@"The command exited with a non-zero status."]) {
//            return YES;
//        }
//
//        *error = [NSError errorWithDomain:kDHDBScriptErrorDomain
//                                     code:DHERROR_SCRIPT_NSAPPLESCRIPT_EXECUTE_ERROR
//                                 userInfo:@{ NSLocalizedFailureReasonErrorKey:errorMessage?:@"unknow error" }];
//        return NO;
//    }
//
    // 正确执行
    if (error) { *error = nil; }
    if (output) { *output = [result stringValue]; }
    
    return YES;
}

@end



#pragma mark - shell script
@implementation DHScriptExecutor (NSTask)

+ (BOOL)executeCommand:(DHScriptModel *)command
                 error:(NSError * _Nonnull __autoreleasing * _Nonnull)error
          outputStream:(nullable void (^)(NSString * _Nonnull))outputStream
           errorStream:(nullable void (^)(NSString * _Nonnull))errorStream {
    
    BOOL ret = [[DHScriptExecutor executor] executeCommand:command
                                                     error:error
                                              outputStream:outputStream
                                               errorStream:errorStream];
    return ret;
}


- (BOOL)executeCommand:(DHScriptModel *)command
                 error:(NSError * _Nullable __autoreleasing * _Nullable)error
          outputStream:(nullable void (^)(NSString * _Nonnull))outputStream
           errorStream:(nullable void (^)(NSString * _Nonnull))errorStream {
    NSString *scriptPath = command.scriptCommand;
    NSArray *arguments = command.scriptComponent;
    BOOL ret = NO;
    // 校验参数
    ret = [self validateTaskExecutableWithScriptPath:scriptPath
                                           arguments:arguments
                                               error:error];
    if (!ret) { return ret; }
    // 执行脚本
    ret = [self executeShellScriptWithScriptPath:scriptPath
                                       arguments:arguments
                                           error:error
                                    outputStream:outputStream
                                     errorStream:errorStream];
    return ret;
}


#pragma mark *** shell script privite method ***
- (void)resetEnvironment {
    if (!_task) { return ; }
    // 存在运行中的，则执行中断
    if ([_task isRunning]) {
        [_task interrupt];
    }
    _task = nil;
}

- (BOOL)isTaskExecuteSucceed:(NSTask *)task {
    if (!task) { return NO; }
    return task.terminationStatus == 0;
}

/// 校验脚本是否可执行
- (BOOL)validateTaskExecutableWithScriptPath:(NSString *)scriptPath
                                   arguments:(NSArray *)arguments
                                       error:(NSError **)error {
    // 校验scriptPath是否存在该文件
    BOOL isDirectory;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:scriptPath isDirectory:&isDirectory];
    if (!exist || isDirectory) {
        *error = [NSError errorWithDomain:kDHDBScriptErrorDomain
                                     code:DHERROR_SCRIPT_NSTASK_PARAMS_INVALID
                                 userInfo:@{
                                     NSLocalizedFailureReasonErrorKey:[NSString stringWithFormat:@"Script path parameter is invalid(path not exist)! [scriptPath: %@]", scriptPath]
                                 }];
        return NO;
    }
    
    // 校验arguments
    if ([arguments count] == 0 || ![arguments isKindOfClass:[NSArray class]]) {
        *error = [NSError errorWithDomain:kDHDBScriptErrorDomain
                                     code:DHERROR_SCRIPT_NSTASK_PARAMS_INVALID
                                 userInfo:@{
                                     NSLocalizedFailureReasonErrorKey:[NSString stringWithFormat:@"Argument parameter is invalid(cannot be emtpy)! [scriptPath: %@]", scriptPath]
                                 }];
        return NO;
    }
    
    return YES;
}

#pragma mark *** shell script core ***
/// 执行shell脚本
/// @discussion 这种方式存在缺陷：同一时间只能执行一条指令且不能用 | 组合指令执行
///
/// @param scriptPath 脚本绝对路径
/// @param arguments 执行参数
/// @param error 执行错误
/// @return YES: 执行正确 NO: 执行失败
- (BOOL)executeShellScriptWithScriptPath:(NSString *)scriptPath
                               arguments:(NSArray *)arguments
                                   error:(NSError * _Nullable __autoreleasing *)error
                            outputStream:(nullable void (^)(NSString * _Nonnull))outputStream
                             errorStream:(nullable void (^)(NSString * _Nonnull))errorStream {
    // 重置环境
    [self resetEnvironment];
    
    DHXcodeLog(@"-------ShellScriptStart-------\n\
[executableURL: %@]\n\
[arguments: %@]",
                         scriptPath, arguments);
    
    
    // 配置脚本参数
    _task = [[NSTask alloc] init];
    [_task setExecutableURL:[NSURL fileURLWithPath:scriptPath]];
    [_task setArguments:arguments];
    
    // 正常输出管道
    BOOL outputStreamable = outputStream?YES:NO;
    NSPipe *outPip = [[NSPipe alloc]init];
    [_task setStandardOutput:outPip];
    
    // 错误输出管道
    BOOL errorStreamable = errorStream?YES:NO;
    NSPipe *errorPip = [[NSPipe alloc]init];
    [_task setStandardError:errorPip];
    
    // 后台线程等待输出
    [outPip.fileHandleForReading waitForDataInBackgroundAndNotify];
    [errorPip.fileHandleForReading waitForDataInBackgroundAndNotify];
    
    // 以下监听值由于通知名称一致，所以只能通过block监听，且在task执行区间内有效，@selector的方式无效
    // 监听正常输出
    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification
                                                      object:outPip.fileHandleForReading queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
        NSData *outData = [[outPip fileHandleForReading] availableData];
        NSString *outString = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
        if (outString.length > 0 && outputStreamable) {
            outputStream(outString);
        }
        // 继续等待输出
        [outPip.fileHandleForReading waitForDataInBackgroundAndNotify];
    }];
    
    // 监听错误输出
    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleDataAvailableNotification
                                                      object:errorPip.fileHandleForReading
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
        NSData *errorData = [[errorPip fileHandleForReading] availableData];
        NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        if (errorString.length > 0 && errorStreamable) {
            errorStream(errorString);
        }
        // 继续等待输出
        [errorPip.fileHandleForReading waitForDataInBackgroundAndNotify];
    }];
    
    // 执行脚本
    BOOL ret = [_task launchAndReturnError:error];
    [_task waitUntilExit];
    
    DHXcodeLog(@"[executableURL: %@]\n\
[arguments: %@]\n\
[terminationStatus: %@]\n\
[result: %@]\n\
[error: %@]\n\
-------ShellScriptEnd-------",
                     self.task.executableURL, self.task.arguments, @(self.task.terminationStatus), ret?@"YES":@"NO", *error);
    
    // 执行脚本出错
    if (!ret) { return NO; }
    
    // 判断是否执行成功
    ret = [self isTaskExecuteSucceed:self.task];
    
    // 重置环境
    [self resetEnvironment];
    return ret;
}



// MARK: - 管理控制
+ (void)interrupt {
    [[DHScriptExecutor executor] interruptTask];
}


// MARK: - private method
- (void)interruptTask {
    // 当前不存在指令
    if (!_task) { return ; }
    // 当前不存在执行中的指令
    if (![_task isRunning]) { return ; }
    
    // 执行中断
    [_task interrupt];
}

@end

// MARK: -
@implementation DHScriptExecutor (DHBackupCode)

/// 执行shell脚本
///
/// @param scriptPath 脚本绝对路径
/// @param arguments 执行参数
/// @param output 输出
/// @param error 执行错误
/// @return YES: 执行正确 NO: 执行失败
+ (BOOL)executeShellScriptWithScriptPath:(NSString *)scriptPath
                               arguments:(NSArray *)arguments
                                  output:(NSString * _Nullable __autoreleasing *)output
                                   error:(NSError * _Nullable __autoreleasing *)error {
    
    NSTask *task = [[NSTask alloc] init];
    BOOL ret;
    
    // 设置脚本执行路径与参数
    [task setExecutableURL:[NSURL fileURLWithPath:scriptPath]];
    [task setArguments:arguments];
    // 正常输出管道
    NSPipe *outPip = [[NSPipe alloc]init];
    [task setStandardOutput:outPip];
    // 错误输出管道
    NSPipe *errorPip = [[NSPipe alloc]init];
    [task setStandardError:errorPip];
    
    // 执行脚本
    ret = [task launchAndReturnError:error];
    [task waitUntilExit];
    
    if (!ret) { return NO; }
    // 一次性获取所有输出
    NSData *outData = [[outPip fileHandleForReading] availableData];
    [outPip.fileHandleForReading readInBackgroundAndNotify];
    
    NSData *errorData = [[errorPip fileHandleForReading] availableData];
    [errorPip.fileHandleForReading readInBackgroundAndNotify];
    
    NSString *outString = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
    NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
    
    ret = errorString.length == 0;
    
    if (outString) {
        if (output) { *output = outString; }
    }
    if (errorString) {
        if (error) { *error = [NSError errorWithDomain:kDHDBScriptErrorDomain code:-1 userInfo:@{NSLocalizedFailureReasonErrorKey:errorString}]; }
    }
    return ret;
}

@end
