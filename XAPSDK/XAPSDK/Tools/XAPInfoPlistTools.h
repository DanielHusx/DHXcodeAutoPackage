//
//  XAPInfoPlistTools.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XAPInfoPlistTools : NSObject

/// 解析由.mobileprovision文件导出的.plist文件
///
/// @param plistFileOrDictionary .plist文件路径或字典数据
/// @param profileName 描述文件名称
/// @param bundleIdentifier 包标识
/// @param teamIdentifier 团队标识
/// @param applicationIdentifier 应用标识
/// @param uuid 用户唯一标识
/// @param teamName 团队名称
/// @param channel 通道
/// @param createTimestamp 创建时间戳
/// @param expireTimestamp 过期时间戳
/// @param entitlements 权限集合
/// @return 解析后的字典数据
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
                                                             entitlements:(NSDictionary * _Nullable __autoreleasing * _Nullable)entitlements;

/// 解析存在于项目或.app内的info.plist文件
///
/// @param plistFileOrDictionary .plist文件路径或字典数据
/// @param displayName 产品显示名称
/// @param productName 项目名称
/// @param bundleIdentifier 包标识
/// @param shortVersion 短版本号
/// @param version 版本号
/// @param executableFile 可执行文件路径
/// @return 解析后的字典数据
+ (NSDictionary *)parseProjectOrAppInfoPlistFileWithPlistFileOrDictionary:(NSString *)plistFileOrDictionary
                                                              displayName:(NSString * __autoreleasing _Nullable * _Nullable)displayName
                                                              productName:(NSString * __autoreleasing _Nullable * _Nullable)productName
                                                         bundleIdentifier:(NSString * __autoreleasing _Nullable *  _Nullable)bundleIdentifier
                                                             shortVersion:(NSString * __autoreleasing _Nullable * _Nullable)shortVersion
                                                                  version:(NSString * __autoreleasing _Nullable * _Nullable)version
                                                           executableFile:(NSString * __autoreleasing _Nullable * _Nullable)executableFile;

/// 解析存在于.xcarchive文件下的info.plist文件
/// @param plistFileOrDictionary .plist文件路径或字典数据
/// @param name 显示名称
/// @param schemeName 项目名称
/// @param creationDate 创建时间
/// @param applicationPath 产品相对路径
/// @param bundleIdentifier 包标识
/// @param teamIdentifier 团队标识
/// @param shortVersion 短版本号
/// @param version 版本号
/// @param architectures 可支持的架构数组 (arm64, armv7, x86)
/// @param signingIdentity 签名类型（Apple Development, Apple Distribution, iOS Development, iOS Distribution)
/// @return 解析后的字典数据
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
                                                   signingIdentity:(NSString * __autoreleasing _Nullable * _Nullable)signingIdentity;

/// 创建用于导包的信息文件
///
/// @param plistFile [out] 信息文件存储路径
/// @param bundleIdentifier 包标识
/// @param teamIdentifier 团队标识
/// @param channel 通道
/// @param profileName 描述文件名称
/// @param enableBitcode 是否允许bitcode
/// @return 是否创建成功
+ (BOOL)createExportOptionsPlist:(NSString *)plistFile
            withBundleIdentifier:(NSString *)bundleIdentifier
                  teamIdentifier:(NSString *)teamIdentifier
                         channel:(XAPChannel)channel
                     profileName:(NSString *)profileName
                   enableBitcode:(XAPEnableBitcode)enableBitcode;

@end

NS_ASSUME_NONNULL_END
