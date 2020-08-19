//
//  DHGlobalConfigration.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/14.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHConfigurationProtocol.h"
#import <DHXcodeSDK/DHXcodeSDKConstant.h>
#import <DHXcodeSDK/DHDistributionProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHGlobalConfigration : NSObject <DHConfigurationProtocol, NSSecureCoding, NSCoding, NSCopying>

/// 导出.xcarchive路径
@property (nonatomic, copy) NSString *exportArchiveDirectory;
/// 导出.ipa路径
@property (nonatomic, copy) NSString *exportIPADirectory;
/// 描述文件搜索路径
@property (nonatomic, copy) NSString *profilesDirectory;

/// 配置名称(Debug/Release)
@property (nonatomic, copy) DHConfigurationName configurationName;
/// 分发渠道(development/ad-hoc/entirprise/app-store)
@property (nonatomic, copy) DHChannel channel;

/// 是否保留归档文件，默认YES
@property (nonatomic, assign, getter=isKeepXcarchive) BOOL keepXcarchive;
/// 是否需要Podfile install，默认YES
@property (nonatomic, assign, getter=isNeedPodInstall) BOOL needPodInstall;
/// 是否需要更新，默认NO
@property (nonatomic, assign, getter=isNeedGitPull) BOOL needGitPull;
/// 当前分支并非目标分支时，是否需要强制切分支，默认NO
@property (nonatomic, assign, getter=isForceGitSwitch) BOOL forceGitSwitch;

/// 已经存储的可选的分发平台
@property (nonatomic, strong) NSMutableArray <id<DHDistributionProtocol>> *distributionPlatforms;

+ (instancetype)configuration;

/// 更新
- (void)updateWithConfiguration:(DHGlobalConfigration *)configuration;

@end

NS_ASSUME_NONNULL_END
