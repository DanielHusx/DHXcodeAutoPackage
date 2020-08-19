//
//  DHLogger.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/25.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHLogger.h"
#import "DHLogFormatter.h"
#import <DHXcodeSDK/DHXcodeSDKLogger.h>
#import <DHXcodeSDK/DHXcodeSDKMacro.h>

@interface DHLogger () <DHXcodeSDKLoggerDelegate>
/// 串行线程
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@end

@implementation DHLogger
// MARK: - instance
+ (instancetype)shareLogger {
    static DHLogger *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DHLogger alloc] init];
        [_instance setupData];
    });
    return _instance;
}

- (void)setupData {
    [self redirectNSlogToDocumentFolder];
//    [self redirectLog];
    
    _serialQueue = dispatch_queue_create("loggerSerialQueue", DISPATCH_QUEUE_SERIAL);
    [DHXcodeSDKLogger logger].delegate = self;
}


- (BOOL)verbose {
    return kDHXcodeVerbose?YES:NO;
}

- (void)setVerbose:(BOOL)verbose {
    kDHXcodeVerbose = verbose?true:false;
}

- (void)commonReceivedLog:(NSString *)string type:(DHLogType)type {
    __weak typeof(self) weakself = self;
    dispatch_async(_serialQueue, ^{
//        fflush(stdout);
    // FIXME: 似乎是存在cpu暴增的问题，咋整！
//        printf("%s\n", string.UTF8String);
        [weakself notifyLogWithString:string type:type];
    });
}

- (void)notifyLogWithString:(NSString *)string type:(DHLogType)type {
    [_delegate logger:self withString:string];
//    [_delegate logger:self withString:[DHLogFormatter formatStringForType:type withString:string]];
//    [_delegate logger:self withAttributeString:[DHLogFormatter formatAttributeStringForType:type withString:string]];
}

// MARK: - log
- (void)logDebug:(NSString *)debug {
    if (!kDHXcodeVerbose) { return ; }
    [self commonReceivedLog:debug type:DHLogTypeBusinessDebug];
}

- (void)logInfo:(NSString *)info {
    [_statusDelegate logger:self didReceivedInfo:info];
    [self commonReceivedLog:info type:DHLogTypeBusinessInfo];
}

- (void)logError:(NSString *)error {
    [_statusDelegate logger:self didReceivedError:error];
    [self commonReceivedLog:error type:DHLogTypeBusinessError];
}

- (void)logWarning:(NSString *)warning {
    [_statusDelegate logger:self didReceivedWarning:warning];
    [self commonReceivedLog:warning type:DHLogTypeBusinessWarning];
}


// MARK: - DHXcodeSDKLoggerDelegate
- (void)sdkLogger:(DHXcodeSDKLogger *)sdkLogger log:(NSString *)log {
//    if (!kDHXcodeVerbose) { return ; }
    [self commonReceivedLog:log type:DHLogTypeDataBaseInfo];
}

- (void)sdkLogger:(DHXcodeSDKLogger *)sdkLogger logStream:(NSString *)log {
    if (!kDHXcodeVerbose) { return ; }
    [self commonReceivedLog:log type:DHLogTypeScriptOutputStream];
}

// MARK: - 重定向日志
- (void)redirectLog {
    [self redirectSTD:STDOUT_FILENO];
    [self redirectSTD:STDERR_FILENO];
}

- (void)redirectSTD:(int)fd {
    NSPipe * pipe = [NSPipe pipe] ;// 初始化一个NSPipe 对象
    NSFileHandle *pipeReadHandle = [pipe fileHandleForReading] ;
    dup2([[pipe fileHandleForWriting] fileDescriptor], fd) ;
     
    // 注册读取文件完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redirectNotificationHandle:)
                                                 name:NSFileHandleReadCompletionNotification
                                               object:pipeReadHandle];
    [pipeReadHandle readInBackgroundAndNotify];
}

- (void)redirectNotificationHandle:(NSNotification *)sender {
    // 转化接收到的日志
    NSData *data = [sender.userInfo objectForKey:NSFileHandleNotificationDataItem];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // 输出
    [_delegate logger:self withString:str];
    // 后台继续接收
    [[sender object] readInBackgroundAndNotify];
}

- (void)redirectNSlogToDocumentFolder {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *fileName = [NSString stringWithFormat:@"LOG-%@.txt",[dateformat stringFromDate:[NSDate date]]];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    NSLog(@"logFilePath: %@", logFilePath);
    // 先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    NSLog(@"%@",logFilePath);
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

@end
