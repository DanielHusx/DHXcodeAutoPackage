//
//  DHBuildConfigurationModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/17.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHXcodeSDKConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHBuildConfigurationModel : NSObject <NSSecureCoding, NSCoding, NSCopying>

/// 配置名称
@property (nonatomic, copy) DHConfigurationName name;
/// 显示名称
@property (nonatomic, copy) NSString *displayName;
/// 产品名称
@property (nonatomic, copy) NSString *productName;
/// Bundle Id
@property (nonatomic, copy) NSString *bundleId;
/// Team Id
@property (nonatomic, copy) NSString *teamId;
/// 版本号
@property (nonatomic, copy) NSString *shortVersion;
/// build号
@property (nonatomic, copy) NSString *buildVersion;
/// enable bitcode
@property (nonatomic, copy) DHEnableBitcode enableBitcode;
/// info.plist的文件路径
@property (nonatomic, copy) NSString *infoPlistFile;

@end

NS_ASSUME_NONNULL_END
