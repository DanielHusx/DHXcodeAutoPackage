//
//  XAPScriptModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/11/30.
//

#import <Foundation/Foundation.h>

/// 命令类型
typedef NS_ENUM(NSInteger, XAPScriptType) {
    /// 默认命令类型：即时命令
    XAPScriptTypeDefault,
    /// 延时命令类型
    XAPScriptTypeDelay,
};

NS_ASSUME_NONNULL_BEGIN

@interface XAPScriptModel : NSObject

/// 命令脚本路径
@property (nonatomic, copy) NSString *scriptPath;
/// 命令数组参数
@property (nonatomic, strong) NSArray <NSString *> *scriptArguments;
/// 是否需要作为管理员执行
@property (nonatomic, assign, getter=isAsAdministrator) BOOL asAdministrator;
/// 命令类型
@property (nonatomic, assign) XAPScriptType scriptType;

/// 构造方法
+ (instancetype)scriptModelWithScriptPath:(NSString *)scriptPath;

@end

NS_ASSUME_NONNULL_END
