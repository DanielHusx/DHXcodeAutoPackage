//
//  DHScriptModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/6/17.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHScriptModel : NSObject

/// 命令脚本路径
@property (nonatomic, copy) NSString *scriptCommand;
/// 命令数组参数
@property (nonatomic, strong) NSArray <NSString *> *scriptComponent;
/// 是否需要作为管理员执行
@property (nonatomic, assign, getter=isAsAdministrator) BOOL asAdministrator;

@end

NS_ASSUME_NONNULL_END
