//
//  DHXcodeSDKConfig.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/7/30.
//  Copyright © 2020 Daniel. All rights reserved.
//

#ifndef DHXcodeSDKConfig_h
#define DHXcodeSDKConfig_h
#import "DHXcodeSDKLogger+Private.h"
#import "DHXcodeSDKMacro.h"
#import <Foundation/Foundation.h>
#define DH_ERROR_MAKER_CONVINENT(dh_code, rOrE) if (error) { *error = DH_ERROR_MAKER(dh_code, rOrE); }

#define DH_ERROR_MAKER(dh_code, rOrE) [rOrE isKindOfClass:[NSError class]]?DH_ERROR_MAKE_ERROR(dh_code, rOrE):DH_ERROR_MAKE_REASON(dh_code, rOrE)

#define DH_ERROR_MAKE_FORMAT(dh_code, ...) [NSError errorWithDomain:kDHDBErrorDomain code:dh_code userInfo:@{NSLocalizedFailureReasonErrorKey:##__VA_ARGS__}]
#define DH_ERROR_MAKE_REASON(dh_code, reason) [NSError errorWithDomain:kDHDBErrorDomain code:dh_code userInfo:@{NSLocalizedFailureReasonErrorKey:[NSString stringWithFormat:@"%@", reason]}]

#define DH_ERROR_MAKE_ERROR(dh_code, otherError) [NSError errorWithDomain:kDHDBErrorDomain code:dh_code userInfo:((NSError *)otherError).userInfo]

// 普通日志
#define DHXcodeLog(...) [[DHXcodeSDKLogger logger] log:[NSString stringWithFormat:__VA_ARGS__]]

// 流日志
#define DHXcodePrintf(...)                                         \
    if (kDHXcodeVerbose) {                                              \
        [[DHXcodeSDKLogger logger] log:[NSString stringWithFormat:__VA_ARGS__]];\
    }
//        fflush(stdout);                                                 \
//        printf(("stream: " fmt), ##__VA_ARGS__);                        \
    }


static NSString *kDHDBErrorDomain = @"com.daniel.dberror";

static inline BOOL dh_isNoError(DHERROR_CODE code) {
    return code == DHERROR_NO_ERROR;
}

/// 校验是否读取到的Plist值是否是关联值
static inline BOOL checkPlistValueRelatived(NSString *value) {
    if (![value isKindOfClass:[NSString class]]) { return NO; }
    return [value hasPrefix:@"$("] && [value hasSuffix:@")"];
}

/// 从关联值获取key
static inline NSString * fetchBuildSettingsKeyWithPlistRelativeValue(NSString *value) {
    NSUInteger startMarkLength = @"$(".length;
    NSUInteger endMarkLength = @")".length;
    return [value substringWithRange:NSMakeRange(startMarkLength, value.length - startMarkLength - endMarkLength)];
}

#endif /* DHXcodeSDKConfig_h */
