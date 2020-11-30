//
//  XAPScriptPathManager.h
//  XAPSDK
//
//  Created by Daniel on 2020/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * XAPScriptPathKey NS_STRING_ENUM;

FOUNDATION_EXTERN XAPScriptPathKey const kXAPScriptPathKeyXcodebuild;
FOUNDATION_EXTERN XAPScriptPathKey const kXAPScriptPathKeySecurity;
FOUNDATION_EXTERN XAPScriptPathKey const kXAPScriptPathKeyLipo;
FOUNDATION_EXTERN XAPScriptPathKey const kXAPScriptPathKeyPlistbuddy;
FOUNDATION_EXTERN XAPScriptPathKey const kXAPScriptPathKeyCodesign;
FOUNDATION_EXTERN XAPScriptPathKey const kXAPScriptPathKeyRuby ;
FOUNDATION_EXTERN XAPScriptPathKey const kXAPScriptPathKeyGit;
FOUNDATION_EXTERN XAPScriptPathKey const kXAPScriptPathKeyOtool;
FOUNDATION_EXTERN XAPScriptPathKey const kXAPScriptPathKeyPod;
FOUNDATION_EXTERN XAPScriptPathKey const kXAPScriptPathKeyWhich;
FOUNDATION_EXTERN XAPScriptPathKey const kXAPScriptPathKeyXcrun;
FOUNDATION_EXTERN XAPScriptPathKey const kXAPScriptPathKeyRM;
FOUNDATION_EXTERN XAPScriptPathKey const kXAPScriptPathKeyUnzip;

@interface XAPScriptPathManager : NSObject

/// 单例
+ (instancetype)manager;
/// 命令脚本路径
- (NSString * __nullable)scriptPathForKey:(XAPScriptPathKey)key;

@end

NS_ASSUME_NONNULL_END
