//
//  XAPConfigurationParser.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XAPConfigurationModel;
@class XAPEngineerModel;

@interface XAPConfigurationParser : NSObject

/// 单例
+ (instancetype)sharedParser;

/// 根据工程信息，配置配置信息
/// @param engineerInfo 工程信息
/// @param error [out] 错误信息
/// @return 返回配置信息
- (XAPConfigurationModel *)parseConfigurationWithEngineerInfo:(XAPEngineerModel *)engineerInfo
                                                        error:(NSError * __autoreleasing _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
