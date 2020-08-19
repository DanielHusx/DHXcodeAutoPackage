//
//  NSDate+DHDateFormat.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/26.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "NSDate+DHDateFormat.h"

@implementation NSDate (DHDateFormat)

- (NSString *)stringFormatMiddleLine {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:self];
}

- (NSString *)stringFormatBottomLine {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
    return [format stringFromDate:self];
}

- (NSInteger)dayIntervalSinceNow {
    NSTimeInterval interval = [self timeIntervalSinceDate:[NSDate date]];
    NSInteger day = interval / (60 * 60 * 24);
    return day;
}

@end
