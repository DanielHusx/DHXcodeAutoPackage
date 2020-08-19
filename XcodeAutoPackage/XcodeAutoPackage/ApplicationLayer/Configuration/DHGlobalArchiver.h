//
//  DHGlobalArchiver.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/27.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHGlobalArchiver : NSObject
/// 归档 全局配置
+ (BOOL)archiveGlobalConfiguration;

/// 解档 全局配置
+ (BOOL)unarchiveGlobalConfiguration;

@end

NS_ASSUME_NONNULL_END
