//
//  XAPFirDistributor.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import "XAPFirDistributor.h"
#import "XAPDistributionManager.h"

@implementation XAPFirDistributor

#pragma mark - public method
- (void)distributeIPAFile:(NSString *)ipaFile
    uploadProgressHandler:(void (^)(NSProgress * _Nonnull))uploadProgressHandler
        completionHandler:(void (^)(BOOL, NSError * _Nullable))completionHandler {
    
    // 校验参数
    if (![XAPTools isIPAFile:ipaFile]) {
        completionHandler(NO, nil);//DH_ERROR_MAKER(DHERROR_DISTRIBUTE_IPA_FILE_INVALID, @"IPA路径无法识别"));
        return ;
    }
    if (![self checkFirimRequiredParametersWithPlatform:self]) {
        completionHandler(NO, nil);//DH_ERROR_MAKER(DHERROR_DISTRIBUTE_MISSING_REQUIRED_PARAMETERS, @"Fir.im缺少必要参数"));
        return ;
    }
    [self distributeByFirimWithFile:ipaFile
                             apiKey:self.apiKey
                   bundleIdentifier:self.applicationBundleIdentifier
                          changeLog:self.changeLog
                    applicationName:self.applicationDisplayName
                            version:self.applicationShortVersion
                       buildVersion:self.applicationVersion
              uploadProgressHandler:uploadProgressHandler
                  completionHandler:completionHandler];
}

- (void)interruptDistribution {
    [[XAPDistributionManager manager] interrupt];
}


#pragma mark - private method
/// 校验fir.im必要参数是否正确
- (BOOL)checkFirimRequiredParametersWithPlatform:(XAPFirDistributor *)platform {
    if (![XAPTools isValidString:platform.apiKey]) { return NO; }
    if (![XAPTools isValidString:platform.applicationBundleIdentifier]) { return NO; }
    if (![XAPTools isValidString:platform.applicationDisplayName]) { return NO; }
    if (![XAPTools isValidString:platform.applicationShortVersion]) { return NO; }
    if (![XAPTools isValidString:platform.applicationVersion]) { return NO; }
    return YES;
}

- (void)distributeByFirimWithFile:(NSString *)file
                           apiKey:(NSString *)apiKey
                 bundleIdentifier:(NSString *)bundleIdentifier
                        changeLog:(NSString *)changeLog
                  applicationName:(NSString *)applicationName
                          version:(NSString *)version
                     buildVersion:(NSString *)buildVersion
            uploadProgressHandler:(nullable void (^)(NSProgress *uploadProgress))uploadProgressHandler
                completionHandler:(nullable void (^) (BOOL succeed, NSError *_Nullable error))completionHandler {
    // 1. 先获取上传凭证
    // 2. 分别上传凭证信息与包
    /**
     参考：https://www.betaqr.com/docs/publish
     type    String    是    ios 或者 android（发布新应用时必填）
     bundle_id    String    是    App 的 bundleId（发布新应用时必填）
     api_token    String    是    长度为 32, 用户在 fir 的 api_token
     */
    NSString *url = @"http://api.bq04.com/apps";
    NSURL *fileUrl = [NSURL fileURLWithPath:file];
                    
    XAPDistributionManager *manager = [XAPDistributionManager manager];
    [manager POST:url parameters:@{@"api_token":apiKey?:@"", @"type":@"ios", @"bundle_id":bundleIdentifier?:@""} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        /**
         # status: 201

         {
             "id": "5592ceb6537069f2a8000000",
             "type": "ios",
             "short": "yk37",
             "cert": {
                 "icon": {
                     "key": "xxxxx",
                     "token": "xxxxxx",
                     "upload_url": "http://upload.qiniu.com"
                 },
                 "binary": {
                     "key": "xxxxx",
                     "token": "xxxxxx",
                     "upload_url": "http://upload.qiniu.com"
                 }
             }
         }
         */
        // !!!: 没有任何判错误，其实是很危险的~
        NSString *iconKey = responseObject[@"cert"][@"icon"][@"key"];
        NSString *iconToken = responseObject[@"cert"][@"icon"][@"token"];
        NSString *iconUploadUrl = responseObject[@"cert"][@"icon"][@"upload_url"];
        
        NSString *binaryKey = responseObject[@"cert"][@"binary"][@"key"];
        NSString *binaryToken = responseObject[@"cert"][@"binary"][@"token"];
        NSString *binaryUploadUrl = responseObject[@"cert"][@"binary"][@"upload_url"];
        
        // 上传icon信息
        [manager POST:iconUploadUrl parameters:@{@"key":iconKey?:@"", @"token":iconToken?:@""} progress:nil success:nil failure:nil];
        // 上传包
        /**
            参考文档：https://www.betaqr.com/docs/publish
            key    String    是    七牛上传 key
            token    String    是    七牛上传 token
            file    File    是    安装包文件
            x:name    String    是    应用名称（上传 ICON 时不需要）
            x:version    String    是    版本号（上传 ICON 时不需要）
            x:build    String    是    Build 号（上传 ICON 时不需要）
            x:release_type    String    否    打包类型，只针对 iOS (Adhoc, Inhouse)（上传 ICON 时不需要）
            x:changelog    String    否    更新日志（上传 ICON 时不需要）
         */
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:binaryKey forKey:@"key"];
        [params setValue:binaryToken forKey:@"token"];
        [params setValue:applicationName?:@"" forKey:@"x:name"];
        [params setValue:version?:@"" forKey:@"x:version"];
        [params setValue:buildVersion?:@"" forKey:@"x:build"];
        // 非必要参数
        if ([XAPTools isValidString:changeLog]) {
            [params setValue:changeLog forKey:@"x:changelog"];
        }
        [manager POST:binaryUploadUrl parameters:params fileURL:fileUrl fileName:@"file" progress:^(NSProgress * _Nonnull uploadProgress) {
            if (uploadProgressHandler) { uploadProgressHandler(uploadProgress); }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (completionHandler) { completionHandler(YES, nil); }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (completionHandler) { completionHandler(NO, error); }
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completionHandler) { completionHandler(NO, error); }
    }];
}

@end
