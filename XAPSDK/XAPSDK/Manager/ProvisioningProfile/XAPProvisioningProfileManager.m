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

#pragma mark - parse
/// 组装描述文件信息
+ (DHProfileModel *)fetchProfileWithProfile:(NSString *)profile
                                    error:(NSError **)error {
    if (![DHPathUtils isProfile:profile]) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_MOBILEPROVISION_INVALID, @".mobileprovision路径异常");
        return nil;
    }
    DHProfileModel *model = [[DHProfileModel alloc] init];
    model.profilePath = profile;
    
    
    BOOL ret = NO;
    NSString *output = nil;
    NSError *err;
    // 获取名称
    ret = [DHScriptCommand fetchProfileNameWithProfile:profile
                                                output:&output
                                                 error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_NAME_FAILED, err);
        return model;
    }
    model.name = output;
    
    // 获取Bundle id
    ret = [DHScriptCommand fetchProfileBundleIdentifierWithProfile:profile
                                                            output:&output
                                                             error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_BUNDLEID_FAILED, err);
        return model;
    }
    model.bundleId = output;
    
    // 获取app id
    ret = [DHScriptCommand fetchProfileAppIdentifierWithProfile:profile
                                                         output:&output
                                                          error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_APPID_FAILED, err);
        return model;
    }
    model.appId = output;
    
    // 获取team id
    ret = [DHScriptCommand fetchProfileTeamIdentifierWithProfile:profile
                                                          output:&output
                                                           error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_TEAMID_FAILED, err);
        return model;
    }
    model.teamId = output;
    
    // 获取team name
    ret = [DHScriptCommand fetchProfileTeamNameWithProfile:profile
                                                  output:&output
                                                   error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_TEAMNAME_FAILED, err);
        return model;
    }
    model.teamName = output;
    
    // 获取uuid
    ret = [DHScriptCommand fetchProfileUUIDWithProfile:profile
                                              output:&output
                                               error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_UUID_FAILED, err);
        return model;
    }
    model.uuid = output;
    
    // 获取createTimestamp
    ret = [DHScriptCommand fetchProfileCreateTimestampWithProfile:profile
                                                         output:&output
                                                          error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_CREATED_TIMESTAMP_FAILED, err);
        return model;
    }
    model.createTimestamp = output;
    
    // 获取ExpireTimestamp
    ret = [DHScriptCommand fetchProfileExpireTimestampWithProfile:profile
                                                         output:&output
                                                          error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_EXPIRE_TIMESTAMP_FAILED, err);
        return model;
    }
    model.expireTimestamp = output;
    
    // 渠道类型
    DHChannel outputChannel;
    ret = [DHScriptCommand fetchProfileChannelWithProfile:profile
                                                 output:&outputChannel
                                                  error:&err];
    if (!ret) {
        DH_ERROR_MAKER_CONVINENT(DHERROR_PARSER_PROFILE_PARSE_CHANNEL_FAILED, err);
        return model;
    }
    model.channel = outputChannel;
    
    return model;
}

@end
