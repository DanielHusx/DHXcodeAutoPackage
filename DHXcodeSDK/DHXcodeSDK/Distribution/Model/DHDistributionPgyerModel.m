//
//  DHDistributionPgyerModel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHDistributionPgyerModel.h"
#import "DHRuntimeTools.h"
#import "DHPgyerDistributer.h"

@implementation DHDistributionPgyerModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _identity = @((NSInteger)[[NSDate date] timeIntervalSince1970]).stringValue;
        _distributer = [[DHPgyerDistributer alloc] init];
    }
    return self;
}

- (DHDistributionPlatform)platformType {
    return kDHDistributionPlatformPgyer;
}

- (NSNumber *)installType {
    return @(DHDistributionPgyerInstallTypePassword);
}

- (NSNumber *)installDateLimitType {
    return nil;
}

- (NSDate *)installStartDate {
    return nil;
}

- (NSDate *)installEndDate {
    return nil;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [DHRuntimeTools encodeObject:self coder:coder];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [self init];
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

- (NSString *)description {
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-------Pgyer--------\n"];
    [result appendFormat:@"identity: %@\n", self.identity];
    [result appendFormat:@"platform: %@\n", self.platformType];
    [result appendFormat:@"nickname: %@\n", self.nickname];
    [result appendFormat:@"API_KEY: %@\n", self.platformApiKey];
    [result appendFormat:@"installPassword: %@\n", self.installPassword];
    [result appendFormat:@"installType: %@\n", self.installType];
    [result appendFormat:@"appDisplayName: %@\n", self.appDisplayName];
    [result appendFormat:@"changeLog: %@\n", self.changeLog];
    
    return [result copy];
}

@end
