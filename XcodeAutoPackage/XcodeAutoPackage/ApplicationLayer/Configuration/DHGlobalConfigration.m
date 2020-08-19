//
//  DHGlobalConfigration.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/14.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHGlobalConfigration.h"
//#import "DHDistributionModel.h"
//#import "DHDBRuntime.h"
//#import "DHDBFactory.h"

#import <DHXcodeSDK/DHXcodeSDK.h>
#import "DHGlobalArchiver.h"

@implementation DHGlobalConfigration

+ (instancetype)configuration {
    static DHGlobalConfigration *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DHGlobalConfigration alloc] init];
        // 初始化默认配置
        [_instance setupInitialConfiguration];
    });
    return _instance;
}

- (void)setupInitialConfiguration {
    _configurationName = kDHConfigurationNameRelease;
    _channel = kDHChannelAdHoc;
   
    
    _exportArchiveDirectory = [[DHCommonTools systemUserDocumentsDirectory] stringByAppendingPathComponent:@"iDHIPAs"];
    _exportIPADirectory = [[DHCommonTools systemUserDocumentsDirectory] stringByAppendingPathComponent:@"iDHIPAs"];
    _profilesDirectory = [[DHCommonTools systemUserDirectory] stringByAppendingPathComponent:@"Library/MobileDevice/Provisioning Profiles"];
    
    _keepXcarchive = YES;
    _needPodInstall = YES;
    _needGitPull = NO;
}

- (NSMutableArray<id<DHDistributionProtocol>> *)distributionPlatforms {
    if (!_distributionPlatforms) {
        _distributionPlatforms = [NSMutableArray array];
    }
    return _distributionPlatforms;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [DHRuntimeTools encodeObject:self coder:coder];
}


- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [DHGlobalConfigration configuration];
    [DHRuntimeTools decodeObject:self coder:coder];
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    id copyObj = [[[self class] allocWithZone:zone] init];
    if (copyObj) {
        [DHRuntimeTools copyObject:copyObj fromObject:self];
    }
    return copyObj;
}

- (void)updateWithConfiguration:(DHGlobalConfigration *)configuration {
    if (![configuration isKindOfClass:[DHGlobalConfigration class]]) { return ; }
    [DHRuntimeTools copyObject:self fromObject:configuration];
}

@end
