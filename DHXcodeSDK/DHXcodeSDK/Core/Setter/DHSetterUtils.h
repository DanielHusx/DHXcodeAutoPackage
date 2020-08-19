//
//  DHSetterUtils.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHSetterUtils : NSObject
#pragma mark - Scheme属性 修改
/// 设置产品名称
///
/// @param productName 产品名称
/// @param xcodeprojFile .xcodeproj文件路径
/// @param targetName scheme名称
/// @param configurationName Debug/Release
/// @param error 错误
/// @return YES：设置成功；NO：设置失败
+ (BOOL)setupProductName:(NSString *)productName
       withXcodeprojFile:(NSString *)xcodeprojFile
              targetName:(NSString *)targetName
       configurationName:(DHConfigurationName)configurationName
                   error:(NSError * _Nullable __autoreleasing * _Nullable)error;

/// 设置bundleId
///
/// @param bundleId bundleId
/// @param xcodeprojFile .xcodeproj文件路径
/// @param targetName scheme名称
/// @param configurationName Debug/Release
/// @param error 错误
/// @return YES：设置成功；NO：设置失败
+ (BOOL)setupBundleId:(NSString *)bundleId
    withXcodeprojFile:(NSString *)xcodeprojFile
           targetName:(NSString *)targetName
    configurationName:(DHConfigurationName)configurationName
                   error:(NSError * _Nullable __autoreleasing * _Nullable)error;
/// 设置teamId
///
/// @param teamId teamId
/// @param xcodeprojFile .xcodeproj文件路径
/// @param targetName scheme名称
/// @param configurationName Debug/Release
/// @param error 错误
/// @return YES：设置成功；NO：设置失败
+ (BOOL)setupTeamId:(NSString *)teamId
  withXcodeprojFile:(NSString *)xcodeprojFile
         targetName:(NSString *)targetName
  configurationName:(DHConfigurationName)configurationName
                   error:(NSError * _Nullable __autoreleasing * _Nullable)error;
/// 设置版本号
///
/// @param version 版本号
/// @param xcodeprojFile .xcodeproj文件路径
/// @param targetName scheme名称
/// @param configurationName Debug/Release
/// @param error 错误
/// @return YES：设置成功；NO：设置失败
+ (BOOL)setupVersion:(NSString *)version
   withXcodeprojFile:(NSString *)xcodeprojFile
          targetName:(NSString *)targetName
   configurationName:(DHConfigurationName)configurationName
                   error:(NSError * _Nullable __autoreleasing * _Nullable)error;
/// 设置子版本号
///
/// @param buildVersion 子版本号
/// @param xcodeprojFile .xcodeproj文件路径
/// @param targetName scheme名称
/// @param configurationName Debug/Release
/// @param error 错误
/// @return YES：设置成功；NO：设置失败
+ (BOOL)setupBuildVersion:(NSString *)buildVersion
        withXcodeprojFile:(NSString *)xcodeprojFile
               targetName:(NSString *)targetName
        configurationName:(DHConfigurationName)configurationName
                   error:(NSError * _Nullable __autoreleasing * _Nullable)error;
/// 设置enable bitcode
///
/// @param enableBitcode YES/NO
/// @param xcodeprojFile .xcodeproj文件路径
/// @param targetName scheme名称
/// @param configurationName Debug/Release
/// @param error 错误
/// @return YES：设置成功；NO：设置失败
+ (BOOL)setupEnableBitcode:(DHEnableBitcode)enableBitcode
         withXcodeprojFile:(NSString *)xcodeprojFile
                targetName:(NSString *)targetName
         configurationName:(DHConfigurationName)configurationName
                   error:(NSError * _Nullable __autoreleasing * _Nullable)error;
/// 修改所有
///
/// @param xcodeprojFile .xcodeproj文件路径
/// @param targetName scheme名称
/// @param configurationName Debug/Release
/// @param displayName 产品显示名称
/// @param productName 产品名称
/// @param bundleId bundleId
/// @param teamId teamId
/// @param version 版本号
/// @param buildVersion 子版本号
/// @param enableBitcode YES/NO
/// @param error 错误
/// @return YES：设置成功；NO：设置失败
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
                         error:(NSError * _Nullable __autoreleasing * _Nullable)error;


/// 自定义多项设置
/// @discussion 目前只支持info.plist的一级表达式以及pbxproj的buildSettings下的表达式的增删改查
///
/// @param settings <参考DHBuildSettingsKey/DHPlistKey, 设置值> Key也可自定义
/// @param xcodeprojFile .xcodeproj文件路径
/// @param targetName scheme名称
/// @param configurationName Debug/Release
/// @param error 错误
/// @return YES：设置成功；NO：设置失败
+ (BOOL)setupSettings:(NSDictionary <NSString *, NSString *> *)settings
    withXcodeprojFile:(NSString *)xcodeprojFile
           targetName:(NSString *)targetName
    configurationName:(DHConfigurationName)configurationName
                error:(NSError * _Nullable __autoreleasing * _Nullable)error;

#pragma mark -
/// 重置修改
+ (void)resetSetupWithXcodeprojFile:(NSString *)xcodeprojFile;
@end

NS_ASSUME_NONNULL_END
