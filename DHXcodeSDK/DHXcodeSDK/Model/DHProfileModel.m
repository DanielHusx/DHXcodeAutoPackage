//
//  DHProfileModel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHProfileModel.h"
#import "DHRuntimeTools.h"

@implementation DHProfileModel

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
    if (![object isKindOfClass:[self class]]) { return NO; }
    DHProfileModel *profile = object;
    
    if (![profile.profilePath isEqualToString:self.profilePath]) { return NO; }
    return YES;
}

- (NSString *)description {
    static NSDateFormatter *formater;
    if (!formater) {
        formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy/MM/dd"];
    }
    
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-------profile-----------\n"];
    [result appendFormat:@"path: %@\n", self.profilePath];
    [result appendFormat:@"channel: %@\n", self.channel];
    [result appendFormat:@"name: %@\n", self.name];
    [result appendFormat:@"appid: %@\n", self.appId];
    [result appendFormat:@"teamid: %@\n", self.teamId];
    [result appendFormat:@"teamName: %@\n", self.teamName];
    [result appendFormat:@"%@ - %@\n", [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.createTimestamp.doubleValue]], [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.expireTimestamp.doubleValue]]];
    [result appendFormat:@"uuid: %@\n", self.uuid];
    return [result copy];
}

@end
