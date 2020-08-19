//
//  DHXMLUtils.h
//  DHXcodeSDK
//
//  Created by Daniel on 2020/8/1.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHXMLUtils : NSObject

/// 创建exportOptions.plist文件
+ (BOOL)createExportOptionsPlist:(NSString *)plistFile
                    withBundleId:(NSString *)bundleId
                          teamId:(NSString *)teamId
                         channel:(DHChannel)channel
                     profileName:(NSString *)profileName
                   enableBitcode:(DHEnableBitcode)enableBitcode;


/// 读取解析info.plist文件
/// 可识别.xcarchive、.app、项目内的info.plist
///
/// @param plistFile .plist路径
/// @param displayName 展示名称(除.xcarchive中info.plist)，不存在时以productName为准
/// @param productName 产品名称(除.xcarchive中info.plist)，可能为$(PRODUCT_NAME)(一般项目内可能，而.app内为直接值)
/// @param bundleId 唯一标识，可能为$(PRODUCT_BUNDLE_IDENTIFIER)
/// @param version 版本号，可能为$(MARKETING_VERSION)(项目中)
/// @param buildVersion 子版本号，可能为$(CURRENT_PROJECT_VERSION)(项目中)
/// @param executableFile 可执行文件相对路径(除.xcarchive中info.plist)，可能为$(EXECUTABLE_NAME)(项目中）参考价值不大，在.app中为直接值才有用
/// @param applicationPath .app文件相对路径，只存在于.xcarchive中info.plist
/// @param teamId 团队标识，只存在于.xcarchive中info.plist
/// @return YES: 正确解析；NO: 解析失败
+ (BOOL)readInfoPlistFile:(NSString *)plistFile
           forDisplayName:(NSString * __autoreleasing _Nullable * _Nullable)displayName
              productName:(NSString * __autoreleasing _Nullable * _Nullable)productName
                 bundleId:(NSString * __autoreleasing _Nullable * _Nullable)bundleId
                  version:(NSString * __autoreleasing _Nullable * _Nullable)version
             buildVersion:(NSString * __autoreleasing _Nullable * _Nullable)buildVersion
           executableFile:(NSString * __autoreleasing _Nullable * _Nullable)executableFile
          applicationPath:(NSString * __autoreleasing _Nullable * _Nullable)applicationPath
                   teamId:(NSString * __autoreleasing _Nullable * _Nullable)teamId;

/// 解析info.plist为字典
/// @param plistFile .plist文件
+ (NSDictionary *)dictionaryForInfoPlistFile:(NSString *)plistFile;

@end

NS_ASSUME_NONNULL_END
