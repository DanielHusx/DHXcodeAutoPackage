//
//  DHCoreSetter.m
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import "DHCoreSetter.h"
#import "DHProjectModel.h"
#import "DHTargetModel.h"
#import "DHBuildConfigurationModel.h"
#import "PBXProjParser.h"
#import "PBXTarget.h"
#import "XCConfigurationList.h"
#import "XCBuildConfiguration.h"
#import "NSString+DHPBXProjSetter.h"
#import "DHScriptCommand.h"
#import "DHXMLUtils.h"
#import "DHDataTools.h"

#import "DHSetterCacher.h"

static NSString *const kDHSettingsInfoKeyValue = @"value";
static NSString *const kDHSettingsInfoKeySetValue = @"setValue";
static NSString *const kDHSettingsInfoKeyKey = @"key";
static NSString *const kDHSettingsInfoKeyExistType = @"existType";

static inline BOOL checkKeyIsKindOfPlistKey(NSString *key) {
    return ![key containsString:@"_"];
}

typedef NS_OPTIONS(NSInteger, DHDBSetterKeyExistType) {
    /// key不知道该在哪里
    DHDBSetterKeyExistTypeNoWhere           = 0,
    /// key应该在buildSettings里
    DHDBSetterKeyExistTypeInBuildSettings   = 1 << 0,
    /// key应该在info.plist里
    DHDBSetterKeyExistTypeInInfoPlist       = 1 << 1,
    /// 都有可能
    DHDBSetterKeyExistTypeBoth              = DHDBSetterKeyExistTypeInBuildSettings | DHDBSetterKeyExistTypeInInfoPlist,
};

@implementation DHCoreSetter
#pragma mark - public setter
/// 多项设置
+ (DHERROR_CODE)setupSettings:(NSDictionary <NSString *, NSString *> *)settings
            withXcodeprojFile:(NSString *)xcodeprojFile
                   targetName:(NSString *)targetName
            configurationName:(DHConfigurationName)configurationName
                 setterResult:(NSDictionary <NSString *, NSNumber *> **)setterResult {
    DHERROR_CODE ret = [self setupSettingsOrSettingsInfo:settings
                                       withXcodeprojFile:xcodeprojFile
                                              targetName:targetName
                                       configurationName:configurationName
                                            setterResult:setterResult];
    return ret;
}


#pragma mark - private setter
/// 多项设置核心方法
+ (DHERROR_CODE)setupSettingsOrSettingsInfo:(NSDictionary <NSString *, id> *)settingsOrSettingsInfo
                          withXcodeprojFile:(NSString *)xcodeprojFile
                                 targetName:(NSString *)targetName
                          configurationName:(DHConfigurationName)configurationName
                               setterResult:(NSDictionary <NSString *, NSNumber *> **)setterResult {
    if (![DHPathUtils isXcodeprojFile:xcodeprojFile]) {
        return DHERROR_SETTER_XCODEPROJ_INVALID;
    }
    if (![DHObjectTools isValidString:targetName]) {
        return DHERROR_SETTER_TARGET_INVALID;
    }
    if (![DHDataTools validateConfigurationName:configurationName]) {
        return DHERROR_SETTER_CONFIGURATION_INVALID;
    }
    if (![DHObjectTools isValidDictionary:settingsOrSettingsInfo]) {
        return DHERROR_SETTER_SETTINGS_INVALID;
    }

    // 查找到对应配置
    XCBuildConfiguration *buildConfiguration;
    DHERROR_CODE errorCode = [self findBuildConfigurationWithXcodeprojFile:xcodeprojFile
                                                                targetName:targetName
                                                         configurationName:configurationName
                                                        buildConfiguration:&buildConfiguration];

    DHXcodeLog(@"Find buildConfigurations result: %zd", errorCode);
    if (!dh_isNoError(errorCode)) { return errorCode; }

    // 记录当前设置信息集合
    NSDictionary *settingsInfo;
    NSString *infoPlistFile;
    BOOL isSettingsInfo = [self isSettingsInfo:settingsOrSettingsInfo];
    BOOL isSettings = [self isSettings:settingsOrSettingsInfo];
    
    if (isSettingsInfo) {
        // 已经信息集合，则解析info.plist
        settingsInfo = settingsOrSettingsInfo;
        infoPlistFile = [self fetchInfoPlistFileWithXcodeprojFile:xcodeprojFile
                                               buildConfiguration:buildConfiguration];
    }
    if (isSettings) {
        // 组装信息集合
        settingsInfo = [self fetchSettingsInfoWithSettings:settingsOrSettingsInfo
                                                targetName:targetName
                                             xcodeprojFile:xcodeprojFile
                                        buildConfiguration:buildConfiguration
                                             infoPlistFile:&infoPlistFile];
    }

    if (!settingsInfo) { return DHERROR_SETTER_SETTINGS_INFO_PARSE_FAILED; }
    if (![DHPathUtils isPlistFile:infoPlistFile]) {
        DHXcodeLog(@"Parsed info.plist file not exist!\n\
[xcodeprojFile: %@]\n\
[info.plist: %@]", xcodeprojFile, infoPlistFile);
        return DHERROR_SETTER_INFO_PLIST_INVALID;
    }
    
    NSString *pbxprojFile = [DHPathUtils getPbxprojFileWithXcodeprojFile:xcodeprojFile];

    // 读取pbxproj为字符串
    NSError *error;
    NSMutableString *pbxprojString = [[NSString stringWithContentsOfFile:pbxprojFile
                                                                encoding:NSUTF8StringEncoding
                                                                   error:&error] mutableCopy];
    if (error) {
        DHXcodeLog(@"Read project.pbxproj file failed!\n\
[pbxprojFile: %@]\n\
[error: %@]", pbxprojFile, error);
        return DHERROR_SETTER_PBXPROJ_READ_FAILED;
    }

    NSString *buildConfiguratioinId = buildConfiguration.objectId;
    // 设置
    BOOL ret = NO;
    ret = [self processSetupWithSettingsInfo:settingsInfo
                               pbxprojString:pbxprojString
                               xcodeprojFile:xcodeprojFile
                               infoPlistFile:infoPlistFile
                       buildConfiguratioinId:buildConfiguratioinId
                                setterResult:setterResult];
    
    DHXcodeLog(@"[processSetupWithSettingsInfo: %@]\n\
[xcodeprojFile: %@]\n\
[infoPlistFile: %@]\n\
[buildConfiguratioinId: %@]\n\
[setterResult: %@]\n\
[result: %@]",
                 settingsInfo, xcodeprojFile, infoPlistFile, buildConfiguratioinId, setterResult?*setterResult:@"", ret?@"YES":@"NO");
    
    // 这里能够失败，基本就算解析错误了
    if (!ret) { return DHERROR_SETTER_SETUP_FAILED; }

    // 保存
    ret = [pbxprojString writeToFile:pbxprojFile
                          atomically:YES
                            encoding:NSUTF8StringEncoding
                               error:&error];
    if (!ret) {
        DHXcodeLog(@"Write string to project.pbxproj file failed! \n\
[pbxprojFile: %@]\n\
[error: %@]", pbxprojFile, error);
        return DHERROR_SETTER_SETUP_FILE_WRITE_FAILED;
    }

    if (isSettings) {
        // 写缓存，保存原有的设置
        [DHSetterCacher  cacheBuildSettings:settingsInfo
                           withXcodeprojFile:xcodeprojFile
                                  targetName:targetName
                           configurationName:configurationName];
    }
    return DHERROR_NO_ERROR;
}


#pragma mark - 核心设置/重置方法
/// 设置多参数键值对
///
/// @param settingsInfo 当前项目或info.plist的关联settings参数的key的信息
/// @param pbxprojString .pbxproj字符串
/// @param xcodeprojFile .xcodeproj文件路径
/// @param infoPlistFile info.plist文件路径
/// @param buildConfiguratioinId 配置id
/// @param setterResult 结果
/// @return YES: 全部设置成功；NO: 存在设置失败项
+ (BOOL)processSetupWithSettingsInfo:(NSDictionary <NSString *, NSDictionary *> *)settingsInfo
                       pbxprojString:(NSMutableString *)pbxprojString
                       xcodeprojFile:(NSString *)xcodeprojFile
                       infoPlistFile:(NSString *)infoPlistFile
               buildConfiguratioinId:(NSString *)buildConfiguratioinId
                        setterResult:(NSDictionary **)setterResult {

    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:settingsInfo.count];
    BOOL ret = NO;
    for (NSString *key in settingsInfo.allKeys) {

        NSDictionary *dictionary = settingsInfo[key];

        id currentValue = dictionary[kDHSettingsInfoKeyValue];
        DHDBSetterKeyExistType existType = [dictionary[kDHSettingsInfoKeyExistType] integerValue];
        NSString *currentKey = dictionary[kDHSettingsInfoKeyKey];
        id value = dictionary[kDHSettingsInfoKeySetValue];

        BOOL keyExist = [currentValue isKindOfClass:[NSString class]];
        BOOL setKeyExist = [value isKindOfClass:[NSString class]];

        if (existType == DHDBSetterKeyExistTypeInInfoPlist) {
            if (!keyExist && !setKeyExist) {
                // 都不需要则默认算设置成功了
                [result setValue:@(YES) forKey:key];
                continue;
            }
            if (!keyExist && setKeyExist) {
                // 添加属性到info.plist
                ret = [self appendInfoPlistForSettingKey:currentKey
                                            settingValue:value
                                       withInfoPlistFile:infoPlistFile];
                [result setValue:@(ret) forKey:key];
                continue;
            }
            if (keyExist && !setKeyExist) {
                // 删除info.plist属性
                ret = [self removeInfoPlistForSettingKey:currentKey
                                       withInfoPlistFile:infoPlistFile];
                [result setValue:@(ret) forKey:key];
                continue;
            }
            if ([currentValue isEqualToString:value]) {
                // 相等就不需要设置了
                [result setValue:@(YES) forKey:key];
                continue;
            }
            // 修改info.plist属性值
            ret = [self modifyInfoPlistForSettingKey:currentKey
                                        settingValue:value
                                   withInfoPlistFile:infoPlistFile];
            [result setValue:@(ret) forKey:key];
            continue;
        }
        if (existType == DHDBSetterKeyExistTypeInBuildSettings) {
            if (!keyExist && !setKeyExist) {
                // 都不需要则默认算设置成功了
                [result setValue:@(YES) forKey:key];
                continue;
            }
            if (!keyExist && setKeyExist) {
                // 添加属性到buildSettings
                ret = [self appendBuildSetting:currentKey
                                  settingValue:value
                             withPBXProjString:pbxprojString
                         buildConfiguratioinId:buildConfiguratioinId];
                [result setValue:@(ret) forKey:key];
                continue;
            }
            if (keyExist && !setKeyExist) {
                // 删除buildSettings属性
                ret = [self removeBuildSetting:currentKey
                             withPBXProjString:pbxprojString
                         buildConfiguratioinId:buildConfiguratioinId];
                [result setValue:@(ret) forKey:key];
                continue;
            }
            if ([currentValue isEqualToString:value]) {
                // 相等就不需要设置了
                [result setValue:@(YES) forKey:key];
                continue;
            }
            // 修改buildSettings属性值
            ret = [self modifyBuildSetting:currentKey
                              settingValue:value
                         withPBXProjString:pbxprojString
                     buildConfiguratioinId:buildConfiguratioinId];
            [result setValue:@(ret) forKey:key];
            continue;
        }

    }

    if (setterResult) { *setterResult = [result copy]; }

    // 检测是否存在失败项
    ret = ![result.allValues containsObject:@(NO)];
    return ret;
}


#pragma mark - 增删改
#pragma mark *** pbxproj ***
+ (BOOL)modifyBuildSetting:(DHBuildSettingsKey)buildSetting
             settingValue:(NSString *)settingValue
        withPBXProjString:(NSMutableString *)pbxprojString
    buildConfiguratioinId:(NSString *)buildConfiguratioinId {
    NSString *value;
    NSRange valueRange;
    BOOL ret = NO;
    // 查找配置的值与位置——每次都得重新计算是因为其他更改，可能导致Range变了
    ret = [pbxprojString findDictionaryWithKey:buildConfiguratioinId
                                         value:&value
                                    valueRange:&valueRange];
    if (!ret) { return NO; }
    NSRange buildConfigurationRange = valueRange;

    // 查找buildSettings的值与位置——此处是相对于buildConfiguration的值计算的
    ret = [pbxprojString findDictionaryWithKey:@"buildSettings"
                                         range:buildConfigurationRange
                                         value:&value
                                    valueRange:&valueRange];
    if (!ret) { return NO; }

    // 此位置是对于整个pbxprojString来说的
    NSRange buildSettingsRange = valueRange;

    // 设置
    ret = [pbxprojString setupAssigmentForValue:settingValue
                                        withKey:buildSetting
                                          range:buildSettingsRange];
    if (!ret) { return NO; }

    return YES;
}

+ (BOOL)appendBuildSetting:(NSString *)buildSetting
              settingValue:(NSString *)settingValue
         withPBXProjString:(NSMutableString *)pbxprojString
     buildConfiguratioinId:(NSString *)buildConfiguratioinId {
    NSString *value;
    NSRange valueRange;
    BOOL ret = NO;
    // 查找配置的值与位置——每次都得重新计算是因为其他更改，可能导致Range变了
    ret = [pbxprojString findDictionaryWithKey:buildConfiguratioinId
                                         value:&value
                                    valueRange:&valueRange];
    if (!ret) { return NO; }
    NSRange buildConfigurationRange = valueRange;

    // 查找buildSettings的值与位置——此处是相对于buildConfiguration的值计算的
    ret = [pbxprojString findDictionaryWithKey:@"buildSettings"
                                         range:buildConfigurationRange
                                         value:&value
                                    valueRange:&valueRange];
    if (!ret) { return NO; }

    // 此位置是对于整个pbxprojString来说的
    NSRange buildSettingsRange = valueRange;

    // 新增
    ret = [pbxprojString appendAssigmentWithKey:buildSetting
                                          value:settingValue
                                          range:buildSettingsRange];
    if (!ret) { return NO; }

    return YES;
}

+ (BOOL)removeBuildSetting:(DHBuildSettingsKey)buildSetting
         withPBXProjString:(NSMutableString *)pbxprojString
     buildConfiguratioinId:(NSString *)buildConfiguratioinId {
    NSString *value;
    NSRange valueRange;
    BOOL ret = NO;
    // 查找配置的值与位置——每次都得重新计算是因为其他更改，可能导致Range变了
    ret = [pbxprojString findDictionaryWithKey:buildConfiguratioinId
                                         value:&value
                                    valueRange:&valueRange];
    if (!ret) { return NO; }
    NSRange buildConfigurationRange = valueRange;

    // 查找buildSettings的值与位置——此处是相对于buildConfiguration的值计算的
    ret = [pbxprojString findDictionaryWithKey:@"buildSettings"
                                         range:buildConfigurationRange
                                         value:&value
                                    valueRange:&valueRange];
    if (!ret) { return NO; }

    // 此位置是对于整个pbxprojString来说的
    NSRange buildSettingsRange = valueRange;

    // 新增
    ret = [pbxprojString deleteAssigmentForKey:buildSetting
                                         range:buildSettingsRange];
    if (!ret) { return NO; }

    return YES;
}

#pragma mark *** info.plist ***
+ (BOOL)modifyInfoPlistForSettingKey:(NSString *)settingKey
                       settingValue:(NSString *)settingValue
                  withInfoPlistFile:(NSString *)infoPlistFile {
    NSError *error;
    BOOL ret = [DHScriptCommand plistModifyAttributeWithInfoPlist:infoPlistFile
                                                     attributeKey:settingKey
                                                   attributeValue:settingValue
                                                            error:&error];

    return ret;
}

+ (BOOL)appendInfoPlistForSettingKey:(NSString *)settingKey
                        settingValue:(NSString *)settingValue
                   withInfoPlistFile:(NSString *)infoPlistFile {
    NSError *error;
    BOOL ret = [DHScriptCommand plistAppendAttributeWithInfoPlist:infoPlistFile
                                                     attributeKey:settingKey
                                                   attributeValue:settingValue
                                                            error:&error];
    return ret;
}

+ (BOOL)removeInfoPlistForSettingKey:(NSString *)settingKey
                   withInfoPlistFile:(NSString *)infoPlistFile {
    NSError *error;
    BOOL ret = [DHScriptCommand plistDeleteAttributeWithInfoPlist:infoPlistFile
                                                     attributeKey:settingKey
                                                            error:&error];
    return ret;
}

#pragma mark - 设置信息
+ (NSDictionary *)fetchSettingsInfoWithSettings:(NSDictionary <NSString *, NSString *> *)settings
                                     targetName:(NSString *)targetName
                                  xcodeprojFile:(NSString *)xcodeprojFile
                             buildConfiguration:(XCBuildConfiguration *)buildConfiuration
                                  infoPlistFile:(NSString **)infoPlistFile {
    // 解析info.plist为字典
    NSString *infoPlistFilePath = [self fetchInfoPlistFileWithXcodeprojFile:xcodeprojFile
                                                         buildConfiguration:buildConfiuration];
    NSDictionary *infoDictionary = [DHXMLUtils dictionaryForInfoPlistFile:infoPlistFilePath];
    if (infoPlistFile) { *infoPlistFile = infoPlistFilePath; }
    
    // 以下数据有限从info.plist中读取，然后在从关联的.pbxproj对应的字段读取
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:7];

    for (NSString *key in settings.allKeys) {
        NSString *buildSettingsKey = key;
        // 键值存在于info.plist
        if (checkKeyIsKindOfPlistKey(key)) {
            NSString *plistKey = key;
            NSString *valueInPlist = infoDictionary[key];
            BOOL keyExist = [infoDictionary.allKeys containsObject:key];
            
            if (!keyExist) {
                // 理论上info.plist应该存在的key，但是不存在该键值，则记录为空
                [result setValue:@{
                                    kDHSettingsInfoKeyValue:@(NO),// 设置为@NO标记为当前Key是不存在的
                                    kDHSettingsInfoKeyKey:plistKey,
                                    kDHSettingsInfoKeyExistType:@(DHDBSetterKeyExistTypeInInfoPlist),
                                    kDHSettingsInfoKeySetValue:settings[key]
                                    } forKey:key];
                continue;
            }

            if (![DHObjectTools isValidString:valueInPlist]) {
                // 存在键值，但是值为空
                [result setValue:@{
                                    kDHSettingsInfoKeyValue:@"",
                                    kDHSettingsInfoKeyKey:plistKey,
                                    kDHSettingsInfoKeyExistType:@(DHDBSetterKeyExistTypeInInfoPlist),
                                    kDHSettingsInfoKeySetValue:settings[key]
                                    } forKey:key];
                continue;
            }

            if (!checkPlistValueRelatived(valueInPlist)) {
                // 存在正确值，且未关联pbxproj则直接存储
                [result setValue:@{
                                   kDHSettingsInfoKeyValue:valueInPlist,
                                   kDHSettingsInfoKeyKey:plistKey,
                                   kDHSettingsInfoKeyExistType:@(DHDBSetterKeyExistTypeInInfoPlist),
                                   kDHSettingsInfoKeySetValue:settings[key]
                                   } forKey:key];
                continue;
            }

            // 关联到pbxproj时，更改键值，希望能从buildSetting中获取
            buildSettingsKey = fetchBuildSettingsKeyWithPlistRelativeValue(valueInPlist);

        }

        // 在plist中找不到的就尝试在BuildSetting中找，这种方式就放弃了校验Key，毕竟Key太多了
        // 键值存在与buildSettings
        NSString *valueInBuildSetting = [buildConfiuration getBuildSetting:buildSettingsKey];
        BOOL keyExist = [buildConfiuration containsBuildSetting:buildSettingsKey];
        if (!keyExist) {
            // 理论上buildSettings应该存在的key，但是不存在该键值，则记录为空
            [result setValue:@{
                                kDHSettingsInfoKeyValue:@(NO),
                                kDHSettingsInfoKeyKey:buildSettingsKey,
                                kDHSettingsInfoKeyExistType:@(DHDBSetterKeyExistTypeInBuildSettings),
                                kDHSettingsInfoKeySetValue:settings[key]
                                } forKey:key];
            continue;
        }
        // 存在可能到这里还是关联值$(TARGET_NAME)
        if ([valueInBuildSetting isEqualToString:kDHRelativeValueTargetName]) {
            valueInBuildSetting = targetName;
        }
        [result setValue:@{
                           kDHSettingsInfoKeyValue:valueInBuildSetting,
                           kDHSettingsInfoKeyKey:buildSettingsKey,
                           kDHSettingsInfoKeyExistType:@(DHDBSetterKeyExistTypeInBuildSettings),
                           kDHSettingsInfoKeySetValue:settings[key]
                           } forKey:key];
        continue;
        
    }

    return [result copy];
}

+ (NSDictionary *)revertSettingsInfoValue:(NSDictionary <NSString *, NSDictionary *> *)settingsInfo {
    NSMutableDictionary *mutableSettingInfo = [settingsInfo mutableCopy];
    for (NSString *key in settingsInfo.allKeys) {
        NSDictionary *dict = settingsInfo[key];
        NSMutableDictionary *mutableSettingsInfoValue = [dict mutableCopy];
        // 交换值
        id value = mutableSettingsInfoValue[kDHSettingsInfoKeyValue];
        id setValue = mutableSettingsInfoValue[kDHSettingsInfoKeySetValue];
        [mutableSettingsInfoValue setValue:value forKey:kDHSettingsInfoKeySetValue];
        [mutableSettingsInfoValue setValue:setValue forKey:kDHSettingsInfoKeyValue];

        [mutableSettingInfo setObject:[mutableSettingsInfoValue copy] forKey:key];
    }
    return [mutableSettingInfo copy];
}

#pragma mark - 项目解析
/// 查找XCBuildConfiguration
+ (DHERROR_CODE)findBuildConfigurationWithXcodeprojFile:(NSString *)xcodeprojFile
                                             targetName:(NSString *)targetName
                                      configurationName:(DHConfigurationName)configurationName
                                     buildConfiguration:(XCBuildConfiguration **)buildConfiguration {
    if (![DHPathUtils isXcodeprojFile:xcodeprojFile]) {
        return DHERROR_SETTER_XCODEPROJ_INVALID;
    }
    // 解析
    PBXProjParser *parser = [self parserWithXcodeprojFile:xcodeprojFile];
    if (!parser.project) {
        return DHERROR_SETTER_PBXPROJ_PARSE_FAILED;
    }
    // 查找
    for (PBXTarget *target in parser.project.targets) {
        if ([target.getName isEqualToString:targetName]) {
            for (XCBuildConfiguration *config in target.buildConfigurationList.buildConfigurations) {
                if ([config.getName isEqualToString:configurationName]) {
                    *buildConfiguration = config;
                    return DHERROR_NO_ERROR;
                }
            }
            break;
        }
    }

    return DHERROR_SETTER_BUILD_CONFIGURATION_NOT_FOUND;
}

/// 解析项目所有信息
+ (PBXProjParser *)parserWithXcodeprojFile:(NSString *)xcodeprojFile {
    NSString *parsedXcodeprojFile = [[PBXProjParser sharedInstance].pbxprojPath stringByDeletingLastPathComponent];
    if (![parsedXcodeprojFile isEqualToString:xcodeprojFile]) {
        [[PBXProjParser sharedInstance] parseProjectWithPath:xcodeprojFile];
    }

    return [PBXProjParser sharedInstance];
}

+ (BOOL)isSettingsInfo:(NSDictionary *)dict {
    BOOL ret = YES;
    for (id value in dict.allValues) {
        if (![value isKindOfClass:[NSDictionary class]]) { ret = NO; break; }
    }
    return ret;
}

+ (BOOL)isSettings:(NSDictionary *)dict {
    BOOL ret = YES;
    for (id value in dict.allValues) {
        if (![value isKindOfClass:[NSString class]]) { ret = NO; break; }
    }
    return ret;
}

+ (NSString *)fetchInfoPlistFileWithXcodeprojFile:(NSString *)xcodeprojFile
                               buildConfiguration:(XCBuildConfiguration *)buildConfiuration {
    NSString *infoPlistRelativeFile = [buildConfiuration getBuildSetting:kDHBuildSettingsKeyInfoPlistFile];
    NSString *infoPlistFile = [DHPathUtils getAbsolutePathWithXcodeprojFile:xcodeprojFile
                                                               relativePath:infoPlistRelativeFile];
    return infoPlistFile;
}

#pragma mark - 重置方法

/// 重置修改
+ (DHERROR_CODE)resetAllSetupWithXcodeprojFile:(NSString *)xcodeprojFile {
    if (![DHPathUtils isXcodeprojFile:xcodeprojFile]) {
        return DHERROR_SETTER_RESET_XCODEPROJ_INVALID;
    }
    // 读取已缓存的设置
    NSDictionary *cachedBuildSettings = [DHSetterCacher  readBuildSettingsCacheWithXcodeprojFile:xcodeprojFile];
    if (![DHObjectTools isValidDictionary:cachedBuildSettings]) {
        return DHERROR_SETTER_RESET_CACHE_READ_EMPTY;
    }

    DHERROR_CODE ret = DHERROR_NO_ERROR;
    for (NSString *targetName in cachedBuildSettings.allKeys) {
        NSDictionary *configurations = cachedBuildSettings[targetName];
        for (NSString *configurationName in configurations.allKeys) {
            NSDictionary *settingsInfo = configurations[configurationName];
            if (!settingsInfo) { continue; }
            // 还原设置值
            NSDictionary *revertSettingsInfo = [self revertSettingsInfoValue:settingsInfo];
            // 设置
            ret = [self setupSettingsOrSettingsInfo:revertSettingsInfo
                                  withXcodeprojFile:xcodeprojFile
                                         targetName:targetName
                                  configurationName:configurationName
                                       setterResult:nil];
            // 设置成功与否，随它去吧
        }
    }

    // 删除缓存
    [DHSetterCacher  removeBuildSettingsCacheWithXcodeprojFile:xcodeprojFile];
    return DHERROR_NO_ERROR;
}


@end
