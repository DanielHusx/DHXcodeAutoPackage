//
//  DHAppModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/23.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHProfileModel;
NS_ASSUME_NONNULL_BEGIN

@interface DHAppModel : NSObject <NSSecureCoding, NSCoding, NSCopying>
/// app文件路径(.app)
@property (nonatomic, copy) NSString *appFile;
/// 产品名称
@property (nonatomic, copy) NSString *productName;
/// App显示名称
@property (nonatomic, copy) NSString *displayName;
/// Bundle Id
@property (nonatomic, copy) NSString *bundleId;
/// 版本号
@property (nonatomic, copy) NSString *version;
/// build号
@property (nonatomic, copy) NSString *buildVersion;
/// enable bitcode
@property (nonatomic, copy) DHEnableBitcode enableBitcode;
/// 可执行文件路径
@property (nonatomic, copy) NSString  *executableFile;
/// profile信息
@property (nonatomic, strong) DHProfileModel *embeddedProfile;

@end

NS_ASSUME_NONNULL_END
