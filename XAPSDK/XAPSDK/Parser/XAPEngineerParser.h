//
//  XAPEngineerParser.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XAPEngineerParser : NSObject

/// 单例
+ (instancetype)sharedParser;

/// 从路径中解析工程信息
/// @param path 路径
/// @param error [out] 错误信息
/// @return 返回解析后的工程信息或数组
- (id)parseEngineerWithPath:(NSString *)path
                      error:(NSError * __autoreleasing _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
