//
//  XAPScriptModel.h
//  XAPSDK
//
//  Created by Daniel on 2020/11/30.
//

#import <Foundation/Foundation.h>

/// 命令类型
typedef NS_ENUM(NSInteger, XAPScriptModelType) {
    /// 默认命令类型
    XAPScriptModelTypeDefault,
    /// 延时命令类型
    XAPScriptModelTypeDelay,
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
@property (nonatomic, assign) XAPScriptModelType scriptType;

@end

NS_ASSUME_NONNULL_END
