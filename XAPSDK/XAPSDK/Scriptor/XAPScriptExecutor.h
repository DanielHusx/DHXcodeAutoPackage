//
//  XAPScriptExecutor.h
//  XAPSDK
//
//  Created by Daniel on 2020/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XAPScriptExecutor;
@protocol XAPScriptExecutorDelegate <NSObject>
/// 延时命令的输出流
- (void)executor:(XAPScriptExecutor *)executor outputStream:(id)outputStream;
/// 延时命令的错误流
- (void)executor:(XAPScriptExecutor *)executor errorStream:(id)errorStream;

@end


@class XAPScriptModel;
@interface XAPScriptExecutor : NSObject
/// 代理
@property (nonatomic, weak) id<XAPScriptExecutorDelegate> delegate;

/// 单例
+ (instancetype)sharedExecutor;

/// 执行脚本命令
///
/// @param scriptModel 命令
/// @param error 错误
/// @return output
- (id __nullable)execute:(XAPScriptModel *)scriptModel
                   error:(NSError * __nullable __autoreleasing * __nullable)error;
/// 中断命令
- (void)interrupt;

@end

NS_ASSUME_NONNULL_END
