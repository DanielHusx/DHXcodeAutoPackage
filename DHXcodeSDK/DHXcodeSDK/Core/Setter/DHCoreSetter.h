//
//  DHCoreSetter.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHProjectModel;
NS_ASSUME_NONNULL_BEGIN
/**
 修改项目配置
 */
@interface DHCoreSetter : NSObject

/// 设置
///
/// @discussion 目前只支持info.plist的一级表达式以及pbxproj的buildSettings下的表达式的增删改查
///
/// @param settings <设置Key可参考DHBuildSettingsKey/DHPlistKey，值>字典
/// @param xcodeprojFile .xcodeproj文件路径
/// @param targetName scheme名称
/// @param configurationName Debug/Release
/// @param setterResult 设置结果<DHDBSetterKey，YES/NO>
/// @return NO: 设置失败；YES: 设置成功（全部设置成功，才算）
+ (DHERROR_CODE)setupSettings:(NSDictionary <NSString *, NSString *> *)settings
            withXcodeprojFile:(NSString *)xcodeprojFile
                   targetName:(NSString *)targetName
            configurationName:(DHConfigurationName)configurationName
                 setterResult:(NSDictionary <NSString *, NSNumber *> * _Nullable * _Nullable)setterResult;

/// 重置所有修改
/// @param xcodeprojFile .xcodeproj文件路径
+ (DHERROR_CODE)resetAllSetupWithXcodeprojFile:(NSString *)xcodeprojFile;

@end

NS_ASSUME_NONNULL_END
