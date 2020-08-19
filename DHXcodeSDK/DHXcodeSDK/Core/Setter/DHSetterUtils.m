//
//  DHSetterUtils.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHSetterUtils.h"
#import "DHCoreSetter.h"

@implementation DHSetterUtils
#pragma mark - Scheme属性 单值修改
/// 设置产品名称
+ (BOOL)setupProductName:(NSString *)productName
       withXcodeprojFile:(NSString *)xcodeprojFile
              targetName:(NSString *)targetName
       configurationName:(DHConfigurationName)configurationName
                   error:(NSError **)error {
    BOOL ret = [self setupSettings:@{kDHPlistKeyProductName:productName?:@""}
                 withXcodeprojFile:xcodeprojFile
                        targetName:targetName
                 configurationName:configurationName
                             error:error];
    
    return ret;
}
/// 设置bundleId
+ (BOOL)setupBundleId:(NSString *)bundleId
    withXcodeprojFile:(NSString *)xcodeprojFile
           targetName:(NSString *)targetName
    configurationName:(DHConfigurationName)configurationName
                error:(NSError **)error {
    BOOL ret = [self setupSettings:@{kDHPlistKeyBundleIdentifier:bundleId?:@""}
                 withXcodeprojFile:xcodeprojFile
                        targetName:targetName
                 configurationName:configurationName
                             error:error];
    return ret;
}
/// 设置teamId
+ (BOOL)setupTeamId:(NSString *)teamId
  withXcodeprojFile:(NSString *)xcodeprojFile
         targetName:(NSString *)targetName
  configurationName:(DHConfigurationName)configurationName
              error:(NSError **)error {
    BOOL ret = [self setupSettings:@{kDHBuildSettingsKeyTeamIdentifier:teamId?:@""}
                 withXcodeprojFile:xcodeprojFile
                        targetName:targetName
                 configurationName:configurationName
                             error:error];
    return ret;
}
/// 设置版本号
+ (BOOL)setupVersion:(NSString *)version
   withXcodeprojFile:(NSString *)xcodeprojFile
          targetName:(NSString *)targetName
   configurationName:(DHConfigurationName)configurationName
               error:(NSError **)error {
    BOOL ret = [self setupSettings:@{kDHPlistKeyVersion:version?:@""}
                 withXcodeprojFile:xcodeprojFile
                        targetName:targetName
                 configurationName:configurationName
                             error:error];
    return ret;
}
/// 设置子版本号
+ (BOOL)setupBuildVersion:(NSString *)buildVersion
        withXcodeprojFile:(NSString *)xcodeprojFile
               targetName:(NSString *)targetName
        configurationName:(DHConfigurationName)configurationName
                    error:(NSError **)error {
    BOOL ret = [self setupSettings:@{kDHPlistKeyBuildVersion:buildVersion?:@""}
                 withXcodeprojFile:xcodeprojFile
                        targetName:targetName
                 configurationName:configurationName
                             error:error];
    return ret;
}
/// 设置enable bitcode
+ (BOOL)setupEnableBitcode:(DHEnableBitcode)enableBitcode
         withXcodeprojFile:(NSString *)xcodeprojFile
                targetName:(NSString *)targetName
         configurationName:(DHConfigurationName)configurationName
                     error:(NSError **)error {
    BOOL ret = [self setupSettings:@{kDHBuildSettingsKeyEnableBitcode:enableBitcode?:@""}
                 withXcodeprojFile:xcodeprojFile
                        targetName:targetName
                 configurationName:configurationName
                             error:error];
    return ret;
}


#pragma mark - Scheme属性 多值修改
/// 多项设置
+ (BOOL)setupWithXcodeprojFile:(NSString *)xcodeprojFile
                    targetName:(NSString *)targetName
             configurationName:(DHConfigurationName)configurationName
                forDisplayName:(NSString *)displayName
                   productName:(NSString *)productName
                      bundleId:(NSString *)bundleId
                        teamId:(NSString *)teamId
                       version:(NSString *)version
                  buildVersion:(NSString *)buildVersion
                 encodeBitcode:(DHEnableBitcode)enableBitcode
                         error:(NSError **)error {
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:6];
    if ([displayName isKindOfClass:[NSString class]]) {
        [settings setValue:displayName forKey:kDHPlistKeyDisplayName];
    }
    if ([productName isKindOfClass:[NSString class]]) {
        [settings setValue:productName forKey:kDHPlistKeyProductName];
    }
    if ([bundleId isKindOfClass:[NSString class]]) {
        [settings setValue:bundleId forKey:kDHPlistKeyBundleIdentifier];
    }
    if ([teamId isKindOfClass:[NSString class]]) {
        [settings setValue:teamId forKey:kDHBuildSettingsKeyTeamIdentifier];
    }
    if ([version isKindOfClass:[NSString class]]) {
        [settings setValue:version forKey:kDHPlistKeyVersion];
    }
    if ([buildVersion isKindOfClass:[NSString class]]) {
        [settings setValue:buildVersion forKey:kDHPlistKeyBuildVersion];
    }
    if ([enableBitcode isKindOfClass:[NSString class]]) {
        [settings setValue:enableBitcode forKey:kDHBuildSettingsKeyEnableBitcode];
    }
    DHXcodeLog(@"[setupWithXcodeprojFile: %@]\n\
[targetName: %@]\n\
[configurationName: %@]\n\
[maybeSet: %@]",
                 xcodeprojFile, targetName, configurationName, settings);
    
    // 没啥要设置的，就yes吧
    if ([settings count] == 0) { return YES; }
    BOOL ret = [self setupSettings:settings
                 withXcodeprojFile:xcodeprojFile
                        targetName:targetName
                 configurationName:configurationName
                             error:error];
    return ret;
}

/// 多项自定义设置
+ (BOOL)setupSettings:(NSDictionary <NSString *, NSString *> *)settings
    withXcodeprojFile:(NSString *)xcodeprojFile
           targetName:(NSString *)targetName
    configurationName:(DHConfigurationName)configurationName
                error:(NSError **)error {
    NSDictionary *setterResult;
    DHERROR_CODE ret = [DHCoreSetter setupSettings:settings
                                 withXcodeprojFile:xcodeprojFile
                                        targetName:targetName
                                 configurationName:configurationName
                                      setterResult:&setterResult];
    if (!dh_isNoError(ret)) {
        NSString *desc = [NSString stringWithFormat:@"Setup info.plist or .pbxproj failed!\n\
[setterResult: %@]", setterResult];
        DH_ERROR_MAKER_CONVINENT(ret, desc);
        return NO;
    }
    return YES;
}

+ (void)resetSetupWithXcodeprojFile:(NSString *)xcodeprojFile {
    DHERROR_CODE ret = [DHCoreSetter resetAllSetupWithXcodeprojFile:xcodeprojFile];
    DHXcodeLog(@"Reset the history of project.pbxproj modification result: %zd", ret);
}

@end
