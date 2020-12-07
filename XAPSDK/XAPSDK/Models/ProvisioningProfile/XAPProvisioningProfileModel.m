//
//  XAPProvisioningProfileModel.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/3.
//

#import "XAPProvisioningProfileModel.h"

@implementation XAPProvisioningProfileModel

- (NSString *)description {
    static NSDateFormatter *formater;
    if (!formater) {
        formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    }
    
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-------profile-----------\n"];
    [result appendFormat:@"path: %@\n", self.profilePath];
    [result appendFormat:@"channel: %@\n", self.channel];
    [result appendFormat:@"name: %@\n", self.name];
    [result appendFormat:@"appid: %@\n", self.applicationIdentifier];
    [result appendFormat:@"teamid: %@\n", self.teamIdentifier];
    [result appendFormat:@"teamName: %@\n", self.teamName];
    [result appendFormat:@"%@ - %@\n", [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.createTimestamp.doubleValue]], [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.expireTimestamp.doubleValue]]];
    [result appendFormat:@"uuid: %@\n", self.uuid];
    return [result copy];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[XAPProvisioningProfileModel class]]) {
        return NO;
    }
    
    XAPProvisioningProfileModel *model = object;
    if (![model.uuid isKindOfClass:[NSString class]]) {
        return NO;
    }
    if (![model.uuid isEqualToString:self.uuid]) {
        return NO;
    }
    
    return YES;
}

@end
