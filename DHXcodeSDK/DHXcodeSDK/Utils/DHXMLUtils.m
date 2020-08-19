//
//  DHXMLUtils.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHXMLUtils.h"
#import "DHXMLTools.h"

typedef NSString * DHEnableBitcodeBool;
static DHEnableBitcodeBool const kDHEnableBitcodeBoolTrue = @"true";
static DHEnableBitcodeBool const kDHEnableBitcodeBoolFalse = @"false";

@implementation DHXMLUtils

#pragma mark - 读取plist
+ (NSDictionary *)dictionaryForInfoPlistFile:(NSString *)plistFile {
    // 判断是否是.plist文件
    if (![DHPathUtils isPlistFile:plistFile]) { return nil; }
    
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
    
    // 判断是否解析成功
    if (![DHObjectTools isValidDictionary:plistDictionary]) { return nil; }
    
    return plistDictionary;
}

+ (BOOL)readInfoPlistFile:(NSString *)plistFile
           forDisplayName:(NSString * __autoreleasing _Nullable * _Nullable)displayName
              productName:(NSString * __autoreleasing _Nullable * _Nullable)productName
                 bundleId:(NSString * __autoreleasing _Nullable * _Nullable)bundleId
                  version:(NSString * __autoreleasing _Nullable * _Nullable)version
             buildVersion:(NSString * __autoreleasing _Nullable * _Nullable)buildVersion
           executableFile:(NSString * __autoreleasing _Nullable * _Nullable)executableFile
          applicationPath:(NSString * __autoreleasing _Nullable * _Nullable)applicationPath
                   teamId:(NSString * __autoreleasing _Nullable * _Nullable)teamId {
    // 判断是否是.plist文件
    if (![DHPathUtils isPlistFile:plistFile]) { return NO; }
    
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
    
    // 判断是否解析成功
    if (![DHObjectTools isValidDictionary:plistDictionary]) { return NO; }
    
    if (displayName) {
        *displayName = plistDictionary[kDHPlistKeyDisplayName];
    }
    if (productName) {
        *productName = plistDictionary[kDHPlistKeyProductName];
    }
    if (bundleId) {
        *bundleId = plistDictionary[kDHPlistKeyBundleIdentifier];
    }
    if (version) {
        *version = plistDictionary[kDHPlistKeyVersion];
    }
    if (buildVersion) {
        *buildVersion = plistDictionary[kDHPlistKeyBuildVersion];
    }
    if (executableFile) {
        *executableFile = plistDictionary[kDHPlistKeyExecutableFile];
    }
    // 存在kDHPlistKeyApplicationProperties字典值说明是.xcarchive第一层的info.plist
    if (![plistDictionary[kDHPlistKeyApplicationProperties] isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    NSDictionary *applicationProperties = plistDictionary[kDHPlistKeyApplicationProperties];
    if (applicationPath) {
        *applicationPath = applicationProperties[kDHPlistKeyApplicationPath];
    }
    if (teamId) {
        *teamId = applicationProperties[kDHPlistKeyTeam];
    }
    if (bundleId) {
        *bundleId = applicationProperties[kDHPlistKeyBundleIdentifier];
    }
    if (version) {
        *version = applicationProperties[kDHPlistKeyVersion];
    }
    if (buildVersion) {
        *buildVersion = applicationProperties[kDHPlistKeyBuildVersion];
    }
    return YES;
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
                    withBundleId:(NSString *)bundleId
                          teamId:(NSString *)teamId
                         channel:(DHChannel)channel
                     profileName:(NSString *)profileName
                   enableBitcode:(DHEnableBitcode)enableBitcode {
    NSXMLDocument *xmlDoc = [self createExportOptionsDocmentWithBundleId:bundleId
                                                                  teamId:teamId
                                                                 channel:channel
                                                             profileName:profileName
                                                           enableBitcode:enableBitcode];
    DHERROR_CODE ret = [DHXMLTools writeXMLDocument:xmlDoc toFile:plistFile];
    DHXcodeLog(@"Create exportOptions.plist file by OC result: %zd at path: %@", ret, plistFile);
    return dh_isNoError(ret);
}


#pragma mark - 创建NSXMLElement
+ (NSXMLElement *)exportOptionsNodeWithBundleId:(NSString *)bundleId
                                         teamId:(NSString *)teamId
                                        channel:(DHChannel)channel
                                    profileName:(NSString *)profileName
                                  enableBitcode:(DHEnableBitcode)enableBitcode {
    // 转化
    DHEnableBitcodeBool enableBitcodeBool = [self convertEnableBitcodeToBool:enableBitcode];
    
    return [self exportOptionsNodeWithBundleId:bundleId
                                        teamId:teamId
                                       channel:channel
                                   profileName:profileName
                             enableBitcodeBool:enableBitcodeBool];
}


+ (NSXMLElement *)exportOptionsNodeWithBundleId:(NSString *)bundleId
                                         teamId:(NSString *)teamId
                                        channel:(DHChannel)channel
                                    profileName:(NSString *)profileName
                              enableBitcodeBool:(DHEnableBitcodeBool)enableBitcodeBool {
    NSXMLElement *rootNode = [NSXMLElement elementWithName:@"dict"];
    // <key>teamID</key>
    // <string>teamId</string>
    NSXMLElement *teamIdNode = [NSXMLElement elementWithName:@"key" stringValue:@"teamID"];
    NSXMLElement *teamIdValue = [NSXMLElement elementWithName:@"string" stringValue:teamId];
    // <key>method</key>
    // <string>ad-hoc/development/app-store/enterprise</string>
    NSXMLElement *methodNode = [NSXMLElement elementWithName:@"key" stringValue:@"method"];
    NSXMLElement *methodValue = [NSXMLElement elementWithName:@"string" stringValue:channel];
    // <key>stripSwiftSymbols</key>
    // <true></true>
    NSXMLElement *swiftSymbolsNode = [NSXMLElement elementWithName:@"key" stringValue:@"stripSwiftSymbols"];
    NSXMLElement *swiftSymbolsValue = [NSXMLElement elementWithName:@"true"];
    // <key>provisioningProfiles</key>
    // <dict><key>bundleId</key><string>profileName</string> </dict>
    NSXMLElement *provisioning = [NSXMLElement elementWithName:@"key" stringValue:@"provisioningProfiles"];
    NSXMLElement *bundleAndProfileNode = [NSXMLElement elementWithName:@"dict"];
    NSXMLElement *bundleKey = [NSXMLElement elementWithName:@"key" stringValue:bundleId];
    NSXMLElement *profileValue = [NSXMLElement elementWithName:@"string" stringValue:profileName];
    [bundleAndProfileNode addChild:bundleKey];
    [bundleAndProfileNode addChild:profileValue];
    // <key>compileBitcode</key>
    // <true></true> or <false></false>
    NSXMLElement *compileBitcodeNode = [NSXMLElement elementWithName:@"key" stringValue:@"compileBitcode"];
    NSXMLElement *compileBitcodeValue = [NSXMLElement elementWithName:enableBitcodeBool];
    
    [rootNode addChild:teamIdNode];
    [rootNode addChild:teamIdValue];
    [rootNode addChild:methodNode];
    [rootNode addChild:methodValue];
    [rootNode addChild:swiftSymbolsNode];
    [rootNode addChild:swiftSymbolsValue];
    [rootNode addChild:provisioning];
    [rootNode addChild:bundleAndProfileNode];
    [rootNode addChild:compileBitcodeNode];
    [rootNode addChild:compileBitcodeValue];
    
    return rootNode;
}

#pragma mark - 创建NSXMLDocument
+ (NSXMLDocument *)createExportOptionsDocmentWithBundleId:(NSString *)bundleId
                                                   teamId:(NSString *)teamId
                                                  channel:(DHChannel)channel
                                              profileName:(NSString *)profileName
                                            enableBitcode:(DHEnableBitcode)enableBitcode {
    NSXMLElement *node = [self exportOptionsNodeWithBundleId:bundleId
                                                      teamId:teamId
                                                     channel:channel
                                                 profileName:profileName
                                               enableBitcode:enableBitcode];
    NSXMLDocument *xmlDoc = [DHXMLTools createPlistWithNode:node];
    return xmlDoc;
}


#pragma mark - DHEnableBitcode转化DHEnableBitcodeBool
+ (DHEnableBitcodeBool)convertEnableBitcodeToBool:(DHEnableBitcode)enableBitcode {
    if ([enableBitcode isEqualToString:kDHEnableBitcodeYES]) {
        return kDHEnableBitcodeBoolTrue;
    }
    return kDHEnableBitcodeBoolFalse;
}

@end
