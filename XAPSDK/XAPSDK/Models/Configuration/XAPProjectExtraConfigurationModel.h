//
//  XAPProjectExtraConfigurationModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XAPProjectExtraConfigurationModel : NSObject

/// scheme名称
@property (nonatomic, copy) NSString *schemeName;
/// 配置类型
@property (nonatomic, copy) XAPConfigurationName configurationName;
/// .xcarchive导出路径
@property (nonatomic, copy) NSString *xcarchiveFileExportPath;

/// 当git可用时，是否自动拉取最新代码
@property (nonatomic, assign) BOOL gitPullIfNeed;
/// 当pod可用时，是否自动更新依赖库
@property (nonatomic, assign) BOOL podInstallIfNeed;
/// 导出.xcarchive并使用后是否保留.xcarchive文件
@property (nonatomic, assign) BOOL keepXcarchiveFileIfExist;

@end

NS_ASSUME_NONNULL_END
