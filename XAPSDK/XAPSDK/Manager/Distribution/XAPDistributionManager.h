//
//  XAPDistributionManager.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 封装请求接口
 */
@interface XAPDistributionManager : NSObject

/// 单例
+ (instancetype)manager;

/// POST请求
/// @param URLString 请求地址
/// @param parameters 请求参数
/// @param uploadProgress 上传进度
/// @param success 成功回调
/// @param failure 失败回调
- (void)POST:(NSString *)URLString
  parameters:(nullable id)parameters
    progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
     success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

/// 上传文件请求
/// @param URLString 请求地址
/// @param parameters 请求参数
/// @param fileURL 上传文件
/// @param fileName 上传文件名（服务器接收的参数名）
/// @param uploadProgress 上传进度
/// @param success 成功回调
/// @param failure 失败回调
- (void)POST:(NSString *)URLString
  parameters:(nullable id)parameters
     fileURL:(nullable NSURL *)fileURL
     fileName:(nullable NSString *)fileName
    progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
     success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

/// 中断
- (void)interrupt;

@end

NS_ASSUME_NONNULL_END
