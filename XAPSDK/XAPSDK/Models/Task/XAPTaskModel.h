//
//  XAPTaskModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class XAPEngineerModel;
@class XAPConfigurationModel;

@interface XAPTaskModel : NSObject

/// 源路径
@property (nonatomic, copy) NSString *path;
/// 工程信息
@property (nonatomic, strong) XAPEngineerModel *engineer;
/// 配置信息
@property (nonatomic, strong) XAPConfigurationModel *configuration;

@end

NS_ASSUME_NONNULL_END
