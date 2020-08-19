//
//  NSArray+DHArrayExtension.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/16.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "NSArray+DHArrayExtension.h"

@implementation NSArray (DHArrayExtension)

- (id)safeObjectAtIndex:(NSInteger)index {
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self objectAtIndex:index];
}

@end
