//
//  DHTaskFactory.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/25.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHTaskModel;
NS_ASSUME_NONNULL_BEGIN

@interface DHTaskFactory : NSObject
/// 根据路径获取任务
/// @param path 路径
+ (DHTaskModel *)getTaskWithPath:(NSString *)path
                           error:(NSError * _Nullable __autoreleasing * _Nonnull)error;

@end

NS_ASSUME_NONNULL_END
