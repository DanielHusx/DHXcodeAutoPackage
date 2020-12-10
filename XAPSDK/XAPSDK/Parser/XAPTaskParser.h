//
//  XAPTaskParser.h
//  XAPSDK
//
//  Created by 菲凡数据 on 2020/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XAPTaskModel;

@interface XAPTaskParser : NSObject

/// 单例
+ (instancetype)sharedParser;

/// 解析路径
///
/// @param path 文件或文档路径
/// @param error 错误反馈
/// @return 任务模型
- (XAPTaskModel *)parse:(NSString *)path
                  error:(NSError * __autoreleasing _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
