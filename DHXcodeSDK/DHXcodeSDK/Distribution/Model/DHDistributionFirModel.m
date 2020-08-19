//
//  DHDistributionFirModel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHDistributionFirModel.h"
#import "DHRuntimeTools.h"
#import "DHFirDistributer.h"

@implementation DHDistributionFirModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _identity = @((NSInteger)[[NSDate date] timeIntervalSince1970]).stringValue;
        _distributer  = [[DHFirDistributer alloc] init];
    }
    return self;
}

- (DHDistributionPlatform)platformType {
    return kDHDistributionPlatformFir;
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
    [result appendString:@"-------fir.im--------\n"];
    [result appendFormat:@"identity: %@\n", self.identity];
    [result appendFormat:@"platform: %@\n", self.platformType];
    [result appendFormat:@"nickname: %@\n", self.nickname];
    [result appendFormat:@"API_KEY: %@\n", self.platformApiKey];
    [result appendFormat:@"installPassword: %@\n", self.installPassword];
    [result appendFormat:@"appDisplayName: %@\n", self.appDisplayName];
    [result appendFormat:@"appBundleId: %@\n", self.appBundleId];
    [result appendFormat:@"appVersion: %@\n", self.appVersion];
    [result appendFormat:@"appBuildVersion: %@\n", self.appBuildVersion];
    [result appendFormat:@"changeLog: %@\n", self.changeLog];
    
    return [result copy];
}

@end
