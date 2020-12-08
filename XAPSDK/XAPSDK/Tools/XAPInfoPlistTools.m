//
//  XAPInfoPlistTools.m
//  XAPSDK
//
//  Created by Daniel on 2020/12/8.
//

#import "XAPInfoPlistTools.h"

@implementation XAPInfoPlistTools

#pragma mark - 读取plist
+ (NSDictionary *)dictionaryWithFileOrDictionary:(id)fileOrDictionary {
    if ([XAPTools isValidDictionary:fileOrDictionary]) {
        return fileOrDictionary;
    }
    if (![XAPTools isValidString:fileOrDictionary]) { return nil; }
    
    NSDictionary *result = [NSDictionary dictionaryWithContentsOfFile:fileOrDictionary];

    // 判断是否解析成功
    if (![XAPTools isValidDictionary:result]) { return nil; }
    
    return result;
}

+ (NSDictionary *)parseProvisionProfileInfoPlistWithPlistFileOrDictionary:(id)plistFileOrDictionary
                                                              profileName:(NSString * _Nullable __autoreleasing * _Nullable)profileName
                                                         bundleIdentifier:(NSString * _Nullable __autoreleasing * _Nullable)bundleIdentifier
                                                           teamIdentifier:(NSString * _Nullable __autoreleasing * _Nullable)teamIdentifier
                                                    applicationIdentifier:(NSString * _Nullable __autoreleasing * _Nullable)applicationIdentifier
                                                                     uuid:(NSString * _Nullable __autoreleasing * _Nullable)uuid
                                                                 teamName:(NSString * _Nullable __autoreleasing * _Nullable)teamName
                                                                  channel:(NSString * _Nullable __autoreleasing * _Nullable)channel
                                                          createTimestamp:(NSString * _Nullable __autoreleasing * _Nullable)createTimestamp
                                                          expireTimestamp:(NSString * _Nullable __autoreleasing * _Nullable)expireTimestamp
                                                             entitlements:(NSDictionary * _Nullable __autoreleasing * _Nullable)entitlements {
    
    NSDictionary *result = [self dictionaryWithFileOrDictionary:plistFileOrDictionary];

    // 判断是否解析成功
    if (!result) { return nil; }
    
    // 没有Entitlements键值说明文件可能并不是由.mobileprovision转化而来的plist文件
    if (![XAPTools isValidDictionary:result[kXAPKeyEntitlements]]) { return nil; }
    
    if (profileName) { *profileName = result[kXAPKeyName]; }
    if (teamName) { *teamName = result[kXAPKeyTeamName]; }
    if (entitlements) { *entitlements = result[kXAPKeyEntitlements]; }
    if (uuid) { *uuid = result[kXAPKeyUUID]; }
    
    {
        /*
         Create timestamp, Expire timestamp
         */

        if (createTimestamp) {
            NSDate *date = result[kXAPKeyCreationDate];
            *createTimestamp = [NSString stringWithFormat:@"%zd", (NSInteger)[date timeIntervalSince1970]];
        }

        if (expireTimestamp) {
            NSDate *date = result[kXAPKeyExpirationDate];
            *expireTimestamp = [NSString stringWithFormat:@"%zd", (NSInteger)[date timeIntervalSince1970]];
        }
    }

    {
        /*
         Application Identifier, Team Identifier, Bundle Identifier
         */
        
        NSString *appId = result[kXAPKeyEntitlements][kXAPKeyApplicationIdentifier];
        NSString *teamId = result[kXAPKeyEntitlements][kXAPKeyTeamIdentifier];
        
        if (applicationIdentifier) { *applicationIdentifier = appId; }
        if (teamIdentifier) { *teamIdentifier = teamId; }
        if (bundleIdentifier) {
            NSString *bundleId;
            // 拆分
            // 理论上格式是 appid: <teamid>.<bundleid>
            if (appId.length > (teamId.length+1)) {
                bundleId = [appId substringFromIndex:teamId.length+1];
            } else {
                // 理论上不可能执行到此处，以防万一
                // 以 . 分割排除第一项
                NSArray *components = [appId componentsSeparatedByString:@"."];
                if (components.count > 2) {
                    bundleId = [[components subarrayWithRange:NSMakeRange(1, components.count-1)] componentsJoinedByString:@"."];
                } else {
                    bundleId = appId;
                }
            }
            *bundleIdentifier = bundleId;
        }
    }

    {
        /*
         Channel
         */
        if (channel) {
            BOOL isProvisionedDevicesExist = result[kXAPKeyProvisionedDevices] ? YES : NO;
            BOOL get_task_allow = [result[kXAPKeyEntitlements][kXAPKeyGetTaskAllow] boolValue];
            BOOL isProvisionsAllDevicesExist = result[kXAPKeyProvisionsAllDevices] ?  YES : NO;

            if (isProvisionedDevicesExist) {
                if (get_task_allow) {
                    *channel = kXAPChannelDevelopment;
                } else {
                    *channel = kXAPChannelAdHoc;
                }
            } else if (isProvisionsAllDevicesExist) {
                BOOL isEnterprise = [result[kXAPKeyProvisionsAllDevices] boolValue];
                if (isEnterprise) {
                    *channel = kXAPChannelEnterprise;
                } else {
                    *channel = kXAPChannelAppStore;
                }
            } else {
                *channel = kXAPChannelAppStore;
            }
        }
    }
    
    return result;
}


+ (NSDictionary *)parseProjectOrAppInfoPlistFileWithPlistFileOrDictionary:(NSString *)plistFileOrDictionary
                                                              displayName:(NSString * __autoreleasing _Nullable * _Nullable)displayName
                                                              productName:(NSString * __autoreleasing _Nullable * _Nullable)productName
                                                         bundleIdentifier:(NSString * __autoreleasing _Nullable *  _Nullable)bundleIdentifier
                                                             shortVersion:(NSString * __autoreleasing _Nullable * _Nullable)shortVersion
                                                                  version:(NSString * __autoreleasing _Nullable * _Nullable)version
                                                           executableFile:(NSString * __autoreleasing _Nullable * _Nullable)executableFile {
    NSDictionary *result = [self dictionaryWithFileOrDictionary:plistFileOrDictionary];

    // 判断是否解析成功
    if (!result) { return nil; }

    if (displayName) {
        *displayName = result[kXAPKeyDisplayName];
    }
    if (productName) {
        *productName = result[kXAPKeyBundleName];
    }
    if (bundleIdentifier) {
        *bundleIdentifier = result[kXAPKeyBundleIdentifier];
    }
    if (shortVersion) {
        *shortVersion = result[kXAPKeyShortVersion];
    }
    if (version) {
        *version = result[kXAPKeyVersion];
    }
    if (executableFile) {
        *executableFile = result[kXAPKeyExecutableFile];
    }
    return result;
}

+ (NSDictionary *)parseXcarchiveInfoPlistWithPlistFileOrDictionary:(id)plistFileOrDictionary
                                                              name:(NSString * __autoreleasing _Nullable * _Nullable)name
                                                        schemeName:(NSString * __autoreleasing _Nullable * _Nullable)schemeName
                                                      creationDate:(NSDate * __autoreleasing _Nullable * _Nullable)creationDate
                                                   applicationPath:(NSString * __autoreleasing _Nullable * _Nullable)applicationPath
                                                  bundleIdentifier:(NSString * __autoreleasing _Nullable *  _Nullable)bundleIdentifier
                                                    teamIdentifier:(NSString * __autoreleasing _Nullable * _Nullable)teamIdentifier
                                                      shortVersion:(NSString * __autoreleasing _Nullable * _Nullable)shortVersion
                                                           version:(NSString * __autoreleasing _Nullable * _Nullable)version
                                                     architectures:(NSArray * __autoreleasing _Nullable * _Nullable)architectures
                                                   signingIdentity:(NSString * __autoreleasing _Nullable * _Nullable)signingIdentity {

    NSDictionary *result = [self dictionaryWithFileOrDictionary:plistFileOrDictionary];

    // 判断是否解析成功
    if (!result) { return nil; }
    // 不存在ApplicationProperties字典简直将视为无效
    if (![XAPTools isValidDictionary:result[kXAPKeyApplicationProperties]]) { return nil; }
    
    if (name) {
        *name = result[kXAPKeyName];
    }
    if (schemeName) {
        *schemeName = result[kXAPKeySchemeName];
    }
    if (creationDate) {
        *creationDate = result[kXAPKeyCreationDate];
    }
    
    {
        /*
         ApplicationProperties
         */
        NSDictionary *applicationPathDict = result[kXAPKeyApplicationProperties];
        if (applicationPath) {
            *applicationPath = applicationPathDict[kXAPKeyApplicationPath];
        }
        if (bundleIdentifier) {
            *bundleIdentifier = applicationPathDict[kXAPKeyBundleIdentifier];
        }
        if (teamIdentifier) {
            *teamIdentifier = applicationPathDict[kXAPKeyTeam];
        }
        if (shortVersion) {
            *shortVersion = applicationPathDict[kXAPKeyShortVersion];
        }
        if (version) {
            *version = applicationPathDict[kXAPKeyVersion];
        }
        if (signingIdentity) {
            *signingIdentity = applicationPathDict[kXAPKeySigningIdentity];
        }
        if (architectures) {
            *architectures = applicationPathDict[kXAPKeyArchitectures];
        }
    }
    
    return result;
}


#pragma mark - 创建plist

/**
    
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
   <key>teamID</key>
   <string>你的TeamId</string>
   <key>method</key>
   <string>ad-hoc/development/app-store/enterprise</string>
   <key>stripSwiftSymbols</key>
   <true/>
   <key>provisioningProfiles</key>
   <dict>
       <key>你的bundleId</key>
       <string>你的profile名称</string>
   </dict>
   <key>compileBitcode</key>
   <false/> <!或者<true/>>
   </dict>
   </plist>\n", teamId, channel, bundleId, profileName, enableBitcode];
*/
+ (BOOL)createExportOptionsPlist:(NSString *)plistFile
            withBundleIdentifier:(NSString *)bundleIdentifier
                  teamIdentifier:(NSString *)teamIdentifier
                         channel:(XAPChannel)channel
                     profileName:(NSString *)profileName
                   enableBitcode:(XAPEnableBitcode)enableBitcode {

    BOOL enableBitcodeBoolean = [enableBitcode isEqualToString:kXAPEnableBitcodeYES] ? YES : NO;
    
    NSDictionary *dict = [self exportOptionsDictionaryWithBundleIdentifier:bundleIdentifier
                                                            teamIdentifier:teamIdentifier
                                                                   channel:channel
                                                               profileName:profileName
                                                         enableBitcodeBool:enableBitcodeBoolean];
    
    BOOL ret = [dict writeToFile:plistFile atomically:YES];
    
    return ret;
}

+ (NSDictionary *)exportOptionsDictionaryWithBundleIdentifier:(NSString *)bundleIdentifier
                                               teamIdentifier:(NSString *)teamIdentifier
                                                      channel:(XAPChannel)channel
                                                  profileName:(NSString *)profileName
                                            enableBitcodeBool:(BOOL)enableBitcodeBool {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    [result setValue:teamIdentifier forKey:@"teamID"];
    [result setValue:channel forKey:@"method"];
    [result setValue:@(true) forKey:@"stripSwiftSymbols"];
    NSMutableDictionary *provisioningProfilesDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [provisioningProfilesDict setValue:profileName forKey:bundleIdentifier];
    
    [result setValue:provisioningProfilesDict forKey:@"provisioningProfiles"];
    [result setValue:@(enableBitcodeBool) forKey:@"compileBitcode"];
    
    return [result copy];
}

@end
