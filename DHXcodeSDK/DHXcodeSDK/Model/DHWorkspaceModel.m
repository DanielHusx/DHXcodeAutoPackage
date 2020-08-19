//
//  DHWorkspaceModel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHWorkspaceModel.h"
#import "DHRuntimeTools.h"

@implementation DHWorkspaceModel

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

@end
