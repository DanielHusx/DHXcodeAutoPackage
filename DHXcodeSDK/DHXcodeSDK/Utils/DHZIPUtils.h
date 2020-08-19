//
//  DHZIPUtils.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHZIPUtils : NSObject
/// 解压.ipa文件至所在目录
/// @param ipaFile .ipa文件
/// @return 解压目录
+ (nullable NSString *)unzipIPAFile:(NSString *)ipaFile;

/// 解压ipa文件至指定目录
/// @param ipaFile .ipa文件
/// @param destination 目标目录
/// @return 解压目录
+ (nullable NSString *)unzipIPAFile:(NSString *)ipaFile toDestination:(NSString *)destination;

@end

NS_ASSUME_NONNULL_END
