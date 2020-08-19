//
//  DHProjectModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHTargetModel;
NS_ASSUME_NONNULL_BEGIN
/**
 工程模型，装载一个project所有信息
 */
@interface DHProjectModel : NSObject <NSSecureCoding, NSCoding, NSCopying>

/// 项目文件路径
@property (nonatomic, copy) NSString *xcodeprojFile;
/// Target
@property (nonatomic, strong) NSArray <DHTargetModel *> *targets;

@end

NS_ASSUME_NONNULL_END
