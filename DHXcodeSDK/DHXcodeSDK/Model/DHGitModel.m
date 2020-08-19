//
//  DHGitModel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/14.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHGitModel.h"
#import "DHRuntimeTools.h"


@implementation DHGitModel

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

- (NSArray *)branchNameOptions {
    NSMutableArray *branchs = [NSMutableArray  array];
    [branchs addObjectsFromArray:self.branchs];
    [branchs addObjectsFromArray:self.tags];
    return branchs;
}

@end
