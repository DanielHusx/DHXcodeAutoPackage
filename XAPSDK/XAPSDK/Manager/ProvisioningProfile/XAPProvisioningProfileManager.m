//
//  XAPProvisioningProfileManager.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/2.
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
/// 系统钥匙串的证书集合
@property (nonatomic, strong) NSMutableArray *systemCertificates;
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
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 解析系统缓存的描述文件到内存
        [weakself fetchProvisioningProfilesForSystemStoragePath];
        // 解析系统配置的证书到内存
        [weakself fetchKeychainCertificatesInfoForSystemConfigurated];
    });
}

#pragma mark - public method
/// 筛选
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

/// 获取系统缓存的证书信息
- (NSArray <XAPProvisioningProfileModel *> *)fetchSystemConfiguratedCertificatesInfo {
    NSArray *certsInfo = [self fetchKeychainCertificatesInfoForSystemConfigurated];
    
    return certsInfo;
}

#pragma mark - filter method
- (BOOL)checkEqualableWithModel:(XAPProvisioningProfileModel *)model
                  byFilterModel:(XAPProvisioningProfileModel *)filterModel {
    if (!filterModel) { return YES; }
    if (filterModel.teamIdentifier) {
        if (![filterModel.teamIdentifier isEqualToString:model.teamIdentifier]) {
            return NO;
        }
    }
    if (filterModel.bundleIdentifier) {
        NSString *reg = [model.bundleIdentifier stringByReplacingOccurrencesOfString:@"." withString:@"\\."];
        reg = [reg stringByReplacingOccurrencesOfString:@"*" withString:@".*"];
        if (![XAPTools validateWithRegExp:reg text:filterModel.bundleIdentifier]) {
            return NO;
        }
    }
    if (filterModel.teamName) {
        if (![filterModel.teamName isEqualToString:model.teamName]) {
            return NO;
        }
    }
    if (filterModel.channel) {
        if (![filterModel.channel isEqualToString:model.channel]) {
            return NO;
        }
    }
    if (filterModel.uuid) {
        if (![filterModel.uuid isEqualToString:model.uuid]) {
            return NO;
        }
    }
    return YES;
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

/// 解析路径集合为描述文件模型集合
- (NSArray <XAPProvisioningProfileModel *> *)fetchProvisioningProfilesWithPaths:(NSArray *)paths {
    __block NSMutableArray *result = [NSMutableArray array];
    __block NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    __weak typeof(self) weakself = self;
    
    [paths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([XAPTools isProvisioningProfile:obj]) {
            @autoreleasepool {
                NSError *error;
                XAPProvisioningProfileModel *model = [weakself parseProvisioningProfileWithPath:obj error:&error];
                if (!error && model) {
                    [result addObject:model];
                    NSString *fileName = [weakself fileNameWithPath:obj];
                    [resultDict setObject:model forKey:fileName];
                }
                error = nil;
            }
        }
    }];
    
    [self.provisioningProfiles addEntriesFromDictionary:resultDict];
    return result;
}

/// 系统钥匙串配置的有效证书信息
- (NSArray <XAPProvisioningProfileModel *> *)fetchKeychainCertificatesInfoForSystemConfigurated {
    // 生命周期下只解析一次
    if (_systemCertificates) { return _systemCertificates; }
    
    NSArray *result = [self parseKeychainCertificatesInfo];
    _systemCertificates = [NSMutableArray arrayWithArray:result];
    
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
                                                            error:(NSError * _Nonnull *)error {
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
    NSLog(@"%@", [model description]);
    return model;
}

/// 解析钥匙串支持的证书信息
- (NSArray <XAPProvisioningProfileModel *> *)parseKeychainCertificatesInfo {
    NSError *error;
    NSArray *teamNames;
    NSArray *uuids;
    NSArray *teamIdentifiers;
    [[XAPScriptor sharedInstance] fetchKeychainCertificatesOfTeamNames:&teamNames
                                                                 uuids:&uuids
                                                       teamIdentifiers:&teamIdentifiers
                                                                 error:&error];
    
    if (error) { return nil; }
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:teamNames.count];
    for (NSInteger i = 0; i < teamNames.count; i++) {
        XAPProvisioningProfileModel *model = [[XAPProvisioningProfileModel alloc] init];
        model.teamName = teamNames[i];
        model.uuid = uuids[i];
        model.teamIdentifier = teamIdentifiers[i];
        [result addObject:model];
    }
    return result;
}


#pragma mark - getter
- (NSMutableDictionary *)provisioningProfiles {
    if (!_provisioningProfiles) {
        _provisioningProfiles = [NSMutableDictionary dictionary];
    }
    return _provisioningProfiles;
}

@end
