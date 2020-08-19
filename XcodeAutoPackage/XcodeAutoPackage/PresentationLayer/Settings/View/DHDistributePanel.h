//
//  DHDistributePanel.h
//  XcodeAutoPackage
//
//  Created by Daniel on 2020/7/8.
//  Copyright © 2020 Daniel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHDistributePanel : NSPanel

/// 展示发布panel
/// @param window 显示window
/// @param callback 回调
+ (void)showWithWindow:(NSWindow *)window
              platform:(nullable NSString *)platform
              nickname:(nullable NSString *)nickname
                apiKey:(nullable NSString *)apiKey
       installPassword:(nullable NSString *)installPassword
              callback:(nonnull void (^) (NSString *platform, NSString *nickname, NSString *apiKey, NSString *installPassword))callback;
@end

NS_ASSUME_NONNULL_END
