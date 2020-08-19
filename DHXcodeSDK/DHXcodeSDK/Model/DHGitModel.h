//
//  DHGitModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/14.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 Git相关信息
 */
@interface DHGitModel : NSObject <NSSecureCoding, NSCoding, NSCopying>
/// .git文件路径
@property (nonatomic, copy) NSString *gitFile;
/// 当前分支名
@property (nonatomic, copy) NSString *currentBranch;
/// 所有分支名
@property (nonatomic, strong) NSArray <NSString *> *branchs;
/// 所有tag
@property (nonatomic, strong) NSArray <NSString *> *tags;

@property (nonatomic, readonly) NSArray *branchNameOptions;

@end

NS_ASSUME_NONNULL_END
