//
//  DHLogConfig.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/8/2.
//  Copyright © 2020 Daniel. All rights reserved.
//

#ifndef DHLogConfig_h
#define DHLogConfig_h
#import "DHLogger+DHPrivate.h"

#ifndef DEBUG
#define DHLogDebug(frmt, ...) [[DHLogger shareLogger] logDebug:[NSString stringWithFormat:(@"%s\n" frmt), __PRETTY_FUNCTION__, ##__VA_ARGS__]]
#define DHLogInfo(frmt, ...) [[DHLogger shareLogger] logInfo:[NSString stringWithFormat:(@"%s\n" frmt), __PRETTY_FUNCTION__, ##__VA_ARGS__]]
#define DHLogError(frmt, ...) [[DHLogger shareLogger] logError:[NSString stringWithFormat:(@"%s\n" frmt), __PRETTY_FUNCTION__, ##__VA_ARGS__]]
#define DHLogWarning(frmt, ...) [[DHLogger shareLogger] logWarning:[NSString stringWithFormat:(@"%s\n" frmt), __PRETTY_FUNCTION__, ##__VA_ARGS__]]

#else
#define DHLogDebug(frmt, ...) [[DHLogger shareLogger] logDebug:[NSString stringWithFormat:(@"" frmt), ##__VA_ARGS__]]
#define DHLogInfo(frmt, ...) [[DHLogger shareLogger] logInfo:[NSString stringWithFormat:(@"" frmt), ##__VA_ARGS__]]
#define DHLogError(frmt, ...) [[DHLogger shareLogger] logError:[NSString stringWithFormat:(@"" frmt), ##__VA_ARGS__]]
#define DHLogWarning(frmt, ...) [[DHLogger shareLogger] logWarning:[NSString stringWithFormat:(@"" frmt), ##__VA_ARGS__]]

#endif

#endif /* DHLogConfig_h */
