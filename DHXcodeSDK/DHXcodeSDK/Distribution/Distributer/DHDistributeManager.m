//
//  DHDistributeManager.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHDistributeManager.h"
#import "AFNetworking.h"


@interface DHDistributeManager ()
/// 正在执行中的上传task
@property (nonatomic, strong) NSURLSessionTask *processingTask;
@end

@implementation DHDistributeManager

+ (instancetype)manager {
    static DHDistributeManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DHDistributeManager alloc] init];
    });
    return _instance;
}

- (void)POST:(NSString *)URLString
  parameters:(nullable id)parameters
    progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
     success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:URLString
       parameters:parameters
         progress:uploadProgress
          success:success
          failure:failure];
}

- (void)POST:(NSString *)URLString
  parameters:(nullable id)parameters
     fileURL:(nullable NSURL *)fileURL
    fileName:(nullable NSString *)fileName
    progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
     success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    _processingTask = [manager POST:URLString
                         parameters:parameters
          constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:fileURL name:fileName error:nil];
    }
                           progress:uploadProgress
                            success:success
                            failure:failure];
}

- (void)interrupt {
    if (!_processingTask) { return ; }
    if (_processingTask.state != NSURLSessionTaskStateRunning) { return ; }
    
    [_processingTask cancel];
}


@end
