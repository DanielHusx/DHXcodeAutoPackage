//
//  DHIPAModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/23.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHAppModel;
NS_ASSUME_NONNULL_BEGIN

@interface DHIPAModel : NSObject <NSSecureCoding, NSCoding, NSCopying>

/// 安装文件路径(.ipa)
@property (nonatomic, copy) NSString *ipaFile;
/// App信息
@property (nonatomic, strong) DHAppModel *app;

@end

NS_ASSUME_NONNULL_END
