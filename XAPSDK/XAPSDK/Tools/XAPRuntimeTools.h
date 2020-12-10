//
//  XAPRuntimeTools.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XAPRuntimeTools : NSObject

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
