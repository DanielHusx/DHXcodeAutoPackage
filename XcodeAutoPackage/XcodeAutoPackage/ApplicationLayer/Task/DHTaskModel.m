//
//  DHTaskModel.m
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHTaskModel.h"
#import "DHGlobalConfigration.h"
#import <DHXcodeSDK/DHXcodeSDK.h>
#import "DHTaskUtils.h"
#import "NSDate+DHDateFormat.h"

@interface DHTaskModel ()

#pragma mark - *** 任务解析信息 ***
/// 工作空间信息
@property (nonatomic, strong, nullable) DHWorkspaceModel *workspace;
/// 项目信息（单工程）
@property (nonatomic, strong, nullable) DHProjectModel *project;


/// 工作空间信息
@property (nonatomic, strong, nullable) NSArray <DHWorkspaceModel *> *workspaces;
/// 项目信息（单工程）
@property (nonatomic, strong, nullable) NSArray <DHProjectModel *> *projects;
/// Pod信息
@property (nonatomic, strong, nullable) DHPodModel *pod;
/// Git信息
@property (nonatomic, strong, nullable) DHGitModel *git;
/// 归档
@property (nonatomic, strong, nullable) DHArchiveModel *archive;
/// ipa
@property (nonatomic, strong, nullable) DHIPAModel *ipa;
/// 匹配的profile
@property (nonatomic, strong, nullable) NSArray<DHProfileModel *> *profiles;

/// 当前分发平台信息
@property (nonatomic, strong) id<DHDistributionProtocol> distributionPlatform;

@end
@implementation DHTaskModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _taskName = @"Task";
        self.identity = @((NSInteger)[[NSDate date] timeIntervalSince1970]).stringValue;
        [self setupInitial];
        [self setupWithGroup:[DHGlobalConfigration configuration]];
    }
    return self;
}

- (void)setupWithGroup:(DHGlobalConfigration *)config {
    _keepXcarchive = config.keepXcarchive;
    _needGitPull = config.isNeedGitPull;
    _needPodInstall = config.isNeedPodInstall;
    
    _channel = config.channel;
    _exportIPADirectory = config.exportIPADirectory;
    _configurationName = config.configurationName;
    _exportArchiveDirectory = config.exportArchiveDirectory;
    _profilesDirectory = config.profilesDirectory;
//    _currentDistributionPlatformType = kDHDistributionPlatformNone;
}

- (void)setupInitial {
    _forceGitSwitch = NO;
    _forceSetVersion = NO;
    _forceSetBuildVersion = NO;
    _forceSetBundleId = YES;
    _forceSetTeamId = YES;
    _forceSetDisplayName = NO;
    _forceSetProductName = NO;
    _forceSetEnableBitcode = NO;
}

// MARK: - getters & setters
- (NSString *)currentProfileExpireDays {
    if (![DHCommonTools isValidString:self.currentProfileExpireTimestamp]) { return nil; }
    NSInteger time = self.currentProfileExpireTimestamp.integerValue;
    if (time <= 0) { return nil; }
    // 距离当前时间间隔秒
    return @([[NSDate dateWithTimeIntervalSince1970:time] dayIntervalSinceNow]).stringValue;
}

- (NSString *)currentProfileCreatToExpireTime {
    if (![DHCommonTools isValidString:self.currentProfileExpireTimestamp]) { return nil; }
    if (![DHCommonTools isValidString:self.currentProfileCreateTimestamp]) { return nil; }
    NSInteger createTimestamp = self.currentProfileCreateTimestamp.integerValue;
    NSInteger expireTimestamp = self.currentProfileExpireTimestamp.integerValue;
    if (createTimestamp <= 0 || expireTimestamp <= 0) { return nil; }
    
    NSString *create = [[NSDate dateWithTimeIntervalSince1970:self.currentProfileCreateTimestamp.integerValue] stringFormatMiddleLine];
    NSString *expire = [[NSDate dateWithTimeIntervalSince1970:self.currentProfileExpireTimestamp.integerValue] stringFormatMiddleLine];
    return [NSString stringWithFormat:@"%@ - %@", create, expire];
}

- (NSString *)exportCommonName {
    return self.currentTargetName?:self.currentProductName?:@"Unknow";
}

- (NSString *)exportArchiveFile {
    NSString *filename = [NSString stringWithFormat:@"%@_%@.xcarchive", [self exportCommonName], [[NSDate date] stringFormatBottomLine]];
    NSString *file = [[self exportArchiveDirectory] stringByAppendingPathComponent:filename];
    return file;
}

- (NSString *)exportIPAFile {
    if (self.archive || self.project || self.workspace) {
        NSString *filename = [NSString stringWithFormat:@"%@.ipa", [self exportCommonName]];
        NSString *file = [[self exportIPADirectory] stringByAppendingPathComponent:filename];
        return file;
    }
    // 对于IPA是赋值的
    return _exportIPAFile;
}

- (NSString *)currentDistributionPlatformType {
    if (!_currentDistributionPlatformType) {
        _currentDistributionPlatformType = kDHDistributionPlatformNone;
    }
    return _currentDistributionPlatformType;
}

- (NSArray *)distributionNicknameOptions {
//    NSMutableArray *availablePlatforms = [NSMutableArray arrayWithArray:[DHGlobalConfigration configuration].distributionPlatforms];
//    if ([availablePlatforms count] == 0) return @[];
//    for (id<DHDistributionProtocol> platform in [DHGlobalConfigration configuration].distributionPlatforms) {
//        if ([platform.platformType isEqualToString:self.currentDistributionPlatformType]) { continue; }
//        [availablePlatforms removeObject:platform];
//    }
//    return [availablePlatforms mutableArrayValueForKey:@"nickname"];
    return [[DHGlobalConfigration configuration].distributionPlatforms mutableArrayValueForKey:@"nickname"];
}

- (DHTaskType)taskType {
    DHTaskType type = DHTaskTypeUnknown;
    if (_workspace ) {
        type = DHTaskTypeXcworkspace;
    } else if (_project) {
        type = DHTaskTypeXcodeproj;
    } else if (_archive) {
        type = DHTaskTypeXcarchive;
    } else if (_ipa) {
        type = DHTaskTypeIPA;
    }
    
    if ([DHDataTools validateDistributionPlatform:_currentDistributionPlatformType]) {
        type |= DHTaskTypeDistribute;
    }
    if (_git) {
        type |= DHTaskTypeGit;
    }
    if (_pod) {
        type |= DHTaskTypePod;
    }
    return type;
}

- (DHTaskTypeName)taskTypeName {
    DHTaskType type = [self taskType];
    NSMutableArray *names = [NSMutableArray arrayWithCapacity:3];
    if (type & DHTaskTypeXcworkspace || type & DHTaskTypeXcodeproj) {
        [names addObject:kDHTaskTypeNameArchive];
    }
    if (type & DHTaskTypeXcworkspace || type & DHTaskTypeXcodeproj || type & DHTaskTypeXcarchive) {
        [names addObject:kDHTaskTypeNameExport];
    }
    if (type & DHTaskTypeDistribute) {
        [names addObject:kDHTaskTypeNameDistribute];
    }
    
    NSString *result = [names componentsJoinedByString:@" | "];
    
    return result;
}

- (NSArray *)profileNameOptions {
    return [self.profiles mutableArrayValueForKey:@"name"];
}

- (NSString *)currentTeamName {
    return [DHTaskUtils fetchTeamNameWithProfilesDirectory:self.profilesDirectory
                                            teamIdentifier:self.currentTeamId];
}

- (NSArray *)teamNameOptions {
    return [DHTaskUtils teamNameOptionsWithProfilesDirectory:self.profilesDirectory];
}

- (NSArray *)teamIdOptions {
    return [DHTaskUtils teamIdentifierOptionsWithProfilesDirectory:self.profilesDirectory];
}

- (void)setDistributionPlatforms:(NSMutableArray<id<DHDistributionProtocol>> *)distributionPlatforms {
    // 屏蔽外部设置
}

- (void)setTaskName:(NSString *)taskName {
    if (![DHCommonTools isValidString:taskName]) { return ; }
    
    _taskName = taskName;
}

#pragma mark - NSCoding
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


// MARK: - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    id copyObj = [[[self class] allocWithZone:zone] init];
    if (copyObj) {
        [DHRuntimeTools copyObject:copyObj fromObject:self];
    }
    return copyObj;
}


// MARK: - equal
- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[DHTaskModel class]]) { return NO; }
    DHTaskModel *task = object;
    if (![task.identity isEqualToString:self.identity]) { return NO; }
    return YES;
}

@end
