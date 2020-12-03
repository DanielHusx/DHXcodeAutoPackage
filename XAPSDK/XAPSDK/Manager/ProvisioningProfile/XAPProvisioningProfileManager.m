//
//  XAPProvisioningProfileManager.m
//  XAPSDK
//
//  Created by 菲凡数据 on 2020/12/2.
//

#import "XAPProvisioningProfileManager.h"
#import "XAPScriptor.h"
#import "XAPScriptModel.h"
#import "XAPTools.h"
#import "XAPProvisioningProfileModel.h"

@interface XAPProvisioningProfileManager ()

/// 解析的描述文件
@property (nonatomic, strong) NSMutableDictionary *provisioningProfiles;

/// 系统路径下描述文件的路径集合
@property (nonatomic, strong) NSMutableArray *systemStorageProfileSubpaths;
/// 系统路径下描述文件的解析结果集合
@property (nonatomic, strong) NSMutableArray *systemStorageProfiles;

@end

@implementation XAPProvisioningProfileManager

#pragma mark - initialization
+ (instancetype)manager {
    static XAPProvisioningProfileManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XAPProvisioningProfileManager alloc] init];
    });
    return _instance;
}

- (void)prepareConfig {
    // 解析系统缓存的描述文件到内存
    [self fetchProvisioningProfilesForSystemStoragePath];
}


- (NSArray <XAPProvisioningProfileModel *> *)filterProvisioningProfileByFilterModel:(XAPProvisioningProfileModel *)filterModel {
    NSArray *profiles = self.provisioningProfiles.allValues;
    if (!filterModel) { return profiles; }
    
    __weak typeof(self) weakself = self;
    __block NSMutableSet *result = [NSMutableSet set];
    [profiles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL equal = [weakself checkEqualableWithModel:obj
                                         byFilterModel:filterModel];
        if (equal) {
            [result addObject:obj];
        }
    }];
    return [result allObjects];
}

/// 解析描述文件
- (XAPProvisioningProfileModel *)fetchProvisioningProfilesWithPath:(NSString *)path {
    if (![XAPTools isProvisioningProfile:path]) { return nil; }
    // 先读取缓存的
    NSString *fileName = [self fileNameWithPath:path];
    XAPProvisioningProfileModel *model = [self.provisioningProfiles objectForKey:fileName];
    if (model) { return model; }
    
    NSError *error;
    model = [self parseProvisioningProfileWithPath:path error:&error];
    if (!model || error) {
        return nil;
    }
    // 解析成功缓存
    [self.provisioningProfiles setObject:model forKey:fileName];
    
    return model;
}

/// 解析路径下所有描述文件
- (NSArray <XAPProvisioningProfileModel *> *)fetchProvisioningProfilesWithDirectory:(NSString *)directory {
    NSArray *subpaths = [XAPTools absoluteSubpathsOfDirectory:directory];
    NSArray *result = [self fetchProvisioningProfilesWithPaths:subpaths];
    
    return result;
}

#pragma mark - filter method
- (BOOL)checkEqualableWithModel:(XAPProvisioningProfileModel *)model
                  byFilterModel:(XAPProvisioningProfileModel *)filterModel {
    if (!filterModel) { return YES; }
    
    return NO;;
}


#pragma mark - private method
/// 遍历系统缓存解析描述文件到内存
- (NSArray <XAPProvisioningProfileModel *> *)fetchProvisioningProfilesForSystemStoragePath {
    // ~/Library/MobileDevice/Provisioning Profiles
    NSString *systemStoragePath = [XAPTools systemProvisioningProfilesDirectory];
    NSArray *subpaths = [XAPTools absoluteSubpathsOfDirectory:systemStoragePath];
    // 路径异常
    if (!subpaths) { return nil; }
    // 是否已经解析过
    if ([subpaths isEqualToArray:_systemStorageProfileSubpaths]) {
        if (_systemStorageProfiles) { return _systemStorageProfiles; }
    }
    _systemStorageProfileSubpaths = [NSMutableArray arrayWithArray:subpaths];
    
    NSArray *result = [self fetchProvisioningProfilesWithPaths:subpaths];
    // 缓存记录
    _systemStorageProfiles = [NSMutableArray arrayWithArray:result];
    
    return result;
}

- (NSArray <XAPProvisioningProfileModel *> *)fetchProvisioningProfilesWithPaths:(NSArray *)paths {
    __block NSMutableArray *result = [NSMutableArray array];
    __block NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    __weak typeof(self) weakself = self;
    [paths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([XAPTools isProvisioningProfile:obj]) {
            @autoreleasepool {
                XAPProvisioningProfileModel *model = [weakself parseProvisioningProfileWithPath:obj error:nil];
                if (model) {
                    [result addObject:model];
                    NSString *fileName = [weakself fileNameWithPath:obj];
                    [resultDict setObject:model forKey:fileName];
                }
            }
        }
    }];
    
    [self.provisioningProfiles addEntriesFromDictionary:resultDict];
    return result;
}

- (NSString *)fileNameWithPath:(NSString *)path {
    if (![XAPTools isValidString:path]) { return nil; }
    NSString *file = [path lastPathComponent];
    NSString *fileName = [file stringByDeletingPathExtension];
    return fileName;
}


#pragma mark - parse
/// 解析描述文件
- (XAPProvisioningProfileModel *)parseProvisioningProfileWithPath:(NSString *)path
                                                            error:(NSError * __autoreleasing _Nonnull *)error {
    if (![XAPTools isProvisioningProfile:path]) {
        return nil;
    }
    
    XAPProvisioningProfileModel *model = [[XAPProvisioningProfileModel alloc] init];
    model.profilePath = path;
    NSString *profileName;
    NSString *bundleId;
    NSString *appId;
    NSString *teamId;
    NSString *channel;
    NSString *createTimestamp;
    NSString *expireTimestamp;
    NSString *uuid;
    NSString *teamName;
//    NSDictionary *entitlements;
    
    NSDictionary *info = [[XAPScriptor sharedInstance] fetchProfileInfoWithProfile:path
                                                                       profileName:&profileName
                                                                  bundleIdentifier:&bundleId
                                                                    teamIdentifier:&teamId
                                                             applicationIdentifier:&appId
                                                                              uuid:&uuid
                                                                          teamName:&teamName
                                                                           channel:&channel
                                                                   createTimestamp:&createTimestamp
                                                                   expireTimestamp:&expireTimestamp
                                                                      entitlements:nil
                                                                             error:error];
    if (*error || !info) { return nil; }
    
    model.name = profileName;
    model.bundleIdentifier = bundleId;
    model.applicationIdentifier = appId;
    model.teamIdentifier = teamId;
    model.teamName = teamName;
    model.channel = channel;
    model.createTimestamp = createTimestamp;
    model.expireTimestamp = expireTimestamp;
    model.uuid = uuid;
    
    return model;
}


#pragma mark - getter
- (NSMutableDictionary *)provisioningProfiles {
    if (!_provisioningProfiles) {
        _provisioningProfiles = [NSMutableDictionary dictionary];
    }
    return _provisioningProfiles;
}

@end
