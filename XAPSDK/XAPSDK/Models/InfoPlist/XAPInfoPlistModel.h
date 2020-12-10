//
//  XAPInfoPlistModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XAPInfoPlistModel : NSObject

/// 包标识
@property (nonatomic, copy) NSString *bundleIdentifier;
/// 短版本号
@property (nonatomic, copy) NSString *bundleShortVersion;
/// 版本号
@property (nonatomic, copy) NSString *bundleVersion;
/// 产品名
@property (nonatomic, copy) NSString *bundleName;
/// 展示名称
@property (nonatomic, copy) NSString *bundleDisplayName;
/// 可执行文件路径
@property (nonatomic, copy) NSString *executableFile;
/// 是否允许bitcode
@property (nonatomic, copy) XAPEnableBitcode enableBitcode;

@end

NS_ASSUME_NONNULL_END
