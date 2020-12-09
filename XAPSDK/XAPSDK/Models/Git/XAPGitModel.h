//
//  XAPGitModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XAPGitModel : NSObject

/// .git文件路径
@property (nonatomic, copy) NSString *gitFilePath;
/// 当前分支
@property (nonatomic, copy) NSString *currentBranch;
/// 分支列表
@property (nonatomic, copy) NSArray *branchs;

@end

NS_ASSUME_NONNULL_END
