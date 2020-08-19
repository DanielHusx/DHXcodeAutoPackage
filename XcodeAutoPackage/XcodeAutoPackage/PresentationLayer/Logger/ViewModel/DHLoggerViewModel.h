//
//  DHLoggerViewModel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/18.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DHLoggerViewModelDelegate;

@interface DHLoggerViewModel : NSObject
/// 代理
@property (nonatomic, weak) id<DHLoggerViewModelDelegate> delegate;

/// 初始化
- (instancetype)initWithViewController:(NSViewController *)viewController;

@end

@protocol DHLoggerViewModelDelegate <NSObject>
/// 获取到新的日志信息
- (void)logger:(DHLoggerViewModel *)logger withString:(NSString *)string;
/// 获取到新的日志信息
- (void)logger:(DHLoggerViewModel *)logger withAttributeString:(NSAttributedString *)string;

@end

NS_ASSUME_NONNULL_END
