//
//  DHDistributionModel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/18.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHDistributionModel.h"
#import "DHRuntimeTools.h"
#import "DHDistributer.h"

@implementation DHDistributionModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _identity = @((NSInteger)[[NSDate date] timeIntervalSince1970]).stringValue;
        _platformType = kDHDistributionPlatformNone;
        _nickname = kDHDistributionPlatformNone;
        _distributer = [[DHDistributer alloc] init];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [DHRuntimeTools encodeObject:self coder:coder];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        [DHRuntimeTools decodeObject:self coder:coder];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    id copyObj = [[[self class] allocWithZone:zone] init];
    if (copyObj) {
        [DHRuntimeTools copyObject:copyObj fromObject:self];
    }
    return copyObj;
}

- (BOOL)isEqual:(id)object {
    if (![object conformsToProtocol:@protocol(DHDistributionProtocol)]) return NO;
    id<DHDistributionProtocol> d = object;
    return [d.identity isEqualToString:self.identity];   
}

@end
