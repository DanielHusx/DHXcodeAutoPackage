//
//  DHObjectTools.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHObjectTools.h"

@implementation DHObjectTools

+ (BOOL)isValidString:(NSString *)string {
    if ([string isKindOfClass:[NSString class]]) {
        return string.length != 0;
    }
    return NO;
}

+ (BOOL)isValidArray:(NSArray *)object {
    if ([object isKindOfClass:[NSArray class]]) {
        return [object count] != 0;
    }
    return NO;
}

+ (BOOL)isValidDictionary:(NSDictionary *)object {
    if ([object isKindOfClass:[NSDictionary class]]) {
        return [object count] != 0;
    }
    return NO;
}

+ (BOOL)validateWithRegExp:(NSString *)regExp text:(NSString *)text {
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:text];

}


@end
