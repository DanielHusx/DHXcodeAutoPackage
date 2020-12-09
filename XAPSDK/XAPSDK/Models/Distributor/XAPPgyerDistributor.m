//
//  XAPPgyerDistributor.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import "XAPPgyerDistributor.h"
#import "XAPDistributionManager.h"

@implementation XAPPgyerDistributor

#pragma mark - public method
- (void)distributeIPAFile:(NSString *)ipaFile
    uploadProgressHandler:(void (^)(NSProgress * _Nonnull))uploadProgressHandler
        completionHandler:(void (^)(BOOL, NSError * _Nullable))completionHandler {
    // 校验参数
    if (![XAPTools isIPAFile:ipaFile]) {
        completionHandler(NO, nil);//DH_ERROR_MAKER(DHERROR_DISTRIBUTE_IPA_FILE_INVALID, @"IPA路径不存在"));
        return ;
    }
    if (![self checkPgyerRequiredParametersWithPlatform:self]) {
        completionHandler(NO, nil);//DH_ERROR_MAKER(DHERROR_DISTRIBUTE_MISSING_REQUIRED_PARAMETERS, @"蒲公英缺少必要参数"));
        return ;
    }
    [self distributeByPgyerWithFile:ipaFile
                             apiKey:self.apiKey
                        installType:self.installType
                    installPassword:self.installPassword
                          changeLog:self.changeLog
                    applicationName:self.applicationDisplayName
               installDateLimitType:self.installDateLimitType
                   installStartDate:self.installStartDate
                     installEndDate:self.installEndDate
              uploadProgressHandler:uploadProgressHandler
                  completionHandler:completionHandler];
}

- (void)interruptDistribution {
    [[XAPDistributionManager manager] interrupt];
}


#pragma mark - private method
- (NSString *)formatInstallDate:(NSDate *)date {
    static NSDateFormatter *format;
    format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:date];
}

/// 校验蒲公英必要参数是否正确
- (BOOL)checkPgyerRequiredParametersWithPlatform:(XAPPgyerDistributor *)platform {
    if (![XAPTools isValidString:platform.apiKey]) { return NO; }
    return YES;
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
    if ([XAPTools isValidString:changeLog]) {
        [params setValue:changeLog forKey:@"buildUpdateDescription"];
    }
    if ([XAPTools isValidString:applicationName]) {
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
    
    [[XAPDistributionManager manager] POST:url parameters:params fileURL:fileUrl fileName:@"file" progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgressHandler) { uploadProgressHandler(uploadProgress); }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completionHandler) { completionHandler(YES, nil); }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completionHandler) { completionHandler(NO, error); }
    }];
}


#pragma mark - getter
- (NSNumber *)installType {
    return @(DHDistributionPgyerInstallTypePassword);
}

- (NSNumber *)installDateLimitType {
    return nil;
}

- (NSDate *)installStartDate {
    return nil;
}

- (NSDate *)installEndDate {
    return nil;
}

@end
