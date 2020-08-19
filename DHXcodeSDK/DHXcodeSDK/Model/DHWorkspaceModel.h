//
//  DHWorkspaceModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHProjectModel;
NS_ASSUME_NONNULL_BEGIN
/**
工作空间模型，装载工作空间关联信息
*/
@interface DHWorkspaceModel : NSObject <NSSecureCoding, NSCoding, NSCopying>
/// 工程文件路径
@property (nonatomic, copy) NSString *xcworkspaceFile;
/// 项目信息
@property (nonatomic, strong) NSArray <DHProjectModel *> *projects;

@end

NS_ASSUME_NONNULL_END
