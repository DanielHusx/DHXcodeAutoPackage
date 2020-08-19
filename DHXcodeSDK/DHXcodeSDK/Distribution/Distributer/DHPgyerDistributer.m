//
//  DHPgyerDistributer.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHPgyerDistributer.h"
#import "DHDistributionPgyerModel.h"
#import "DHDistributeManager.h"

@interface DHPgyerDistributer ()

@end

@implementation DHPgyerDistributer
- (NSString *)formatInstallDate:(NSDate *)date {
    static NSDateFormatter *format;
    format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:date];
}

/// 校验蒲公英必要参数是否正确
- (BOOL)checkPgyerRequiredParametersWithPlatform:(DHDistributionPgyerModel *)platform {
    if (![DHObjectTools isValidString:platform.platformApiKey]) { return NO; }
    return YES;
}

- (void)distributeIPAFile:(NSString *)ipaFile
               toPlatform:(DHDistributionPgyerModel *)pgyerPlatform
    uploadProgressHandler:(void (^)(NSProgress * _Nonnull))uploadProgressHandler
        completionHandler:(void (^)(BOOL, NSError * _Nullable))completionHandler {
    // 校验参数
    if (![DHPathUtils isIPAFile:ipaFile]) {
        completionHandler(NO, DH_ERROR_MAKER(DHERROR_DISTRIBUTE_IPA_FILE_INVALID, @"IPA路径不存在"));
        return ;
    }
    if (![self checkPgyerRequiredParametersWithPlatform:pgyerPlatform]) {
        completionHandler(NO, DH_ERROR_MAKER(DHERROR_DISTRIBUTE_MISSING_REQUIRED_PARAMETERS, @"蒲公英缺少必要参数"));
        return ;
    }
    [self distributeByPgyerWithFile:ipaFile
                             apiKey:pgyerPlatform.platformApiKey
                        installType:pgyerPlatform.installType
                    installPassword:pgyerPlatform.installPassword
                          changeLog:pgyerPlatform.changeLog
                    applicationName:pgyerPlatform.appDisplayName
               installDateLimitType:pgyerPlatform.installDateLimitType
                   installStartDate:pgyerPlatform.installStartDate
                     installEndDate:pgyerPlatform.installEndDate
              uploadProgressHandler:uploadProgressHandler
                  completionHandler:completionHandler];
}

- (void)distributeByPgyerWithFile:(NSString *)file
                           apiKey:(NSString *)apiKey
                      installType:(nullable NSNumber *)installType
                  installPassword:(nullable NSString *)installPassword
                        changeLog:(nullable NSString *)changeLog
                  applicationName:(nullable NSString *)applicationName
             installDateLimitType:(nullable NSNumber *)installDateLimitType
                 installStartDate:(nullable NSDate *)installStartDate
                   installEndDate:(nullable NSDate *)installEndDate
            uploadProgressHandler:(nullable void (^)(NSProgress *uploadProgress))uploadProgressHandler
                completionHandler:(nullable void (^) (BOOL succeed, NSError *_Nullable error))completionHandler {
    /**
     参考： https://www.pgyer.com/doc/view/api#uploadApp
     参数    类型    说明
     _api_key    String    (必填) API Key 点击获取_api_key
     file    File    (必填) 需要上传的ipa或者apk文件
     buildInstallType    Integer    (必填)应用安装方式，值为(2,3)。2：密码安装，3：邀请安装
     buildPassword    String    (必填) 设置App安装密码
     buildUpdateDescription    String    (选填) 版本更新描述，请传空字符串，或不传。
     buildName    String    (选填) 应用名称
     buildInstallDate    Interger    (选填)是否设置安装有效期，值为：1 设置有效时间， 2 长期有效，如果不填写不修改上一次的设置
     buildInstallStartDate    String    (选填)安装有效期开始时间，字符串型，如：2018-01-01
     buildInstallEndDate    String    (选填)安装有效期结束时间，字符串型，如：2018-12-31
     buildChannelShortcut    String    (选填)所需更新的指定渠道的下载短链接，只可指定一个渠道，字符串型，如：abcd
     
     */
    NSURL *fileUrl = [NSURL fileURLWithPath:file];
    NSString *url = @"https://www.pgyer.com/apiv2/app/upload";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 必要参数
    [params setValue:apiKey?:@"" forKey:@"_api_key"];
    [params setValue:installType?:@(2) forKey:@"buildInstallType"];
    [params setValue:installPassword?:@"" forKey:@"buildPassword"];
    // 选填参数
    if ([DHObjectTools isValidString:changeLog]) {
        [params setValue:changeLog forKey:@"buildUpdateDescription"];
    }
    if ([DHObjectTools isValidString:applicationName]) {
        [params setValue:applicationName forKey:@"buildName"];
    }
    if ([installDateLimitType isKindOfClass:[NSNumber class]]) {
        [params setValue:installDateLimitType forKey:@"buildInstallDate"];
    }
    if (installStartDate) {
        [params setValue:[self formatInstallDate:installStartDate] forKey:@"buildInstallStartDate"];
    }
    if (installEndDate) {
        [params setValue:[self formatInstallDate:installEndDate] forKey:@"buildInstallEndDate"];
    }
    
    [[DHDistributeManager manager] POST:url parameters:params fileURL:fileUrl fileName:@"file" progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgressHandler) { uploadProgressHandler(uploadProgress); }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completionHandler) { completionHandler(YES, nil); }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completionHandler) { completionHandler(NO, error); }
    }];
}

+ (void)interrupt {
    DHXcodeLog(@"Interrupt upload ipa file to pgyer.com.");
    [super interrupt];
}


@end
