//
//  XAPProvisioningProfileManager.h
//  XAPSDK
//
//  Created by 菲凡数据 on 2020/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XAPProvisioningProfileModel;
/**
 管理描述文件所有
 */
@interface XAPProvisioningProfileManager : NSObject
/// 单例
+ (instancetype)manager;
/// 预配置
- (void)prepareConfig;

/// 解析描述文件
- (XAPProvisioningProfileModel *)fetchProvisioningProfilesWithPath:(NSString *)path;
/// 获取路径下所有可解析的描述文件
- (NSArray <XAPProvisioningProfileModel *> *)fetchProvisioningProfilesWithDirectory:(NSString *)directory;

/// 筛选已缓存解析的描述文件模型
- (NSArray <XAPProvisioningProfileModel *> *)filterProvisioningProfileByFilterModel:(XAPProvisioningProfileModel *)filterModel;

@end

NS_ASSUME_NONNULL_END
