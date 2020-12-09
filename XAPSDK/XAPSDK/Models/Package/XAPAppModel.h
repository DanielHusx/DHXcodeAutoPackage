//
//  XAPAppModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XAPProvisioningProfileModel;
@class XAPInfoPlistModel;

@interface XAPAppModel : NSObject

/// .app文件路径
@property (nonatomic, copy) NSString *appFilePath;
/// 描述文件信息
@property (nonatomic, strong) XAPProvisioningProfileModel *embeddedProfile;
/// info.plist信息
@property (nonatomic, strong) XAPInfoPlistModel *infoPlist;

@end

NS_ASSUME_NONNULL_END
