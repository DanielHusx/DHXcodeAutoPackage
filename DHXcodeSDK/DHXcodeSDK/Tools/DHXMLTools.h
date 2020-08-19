//
//  DHXMLTools.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHXMLTools : NSObject
/// 解析xml字符串
+ (NSDictionary *)dictionaryForXMLString:(NSString *)xmlString;
/// 创建plist
+ (NSXMLDocument *)createPlistWithNode:(NSXMLNode *)node;
/// 保存xml
+ (DHERROR_CODE)writeXMLDocument:(NSXMLDocument *)docment toFile:(NSString *)file;

@end

NS_ASSUME_NONNULL_END
