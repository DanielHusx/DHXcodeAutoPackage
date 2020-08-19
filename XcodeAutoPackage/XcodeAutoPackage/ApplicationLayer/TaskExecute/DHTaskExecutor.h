//
//  DHTaskExecutor.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/27.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHTaskModel;
NS_ASSUME_NONNULL_BEGIN
/**
 任务执行者
 */
@interface DHTaskExecutor : NSObject
/// 是否正在执行
@property (nonatomic, readonly, assign, getter=isRunning) BOOL running;
/// 进度
@property (nonatomic, strong, nullable) NSProgress *taskProgress;

/// 单例
+ (instancetype)executor;

/// 执行
/// @param tasks DHTaskModel or @[DHTaskModel, ...]
- (void)executeTasks:(id)tasks;

/// 中止所有任务
- (void)interruptAllTask;

@end

NS_ASSUME_NONNULL_END
