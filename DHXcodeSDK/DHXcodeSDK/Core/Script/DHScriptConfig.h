//
//  DHScriptConfig.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/17.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHScriptConfig : NSObject

/// 获取xcodebuild命令路径
/// @param script out 命令路径
/// @param error out 错误
/// @param asAdministrator out 是否需要管理员权限执行
/// @return YES: 获取成功；NO：获取失败
+ (BOOL)fetchXcodebuildScript:(NSString * _Nonnull __autoreleasing * _Nonnull)script
                        error:(NSError * _Nullable __autoreleasing * _Nullable)error
              asAdministrator:(BOOL *)asAdministrator;

/// 获取security命令路径
/// @param script out 命令路径
/// @param error out 错误
/// @param asAdministrator out 是否需要管理员权限执行
/// @return YES: 获取成功；NO：获取失败
+ (BOOL)fetchSecurityScript:(NSString * _Nonnull __autoreleasing * _Nonnull)script
                      error:(NSError * _Nullable __autoreleasing * _Nullable)error
            asAdministrator:(BOOL *)asAdministrator;

/// 获取lipo命令路径
/// @param script out 命令路径
/// @param error out 错误
/// @param asAdministrator out 是否需要管理员权限执行
/// @return YES: 获取成功；NO：获取失败
+ (BOOL)fetchLipoScript:(NSString * _Nonnull __autoreleasing * _Nonnull)script
                  error:(NSError * _Nullable __autoreleasing * _Nullable)error
        asAdministrator:(BOOL *)asAdministrator;

/// 获取plistbuddy命令路径
/// @param script out 命令路径
/// @param error out 错误
/// @param asAdministrator out 是否需要管理员权限执行
/// @return YES: 获取成功；NO：获取失败
+ (BOOL)fetchPlistbuddyScript:(NSString * _Nonnull __autoreleasing * _Nonnull)script
                        error:(NSError * _Nullable __autoreleasing * _Nullable)error
              asAdministrator:(BOOL *)asAdministrator;

/// 获取codesign命令路径
/// @param script out 命令路径
/// @param error out 错误
/// @param asAdministrator out 是否需要管理员权限执行
/// @return YES: 获取成功；NO：获取失败
+ (BOOL)fetchCodesignScript:(NSString * _Nonnull __autoreleasing * _Nonnull)script
                      error:(NSError * _Nullable __autoreleasing * _Nullable)error
            asAdministrator:(BOOL *)asAdministrator;

/// 获取ruby命令路径
/// @param script out 命令路径
/// @param error out 错误
/// @param asAdministrator out 是否需要管理员权限执行
/// @return YES: 获取成功；NO：获取失败
+ (BOOL)fetchRubyScript:(NSString * _Nonnull __autoreleasing * _Nonnull)script
                  error:(NSError * _Nullable __autoreleasing * _Nullable)error
        asAdministrator:(BOOL *)asAdministrator;

/// 获取git命令路径
/// @param script out 命令路径
/// @param error out 错误
/// @param asAdministrator out 是否需要管理员权限执行
/// @return YES: 获取成功；NO：获取失败
+ (BOOL)fetchGitScript:(NSString * _Nonnull __autoreleasing * _Nonnull)script
                 error:(NSError * _Nullable __autoreleasing * _Nullable)error
       asAdministrator:(BOOL *)asAdministrator;

/// 获取pod命令路径
/// @param script out 命令路径
/// @param error out 错误
/// @param asAdministrator out 是否需要管理员权限执行
/// @return YES: 获取成功；NO：获取失败
+ (BOOL)fetchPodScript:(NSString * _Nonnull __autoreleasing * _Nonnull)script
                 error:(NSError * _Nullable __autoreleasing * _Nullable)error
       asAdministrator:(BOOL *)asAdministrator;

/// 获取otool命令路径
/// @param script out 命令路径
/// @param error out 错误
/// @param asAdministrator out 是否需要管理员权限执行
/// @return YES: 获取成功；NO：获取失败
+ (BOOL)fetchOtoolScript:(NSString * _Nonnull __autoreleasing * _Nonnull)script
                   error:(NSError * _Nullable __autoreleasing * _Nullable)error
         asAdministrator:(BOOL *)asAdministrator;

/// 获取which命令路径
/// @param script out 命令路径
/// @param error out 错误
/// @param asAdministrator out 是否需要管理员权限执行
/// @return YES: 获取成功；NO：获取失败
+ (BOOL)fetchWhichScript:(NSString * _Nonnull __autoreleasing * _Nonnull)script
                   error:(NSError * _Nullable __autoreleasing * _Nullable)error
         asAdministrator:(BOOL *)asAdministrator;

@end

NS_ASSUME_NONNULL_END
