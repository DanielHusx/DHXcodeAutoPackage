//
//  XAPZipTools.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XAPZipTools : NSObject
/// 解压.ipa文件至所在目录
/// @param ipaFile .ipa文件
/// @return 解压目录
+ (NSString * _Nullable)unzipIPAFile:(NSString *)ipaFile;

/// 解压ipa文件至指定目录
/// @param ipaFile .ipa文件
/// @param destination 目标目录
/// @return 解压目录
+ (NSString * _Nullable)unzipIPAFile:(NSString *)ipaFile
                       toDestination:(NSString *)destination;

@end

NS_ASSUME_NONNULL_END
