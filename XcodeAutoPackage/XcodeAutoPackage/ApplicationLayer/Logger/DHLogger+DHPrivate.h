//
//  DHLogger+DHPrivate.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/8/2.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHLogger ()

- (void)logDebug:(NSString *)debug;
- (void)logInfo:(NSString *)info;
- (void)logError:(NSString *)error;
- (void)logWarning:(NSString *)warning;

@end

NS_ASSUME_NONNULL_END
