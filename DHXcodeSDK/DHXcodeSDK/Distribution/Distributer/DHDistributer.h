//
//  DHDistributer.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DHDistributionProtocol;
NS_ASSUME_NONNULL_BEGIN

@interface DHDistributer : NSObject <NSSecureCoding, NSCoding, NSCopying>

/// 上传ipa文件至发布平台
///
/// @param ipaFile ipa文件
/// @param platform 平台信息
/// @param uploadProgressHandler 上传进度回调
/// @param completionHandler 完成回调
- (void)distributeIPAFile:(NSString *)ipaFile
               toPlatform:(id<DHDistributionProtocol>)platform
    uploadProgressHandler:(nullable void (^)(NSProgress *uploadProgress))uploadProgressHandler
        completionHandler:(nonnull void (^) (BOOL succeed, NSError *_Nullable error))completionHandler;

/// 中断上传
+ (void)interrupt;

@end

NS_ASSUME_NONNULL_END
