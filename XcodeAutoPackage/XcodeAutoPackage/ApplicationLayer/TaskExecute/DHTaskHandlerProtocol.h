//
//  DHTaskHandlerProtocol.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/18.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
/// 总任务默认数
#define kDHTotalUnitCount 100

NS_ASSUME_NONNULL_BEGIN
@class DHTaskModel;
@protocol DHTaskHandlerProtocol <NSObject>

///// 进度管理
//@property (nonatomic, strong) NSProgress *progress;
/// 校验task是否需要处理
+ (BOOL)checkTaskHandleable:(DHTaskModel *)task;
/// 校验task是否可执行此任务
- (BOOL)isTaskHandlerExecutable:(DHTaskModel *)task;
/// 执行任务
- (BOOL)handleTask:(DHTaskModel *)task progress:(void (^) (NSProgress *))progress;
/// 中断执行任务
- (void)interruptTask;
/// 总的任务执行数
+ (int64_t)totalUnitCount;

@end

NS_ASSUME_NONNULL_END
