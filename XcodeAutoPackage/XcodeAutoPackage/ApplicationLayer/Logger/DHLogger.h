//
//  DHLogger.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/25.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DHLoggerStatusDelegate;
@protocol DHLoggerDelegate;

@interface DHLogger : NSObject
/// 单例
+ (instancetype)shareLogger;
/// 代理
@property (nonatomic, weak) id<DHLoggerStatusDelegate> statusDelegate;
@property (nonatomic, weak) id<DHLoggerDelegate> delegate;
/// 是否打开详细信息
@property (nonatomic, assign) BOOL verbose;
/// 是否打开日志保存
@property (nonatomic, assign) BOOL enableLog;

@end

@protocol DHLoggerStatusDelegate <NSObject>
- (void)logger:(DHLogger *)logger didReceivedInfo:(NSString *)info;
- (void)logger:(DHLogger *)logger didReceivedWarning:(NSString *)warning;
- (void)logger:(DHLogger *)logger didReceivedError:(NSString *)error;
@end

@protocol DHLoggerDelegate <NSObject>
- (void)logger:(DHLogger *)logger withAttributeString:(NSAttributedString *)attributeString;
@optional
- (void)logger:(DHLogger *)logger withString:(NSString *)string;

@end


NS_ASSUME_NONNULL_END
