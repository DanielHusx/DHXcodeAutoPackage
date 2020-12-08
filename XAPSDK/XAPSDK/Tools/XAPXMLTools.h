//
//  XAPXMLTools.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XAPXMLTools : NSObject

/// 解析XML文件
+ (NSDictionary *)dictionaryWithXMLFile:(NSString *)xmlFile;

@end

NS_ASSUME_NONNULL_END
