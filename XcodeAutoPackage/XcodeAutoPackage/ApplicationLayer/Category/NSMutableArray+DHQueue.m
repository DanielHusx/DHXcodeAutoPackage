//
//  NSMutableArray+DHQueue.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/27.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "NSMutableArray+DHQueue.h"

@implementation NSMutableArray (DHQueue)
- (id)top { return self.firstObject; }

- (id)pop {
    id obj = self.firstObject;
    if (obj) { [self removeObjectAtIndex:0]; }
    return obj;
}

- (BOOL)push:(id)obj {
    if (!obj) return NO;
    [self addObject:obj];
    return YES;
}

- (NSInteger)size { return self.count; }

- (void)clear { [self removeAllObjects]; }

- (void)show {
    NSLog(@"%@", self);
}
@end
