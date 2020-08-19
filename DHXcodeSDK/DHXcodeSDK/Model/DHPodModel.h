//
//  DHPodModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/13.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 Pod相关信息
 */
@interface DHPodModel : NSObject <NSCoding, NSSecureCoding, NSCopying>
/// Podfile文件路径
@property (nonatomic, copy) NSString *podfilePath;

@end

NS_ASSUME_NONNULL_END
