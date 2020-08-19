//
//  DHArchiver.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHXcodeSDKError.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHArchiver : NSObject
/// 归档
+ (DHERROR_CODE)archiveObject:(NSObject *)object withFile:(NSString *)file;
/// 解档
+ (DHERROR_CODE)unarchivedObjectOfClasses:(NSSet *)classes
                                 withFile:(NSString *)file
                         unarchivedObject:(NSObject * _Nullable __autoreleasing * _Nonnull)unarchivedObject;

@end

NS_ASSUME_NONNULL_END
