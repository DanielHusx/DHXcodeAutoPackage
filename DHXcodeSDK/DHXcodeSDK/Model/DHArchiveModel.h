//
//  DHArchiveModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/23.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DHAppModel;
NS_ASSUME_NONNULL_BEGIN

@interface DHArchiveModel : NSObject <NSSecureCoding, NSCoding, NSCopying>

/// 归档文件路径(.xcarchive)
@property (nonatomic, copy) NSString *xcarchiveFile;
/// App信息
@property (nonatomic, strong) DHAppModel *app;

@end

NS_ASSUME_NONNULL_END
