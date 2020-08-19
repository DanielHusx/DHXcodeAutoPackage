//
//  DHTaskHandlerManager.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/18.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHTaskModel;
NS_ASSUME_NONNULL_BEGIN

@interface DHTaskHandlerManager : NSObject

/// 预处理数据
+ (BOOL)prepareHandlersForTask:(DHTaskModel *)task;
/// 校验数据是否可有效执行
+ (BOOL)checkHandlesExecuatable:(DHTaskModel *)task;
/// 中断任务
+ (void)interruptTask;
/// 执行任务
+ (BOOL)handleTask:(DHTaskModel *)task progress:(void (^) (NSProgress *))progress completionHandler:(nullable void (^) (NSString *))completionHandler;
/// 单个任务的任务数量
+ (int64_t)totalUnitCountForTask:(DHTaskModel *)task;

@end

NS_ASSUME_NONNULL_END
