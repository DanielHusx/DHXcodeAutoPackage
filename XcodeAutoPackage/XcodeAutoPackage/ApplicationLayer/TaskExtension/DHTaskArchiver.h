//
//  DHTaskArchiver.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHTaskModel;
NS_ASSUME_NONNULL_BEGIN

@interface DHTaskArchiver : NSObject

/// 归档 任务数组
+ (BOOL)archiveTaskArray:(NSArray <DHTaskModel *> *)taskArray;
/// 解档 任务数组
+ (nullable NSArray <DHTaskModel *> *)unarchivedTaskArray;

@end

NS_ASSUME_NONNULL_END
