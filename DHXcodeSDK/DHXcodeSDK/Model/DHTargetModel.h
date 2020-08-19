//
//  DHTargetModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHBuildConfigurationModel;
NS_ASSUME_NONNULL_BEGIN

@interface DHTargetModel : NSObject <NSSecureCoding, NSCoding, NSCopying>
/// scheme
@property (nonatomic, copy) NSString *name;
/// 构建配置
@property (nonatomic, strong) NSArray <DHBuildConfigurationModel *> *buildConfigurations;

@end

NS_ASSUME_NONNULL_END
