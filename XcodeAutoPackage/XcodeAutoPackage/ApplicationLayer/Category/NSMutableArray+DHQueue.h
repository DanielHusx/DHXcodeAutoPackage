//
//  NSMutableArray+DHQueue.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/27.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (DHQueue)
/// 队列顶部
- (nullable id)top;
/// 弹出队列顶部
- (nullable id)pop;
/// 压入队列底部
- (BOOL)push:(id)obj;
/// 清空队列
- (void)clear;
/// 打印队列
- (void)show;
/// 队列长度
- (NSInteger)size;

@end

NS_ASSUME_NONNULL_END
