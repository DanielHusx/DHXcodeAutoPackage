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
// TODO: 遍历缓存解析到沙盒，hash比对

#pragma mark - parse
/// 解析描述文件
- (XAPProvisioningProfileModel *)parseProvisioningProfileWithPath:(NSString *)path
                                                            error:(NSError * __autoreleasing _Nonnull *)error {
    if (![XAPTools isProvisioningProfile:path]) {
        return nil;
    }
    XAPProvisioningProfileModel *model = [[XAPProvisioningProfileModel alloc] init];
    model.profilePath = path;
    
    NSString *output = nil;
    // 获取名称
    output = [[XAPScriptor sharedInstance] fetchProfileNameWithProfile:path
                                                                 error:error];
    if (error) { return nil; }
    model.name = output;
    
    
    // 获取bundle id
    output = [[XAPScriptor sharedInstance] fetchProfileBundleIdentifierWithProfile:path
                                                                             error:error];
    if (error) {
        return nil;
    }
    model.bundleIdentifier = output;
    
    // 获取app id
    output = [[XAPScriptor sharedInstance] fetchProfileAppIdentifierWithProfile:path
                                                                          error:error];
    if (error) {
        return nil;
    }
    model.applicationIdentifier = output;
    
    // 获取team id
    output = [[XAPScriptor sharedInstance] fetchProfileTeamIdentifierWithProfile:path
                                                                        error:error];
    if (error) {
        return nil;
    }
    model.teamIdentifier = output;
    
    // 获取team name
    output = [[XAPScriptor sharedInstance] fetchProfileTeamNameWithProfile:path
                                                                     error:error];
    if (error) {
        return nil;
    }
    model.teamName = output;
    
    // 获取uuid
    output = [[XAPScriptor sharedInstance] fetchProfileUUIDWithProfile:path
                                                                 error:error];
    if (error) {
        return nil;
    }
    model.uuid = output;
    
    // 获取createTimestamp
    output = [[XAPScriptor sharedInstance] fetchProfileCreateTimestampWithProfile:path
                                                                            error:error];
    if (error) {
        return nil;
    }
    model.createTimestamp = output;
    
    // 获取ExpireTimestamp
    output = [[XAPScriptor sharedInstance] fetchProfileExpireTimestampWithProfile:path
                                                                            error:error];
    if (error) {
        return nil;
    }
    model.expireTimestamp = output;
    
    // 渠道类型
    output = [[XAPScriptor sharedInstance] fetchProfileChannelWithProfile:path
                                                                    error:error];
    if (error) {
        return nil;
    }
    model.channel = output;
    
    return model;
}

@end
