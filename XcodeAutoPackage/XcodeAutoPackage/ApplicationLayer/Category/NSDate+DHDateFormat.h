//
//  NSDate+DHDateFormat.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (DHDateFormat)
/// yyyy-MM-dd
- (NSString *)stringFormatMiddleLine;
/// yyyy_MM_dd_HH_mm_ss
- (NSString *)stringFormatBottomLine;
/// 距离当前天数
- (NSInteger)dayIntervalSinceNow;
@end

NS_ASSUME_NONNULL_END
