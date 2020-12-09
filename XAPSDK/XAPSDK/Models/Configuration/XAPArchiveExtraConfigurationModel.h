//
//  XAPArchiveExtraConfigurationModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XAPArchiveExtraConfigurationModel : NSObject

/// 通道
@property (nonatomic, copy) XAPChannel channel;
/// 导出.ipa文件的存储路径
@property (nonatomic, copy) NSString *ipaFileExportPath;

@end

NS_ASSUME_NONNULL_END
