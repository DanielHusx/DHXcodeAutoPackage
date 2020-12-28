//
//  XAPArchiveExtraConfigurationModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XAPProvisioningProfileModel;

@interface XAPArchiveExtraConfigurationModel : NSObject

/// 通道
@property (nonatomic, copy) XAPChannel channel;
/// 导出.ipa文件的存储路径
@property (nonatomic, copy) NSString *ipaFileExportPath;
/// 配置的描述文件，一般只用于记录选中的配置
@property (nonatomic, strong) XAPProvisioningProfileModel *provisioningProfile;

@end

NS_ASSUME_NONNULL_END
