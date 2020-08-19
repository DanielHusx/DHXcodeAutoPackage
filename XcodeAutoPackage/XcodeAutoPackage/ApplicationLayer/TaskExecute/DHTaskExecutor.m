//
//  DHTaskExecutor.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/27.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskExecutor.h"
#import "DHTaskModel.h"
#import "DHTaskHandlerManager.h"
#import "NSMutableArray+DHQueue.h"

@interface DHTaskExecutor ()
/// 任务队列（FIFO）
@property (nonatomic, strong) NSMutableArray *taskQueue;
/// 队列
@property (nonatomic, strong) dispatch_queue_t eQueue;
/// 是否正在执行
@property (nonatomic, readwrite, assign, getter=isRunning) BOOL running;
/// 中断
@property (nonatomic, assign, getter=isInterrupt) BOOL interrupt;
/// 进度
//@property (nonatomic, strong) NSProgress *taskProgress;

@end

@implementation DHTaskExecutor

#pragma mark - singleton
+ (instancetype)executor {
    static DHTaskExecutor *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DHTaskExecutor alloc] init];
        [_instance setupInitialization];
        
    });
    return _instance;
}

- (void)setupInitialization {
    _taskQueue = [NSMutableArray array];
    _eQueue = dispatch_queue_create("DHTaskExecutor", DISPATCH_QUEUE_SERIAL);
    _running = NO;
    
    [self addObserver:self forKeyPath:@"taskQueue" options:NSKeyValueObservingOptionNew context:nil];
}


#pragma mark - public method
- (void)executeTasks:(id)tasks {
    [self checkTasks:tasks];
}

- (void)interruptAllTask {
    self.interrupt = YES;
}

#pragma mark - observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"taskQueue"]) {
        [self queryTask];
    }
}

#pragma mark - private method
// 检查传进来的参数
- (void)checkTasks:(id)tasks {
    if (self.isRunning) { return ; }
    
    if ([tasks isKindOfClass:[DHTaskModel class]]) {
        [self pushTasks:@[tasks]];
        return ;
    }
    
    if ([tasks isKindOfClass:[NSArray class]]) {
        if ([tasks count] == 0) { return ; }
        // 过滤非DHTaskModel对象
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:[tasks count]];
        for (id t in tasks) {
            if ([t isKindOfClass:[DHTaskModel class]]) {
                [temp addObject:t];
            }
        }
        if ([temp count] == 0) { return ; }
        
        [self pushTasks:temp];
    }
}

#pragma mark - queue
// 加入队列
- (void)pushTasks:(NSArray *)tasks {
    [self willChangeValueForKey:@"taskQueue"];
    for (NSInteger i = tasks.count-1; i >= 0; i--) {
        DHTaskModel *task = tasks[i];
        [self.taskQueue push:task];
    }
    [self didChangeValueForKey:@"taskQueue"];
}

// 下一个任务
- (DHTaskModel *)popTask {
    return [self.taskQueue pop];
}

// 清空
- (void)clearTasks {
    [self.taskQueue clear];
}

#pragma mark - working
// 万剑归宗入口
- (void)queryTask {
    self.running = YES;
    int64_t totalUnitCount = [self totalUnitCount];
    self.taskProgress = [NSProgress progressWithTotalUnitCount:totalUnitCount];
    
    DHLogInfo(@"Runing XcodeAutoPackage: Task count:%zd Total unit:%lld", [self.taskQueue count], totalUnitCount);
    [self processTasks];
}

- (int64_t)totalUnitCount {
    int64_t total = 0;
    for (DHTaskModel *task in self.taskQueue) {
        total += [DHTaskHandlerManager totalUnitCountForTask:task];
    }
    return total;
}

- (void)processTasks {
    // 中断
    if (self.isInterrupt) {
        [self resetSignal];
        return ;
    }
    
    // 弹出下一个任务
    DHTaskModel *task = [self popTask];
    if (!task) {
        [self resetSignal];
        DHLogInfo(@"任务全部执行完成");
        return ;
    }
    
    // 线程执行命令
    __weak typeof(self) weakself = self;
    dispatch_async(_eQueue, ^{
        BOOL ret = NO;
        ret = [weakself executeTask:task];
        // 执行出错
        if (!ret) {
            [weakself resetSignal];
            return ;
        }
        // 正确执行
        [weakself processTasks];
    });
}

// 执行任务
- (BOOL)executeTask:(DHTaskModel *)task {
    BOOL ret = NO;
    ret = [DHTaskHandlerManager prepareHandlersForTask:task];
    if (!ret) { return NO; }
    
    ret = [DHTaskHandlerManager checkHandlesExecuatable:task];
    if (!ret) { return NO; }
    
    __weak typeof(self) weakself = self;
    int64_t currentCompletedUnitCount = self.taskProgress.completedUnitCount;
    ret = [DHTaskHandlerManager handleTask:task progress:^(NSProgress * _Nonnull handlerProgress) {
        weakself.taskProgress.completedUnitCount = currentCompletedUnitCount + handlerProgress.completedUnitCount;
    } completionHandler:^(NSString * _Nonnull desc) {
        DHLogInfo(@"%@", desc);
    }];
    if (!ret) { return NO; }
    
    return YES;
}

- (void)resetSignal {
    [self clearTasks];
    self.running = NO;
    self.interrupt = NO;
    self.taskProgress = nil;
}

- (void)setInterrupt:(BOOL)interrupt {
    _interrupt = interrupt;
    
    if (!interrupt) { return ; }
    // 核心中断方法
    [DHTaskHandlerManager interruptTask];
}

@end
