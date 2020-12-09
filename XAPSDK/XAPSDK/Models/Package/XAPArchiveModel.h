//
//  XAPArchiveModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XAPAppModel;
@class XAPInfoPlistModel;

@interface XAPArchiveModel : NSObject

/// 归档文件路径(.xcarchive)
@property (nonatomic, copy) NSString *xcarchiveFilePath;
/// App信息
@property (nonatomic, strong) XAPAppModel *app;
/// info.plist信息
@property (nonatomic, strong) XAPInfoPlistModel *infoPlist;

@end

NS_ASSUME_NONNULL_END
