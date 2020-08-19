//
//  DHRuntimeTools.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHRuntimeTools : NSObject

/// 加密
+ (void)encodeObject:(NSObject *)obj coder:(NSCoder *)aCoder;
/// 解密
+ (void)decodeObject:(NSObject *)obj coder:(NSCoder *)aDecoder;

/// copy
+ (void)copyObject:(__kindof NSObject *)copyObj fromObject:(__kindof NSObject *)obj;
/// mutable copy
+ (void)mutableCopyObject:(NSObject *)mutableCopyObj fromObject:(NSObject *)obj;

@end

NS_ASSUME_NONNULL_END
