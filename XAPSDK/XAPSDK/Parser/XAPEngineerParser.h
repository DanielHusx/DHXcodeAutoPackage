//
//  XAPEngineerParser.h
//  XAPSDK
//
//  Created by 菲凡数据 on 2020/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XAPWorkspaceModel;
@class XAPProjectModel;
@class XAPPodModel;
@class XAPGitModel;
@class XAPArchiveModel;
@class XAPIPAModel;

@interface XAPEngineerParser : NSObject

/// 单例
+ (instancetype)sharedParser;

- (XAPWorkspaceModel *)parseWorkspaceWithXcworkspaceFile:(NSString *)xcworkspaceFile;

- (XAPProjectModel *)parseProjectWithXcodeprojFile:(NSString *)xcodeprojFile;

- (XAPIPAModel *)parseIPAWithIPAFile:(NSString *)ipaFile;

- (XAPArchiveModel *)parseArchiveWithXcarchiveFile:(NSString *)xcarchiveFile;

- (XAPGitModel *)parseGitWithGitFile:(NSString *)gitFile;

- (XAPPodModel *)parsePodWithPodFile:(NSString *)podFile;

@end

NS_ASSUME_NONNULL_END
