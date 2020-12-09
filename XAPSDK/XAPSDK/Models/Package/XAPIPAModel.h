//
//  XAPIPAModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XAPAppModel;
@class XAPInfoPlistModel;

@interface XAPIPAModel : NSObject

/// .ipa安装文件路径
@property (nonatomic, copy) NSString *ipaFilePath;
/// App信息
/// @attention 此属性下的文件为临时文件，不可靠
@property (nonatomic, strong) XAPAppModel *app;
/// info.plist信息
/// @attention 此属性下的文件为临时文件，不可靠
@property (nonatomic, strong) XAPInfoPlistModel *infoPlist;

@end

NS_ASSUME_NONNULL_END
