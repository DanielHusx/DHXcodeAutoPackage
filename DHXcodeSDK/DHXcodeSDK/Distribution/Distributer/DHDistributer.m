//
//  DHDistributer.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHDistributer.h"
#import "DHDistributeManager.h"
#import "DHRuntimeTools.h"

@interface DHDistributer ()

@end
@implementation DHDistributer
/// 上传ipa文件至发布平台
///
/// @param ipaFile ipa文件
/// @param platform 平台信息
/// @param uploadProgressHandler 上传进度回调
/// @param completionHandler 完成回调
- (void)distributeIPAFile:(NSString *)ipaFile
               toPlatform:(id<DHDistributionProtocol>)platform
    uploadProgressHandler:(nullable void (^)(NSProgress *uploadProgress))uploadProgressHandler
        completionHandler:(nonnull void (^) (BOOL succeed, NSError *_Nullable error))completionHandler {
    // implement in subclass
}

/// 中断上传
+ (void)interrupt {
    [[DHDistributeManager manager] interrupt];
}


+ (BOOL)supportsSecureCoding {
    return YES;
}


- (void)encodeWithCoder:(NSCoder *)coder {
    [DHRuntimeTools encodeObject:self coder:coder];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (self) {
        [DHRuntimeTools decodeObject:self coder:coder];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    id copyObj = [[[self class] allocWithZone:zone] init];
    if (copyObj) {
        [DHRuntimeTools copyObject:copyObj fromObject:self];
    }
    return copyObj;
}


@end
