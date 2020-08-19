//
//  DHObjectTools.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHObjectTools : NSObject

/// 是否是有效的字符串
+ (BOOL)isValidString:(NSString *)string;
/// 是否是有效的数组
+ (BOOL)isValidArray:(NSArray *)object;
/// 是否是有效的字典
+ (BOOL)isValidDictionary:(NSDictionary *)object;
/// 正则判定匹配
+ (BOOL)validateWithRegExp:(NSString *)regExp text:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
