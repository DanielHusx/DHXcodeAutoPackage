//
//  DHScriptExecutor.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/17.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHScriptModel;
NS_ASSUME_NONNULL_BEGIN

@interface DHScriptExecutor : NSObject

@end

@interface DHScriptExecutor (NSAppleScript)

/// 执行脚本指令
/// @discussion 使用NSAppleScript执行命令，可及时得到反馈
///
/// @param command 命令数据
/// @param output 输出
/// @param error 错误
/// @return YES: 执行结果正确 NO: 失败
+ (BOOL)executeCommand:(DHScriptModel *)command
                output:(NSString * _Nullable __autoreleasing * _Nullable)output
                 error:(NSError * _Nonnull __autoreleasing * _Nonnull)error;

@end


@interface DHScriptExecutor (NSTask)

/// 执行脚本命令
/// @discussion 使用NSTask执行命令，输出以流反馈
///
/// @param command 命令数据
/// @param error 错误是执行错误，执行结果以流反馈
/// @param outputStream 正常输出流
/// @param errorStream 错误输出流
/// @return YES: 正确执行 NO: 错误执行
+ (BOOL)executeCommand:(DHScriptModel *)command
                 error:(NSError * _Nonnull __autoreleasing * _Nonnull)error
          outputStream:(nullable void (^) (NSString *))outputStream
           errorStream:(nullable void (^) (NSString *))errorStream;

/// 中断命令
/// @discussion 只可中断由NSTask构建的命令
+ (void)interrupt;

@end

NS_ASSUME_NONNULL_END
